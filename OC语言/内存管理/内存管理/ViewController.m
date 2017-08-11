//
//  ViewController.m
//  内存管理
//
//  Created by walg on 2017/8/9.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
@interface ViewController ()

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

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    NSLog(@"---------->>>开始<<<----------");
    NSLog(@"Ori_address----->>>>>>：value:%@---%p==%p",_str,_str,&_str);
    NSLog(@"address----->>>>>>C1：value:%@---%p==%p",_strC1,_strC1,&_strC1);
    NSLog(@"address----->>>>>>S1：value:%@---%p==%p",_strS1,_strS1,&_strS1);
    NSLog(@"address----->>>>>>C2：value:%@---%p==%p",_strC2,_strC2,&_strC2);
    NSLog(@"address----->>>>>>S2：value:%@---%p==%p",_strS2,_strS2,&_strS2);
    NSLog(@"address----->>>>>>C3：value:%@---%p==%p",_strC3,_strC3,&_strC3);
    NSLog(@"address----->>>>>>S3：value:%@---%p==%p",_strS3,_strS3,&_strS3);
    NSLog(@"address----->>>>>>C4：value:%@---%p==%p",_strC4,_strC4,&_strC4);
    NSLog(@"address----->>>>>>S4：value:%@---%p==%p",_strS4,_strS4,&_strS4);
    NSLog(@"---------->>>结束<<<----------\n");

}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
//    self.str = [_str stringByAppendingString:@"de"];
//    [_str appendString:@"de"];
    
    NSLog(@"---------->>>点击开始输出<<<----------");
    NSLog(@"Ori_address<<<<<<----->>>>>>：value:%@---%p==%p",_str,_str,&_str);
    NSLog(@"address<<<<<<----->>>>>>C1：value:%@---%p==%p",_strC1,_strC1,&_strC1);
    NSLog(@"address<<<<<<----->>>>>>S1：value:%@---%p==%p",_strS1,_strS1,&_strS1);
    NSLog(@"address<<<<<<----->>>>>>C2：value:%@---%p==%p",_strC2,_strC2,&_strC2);
    NSLog(@"address<<<<<<----->>>>>>S2：value:%@---%p==%p",_strS2,_strS2,&_strS2);
    NSLog(@"address<<<<<<----->>>>>>C3：value:%@---%p==%p",_strC3,_strC3,&_strC3);
    NSLog(@"address<<<<<<----->>>>>>S3：value:%@---%p==%p",_strS3,_strS3,&_strS3);
    NSLog(@"address<<<<<<----->>>>>>C4：value:%@---%p==%p",_strC4,_strC4,&_strC4);
    NSLog(@"address<<<<<<----->>>>>>S4：value:%@---%p==%p",_strS4,_strS4,&_strS4);
    NSLog(@"---------->>>点击结束输出<<<----------\n");

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
