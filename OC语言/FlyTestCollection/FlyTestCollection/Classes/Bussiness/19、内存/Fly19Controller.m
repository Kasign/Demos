//
//  Fly19Controller.m
//  FlyTestCollection
//
//  Created by Walg on 2024/3/7.
//

#import "Fly19Controller.h"

@interface Fly19Controller ()

@property (nonatomic, strong) NSMutableString *strM;
@property (nonatomic, strong) NSString *str;

@property (nonatomic, copy) NSString *strC1;
@property (nonatomic, copy) NSString *strC2;
@property (nonatomic, copy) NSMutableString *strC3;
@property (nonatomic, copy) NSMutableString *strC4;

@property (nonatomic, strong) NSString *strS1;
@property (nonatomic, strong) NSString *strS2;
@property (nonatomic, strong) NSMutableString *strS3;
@property (nonatomic, strong) NSMutableString *strS4;

@end

@implementation Fly19Controller

+ (NSString *)functionName {
    
    return @"内存管理";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];
}

- (void)test {
    
    self.str = [NSString stringWithFormat:@"abc"];
    
//    self.str = [NSMutableString stringWithFormat:@"abc"];
    
    
    self.strC1 = self.str;
    self.strS1 = self.str;
    
    self.strC3 = self.str;
    self.strS3 = self.str;
    
    self.strC2 =  [NSString stringWithFormat:@"%@",self.str];
    self.strS2 =  [NSString stringWithFormat:@"%@",self.str];
    
    self.strC4 =  (NSMutableString*)[NSString stringWithFormat:@"%@",self.str];
    self.strS4 =  (NSMutableString*)[NSString stringWithFormat:@"%@",self.str];
    
    FLYLog(@"---------->>>开始<<<----------");
    FLYLog(@"Ori_address----->>>>>>：value:%@---%p==%p",_str,_str,&_str);
    FLYLog(@"address----->>>>>>C1：value:%@---%p==%p",_strC1,_strC1,&_strC1);
    FLYLog(@"address----->>>>>>S1：value:%@---%p==%p",_strS1,_strS1,&_strS1);
    FLYLog(@"address----->>>>>>C2：value:%@---%p==%p",_strC2,_strC2,&_strC2);
    FLYLog(@"address----->>>>>>S2：value:%@---%p==%p",_strS2,_strS2,&_strS2);
    FLYLog(@"address----->>>>>>C3：value:%@---%p==%p",_strC3,_strC3,&_strC3);
    FLYLog(@"address----->>>>>>S3：value:%@---%p==%p",_strS3,_strS3,&_strS3);
    FLYLog(@"address----->>>>>>C4：value:%@---%p==%p",_strC4,_strC4,&_strC4);
    FLYLog(@"address----->>>>>>S4：value:%@---%p==%p",_strS4,_strS4,&_strS4);
    FLYLog(@"---------->>>结束<<<----------\n");
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
//    self.str = [_str stringByAppendingString:@"de"];
//    [_str appendString:@"de"];
    
    FLYLog(@"---------->>>点击开始输出<<<----------");
    FLYLog(@"Ori_address<<<<<<----->>>>>>：value:%@---%p==%p",_str,_str,&_str);
    FLYLog(@"address<<<<<<----->>>>>>C1：value:%@---%p==%p",_strC1,_strC1,&_strC1);
    FLYLog(@"address<<<<<<----->>>>>>S1：value:%@---%p==%p",_strS1,_strS1,&_strS1);
    FLYLog(@"address<<<<<<----->>>>>>C2：value:%@---%p==%p",_strC2,_strC2,&_strC2);
    FLYLog(@"address<<<<<<----->>>>>>S2：value:%@---%p==%p",_strS2,_strS2,&_strS2);
    FLYLog(@"address<<<<<<----->>>>>>C3：value:%@---%p==%p",_strC3,_strC3,&_strC3);
    FLYLog(@"address<<<<<<----->>>>>>S3：value:%@---%p==%p",_strS3,_strS3,&_strS3);
    FLYLog(@"address<<<<<<----->>>>>>C4：value:%@---%p==%p",_strC4,_strC4,&_strC4);
    FLYLog(@"address<<<<<<----->>>>>>S4：value:%@---%p==%p",_strS4,_strS4,&_strS4);
    FLYLog(@"---------->>>点击结束输出<<<----------\n");

}

@end
