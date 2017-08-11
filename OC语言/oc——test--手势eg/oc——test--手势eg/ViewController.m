//
//  ViewController.m
//  oc——test--手势eg
//
//  Created by walg on 2017/7/24.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
@interface ViewController ()
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;
@property (nonatomic, strong) UIView *view4;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITextField *textField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.view1];
    [self.view1 addSubview:self.view2];
    [self.view1 addSubview:self.view3];
    [self.view addSubview:self.label];
    [self.view addSubview:self.textField];
    
    [self.textField becomeFirstResponder];
    
}
- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context{
    NSLog(@"keyPath = %@",keyPath);
    NSLog(@"change = %@",change);
}

-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 40, 30)];
        [_label setBackgroundColor:[UIColor grayColor]];
        [_label setText:@"123"];
        [_label addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    }
    return _label;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [_label setText:@"123"];
}

-(UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(120, 50, 200, 30)];
        [_textField setBackgroundColor:[UIColor grayColor]];
    }
    return _textField;
}

-(UIView *)view1{
    if (!_view1) {
        _view1 = [[UIView alloc] initWithFrame:CGRectMake(10, 80, 300, 400)];
        [_view1 setBackgroundColor:[UIColor purpleColor]];
        [_view1 setUserInteractionEnabled:YES];
        UISwipeGestureRecognizer *swipG = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipAction:)];
//        swipG.enabled = NO;
        [_view1 addGestureRecognizer:swipG];
        
    }
    return _view1;
}

-(UIView *)view2{
    if (!_view2) {
        _view2 = [[UIView alloc] initWithFrame:CGRectMake(10, 40, 300, 400)];
        _view2.opaque = YES;
        [_view2 setBackgroundColor:[UIColor yellowColor]];
        [_view2 setUserInteractionEnabled:YES];
        UILongPressGestureRecognizer *longG = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
//        swipG.enabled = NO;
        [_view2 addGestureRecognizer:longG];
        
    }
    return _view2;
}

-(UIView *)view3{
    if (!_view3) {
        _view3 = [[UIView alloc] initWithFrame:CGRectMake(10, 80, 300, 400)];
        [_view3 setBackgroundColor:[UIColor blueColor]];
        [_view3 setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.enabled = NO;
        [_view3 addGestureRecognizer:tap];
        
    }
    return _view3;
}

-(UIView *)view4{
    if (!_view4) {
        _view4 = [[UIView alloc] initWithFrame:CGRectMake(10, 80, 300, 400)];
        [_view4 setBackgroundColor:[UIColor purpleColor]];
        [_view4 setUserInteractionEnabled:YES];
        UISwipeGestureRecognizer *swipG = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipAction:)];
        swipG.enabled = NO;
        [_view4 addGestureRecognizer:swipG];
        
    }
    return _view4;
}

-(void)panAction:(UIPanGestureRecognizer*)pan{
    NSLog(@"view4 - panAction");
}

-(void)longAction:(UILongPressGestureRecognizer*)longG{
    NSLog(@"view2 - longAction");
}

-(void)swipAction:(UISwipeGestureRecognizer*)swipG{
//    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
//    unsigned int count = 0;
//    Method *methodList = class_copyMethodList([keyWindow class], &count);
//    for (int i = 0; i<count; i++) {
//        Method method = methodList[i];
//        NSLog(@"name:%@",NSStringFromSelector(method_getName(method)));
//    }
//    free(methodList);
//    UIView *nextResponder = [keyWindow nextResponder];
//    UIView * firstResponder = [keyWindow performSelector:@selector(_firstResponder)];
//    UIView * _firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    
    NSMutableString * str1 = [[NSMutableString alloc] initWithFormat:@"aabeebbacedad"];
    
    for(int i= 0;i < str1.length- 1;i++)
    {
        for (int j = i + 1;j < str1.length; j++)
        {
            // 由于字符的特殊性 无法使用 字符串 isEqualToString 进行比较 只能转化为ASCII 值进行比较 所以 需要加 unsigined 修饰
            
            unsigned char a = [str1 characterAtIndex:i];
            
            unsigned char b = [str1 characterAtIndex:j];
            
            if(a == b)
            {
                if (j -i > 1)
                {
                    
                    // NSRange: 截取字符串  {j, 1} j: 第一个字符开始 1: 截取几个字符
                    
                    NSRange range = {j, 1};
                    
                    [str1 deleteCharactersInRange:range];
                    
                    j = i--;
                    
                }
                
            }
            
        }
        
    }
    NSLog(@"------%@-------", str1);
    NSLog(@"view1-swipAction ------->>>>>>");
    
}

-(void)tapAction:(UITapGestureRecognizer*)tap{
    NSLog(@"view3-tapAction");
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
