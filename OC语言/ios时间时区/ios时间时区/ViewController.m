//
//  ViewController.m
//  ios时间时区
//
//  Created by walg on 2017/8/15.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *now = [NSDate date];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];//时间戳格式化
    
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss"; // 格式化年月日，时分秒
    
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    
    NSString *systemTimeZoneStr =  [df stringFromDate:now];
    
    df.timeZone = [NSTimeZone defaultTimeZone];//默认时区，貌似和上一个没什么区别
    NSString *defaultTimeZoneStr = [df stringFromDate:now];
    
    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0 * 3600];//直接指定时区
    NSString *plus8TZStr = [df stringFromDate:now];
    
    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:-4*3600];//这就是GMT+0时区了
    
    NSString *gmtTZStr = [df stringFromDate:now];
    
    NSLog(@"Test Time\nSys:%@\nDefault:%@\n+8:%@\nGMT:%@",systemTimeZoneStr,defaultTimeZoneStr,plus8TZStr,gmtTZStr);

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
