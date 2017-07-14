//
//  FlySecurityView.m
//  ccw
//
//  Created by Walg on 2017/6/7.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>
#import "FlySecurityView.h"
#import "LocalAuthentication/LocalAuthentication.h"

@implementation FlySecurityView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatViews];
    }
    return self;
}

-(void)creatViews{
    
    UIButton *touchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [touchButton.layer setCornerRadius:4];
    [touchButton setBackgroundColor:[UIColor greenColor]];
    [touchButton setTitle:@"指纹解锁" forState:UIControlStateNormal];
    [touchButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [touchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [touchButton addTarget:self action:@selector(userTouchID) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *numberButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    [numberButton.layer setCornerRadius:4];
    [numberButton setBackgroundColor:[UIColor greenColor]];
    [numberButton setTitle:@"密码解锁" forState:UIControlStateNormal];
    [numberButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [numberButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [numberButton addTarget:self action:@selector(userNumber) forControlEvents:UIControlEventTouchUpInside];
    
    NSError *error = nil;
    LAContext  *context = [LAContext new];
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        [touchButton setCenter:CGPointMake(MainWidth/2.0, self.frame.size.height/2.0-20)];
        [numberButton setCenter:CGPointMake(MainWidth/2.0, self.frame.size.height/2.0+20)];
        [self addSubview:touchButton];
        [self addSubview:numberButton];
        
        NSLog(@"支持指纹识别");
    }else{
        NSLog(@"不支持指纹识别");
        [numberButton setCenter:CGPointMake(MainWidth/2.0, self.frame.size.height/2.0)];
        [self addSubview:numberButton];
        NSLog(@"%@",error.localizedDescription);
    }
}

-(void)userTouchID{
    LAContext  *context = [LAContext new];
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"使用指纹解锁" reply:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self removeFromSuperview];
            });
        }else{
            
        }
    }];
    
}

-(void)userNumber{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSString *securityStr = [user stringForKey:@"security"];
    NSString *title;
    NSString *message;
    if (!securityStr) {
        title = @"设置密码";
        message = @"还没有密码，输入密码";
    }else{
        title = @"输入密码";
        message = @"";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    __block UITextField *tf = nil;
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        tf = textField;
        textField.secureTextEntry = YES;
        textField.backgroundColor = [UIColor whiteColor];
    }];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        if (securityStr) {
            if ([[self MD5ForLower32Bate:tf.text] isEqualToString:securityStr]) {
                [self removeFromSuperview];
            }else{
                tf.text = @"";
            }
            
            
        }else{
            [user setValue:[self MD5ForLower32Bate:tf.text] forKey:@"security"];
            [self removeFromSuperview];
        }
        
    }];
    
    [alert addAction:cancel];
    [alert addAction:confirm];
    
    [[self getCurrentVC] presentViewController:alert animated:YES completion:nil];
}

-(UIViewController*)getCurrentVC{
    UIViewController *result = nil;
    UIResponder *responder = [self.superview nextResponder];
    if ([responder isKindOfClass:[UIViewController class]]) {
        result = (UIViewController*)responder;
    }
    return result;
}

-(NSString *)MD5ForLower32Bate:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}

@end
