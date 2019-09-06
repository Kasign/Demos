//
//  ViewController.m
//  面试总结
//
//  Created by Walg on 2019/8/27.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "ViewController.h"
#import <sys/sysctl.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [self viewAndView];
    
    __block int a = 0;
    while (a < 5) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            a ++;
            NSLog(@"%@ - %d", [NSThread currentThread], a);
        });
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"最终结果 ***** %@ - %d", [NSThread currentThread], a);
    });
    
    NSLog(@" >>>>--- >>> %d", a);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self test];
//    NSInteger result = [self addNum:1 resultNum:0];
//    NSLog(@"%ld", result);
//    [self drawLine];
    
    if (isDebugger()) {
        NSLog(@"123");
    }
    
//    [NSThread exit];//主线程可以退出，但是不影响子线程的运行
    
//    exit(0);//杀掉应用
}

- (void)test {
    
    __block int i = 10;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%d", i);
    });
    i = 20;
}

- (NSInteger)addNum:(NSInteger)num resultNum:(NSInteger)resultNum {
    
    if (num <= 10 && num >= 1) {
        resultNum += num;
        resultNum = [self addNum:num + 1 resultNum:resultNum];
    }
    
    return resultNum;
}

- (void)drawLine {
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 0, 1)];
    [line setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:line];
    
//    [UIView beginAnimations:@"frame" context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:8];
//
//    [line setFrame:CGRectMake(100, 100, 100, 1)];
//
//    [UIView commitAnimations];
//
    [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:2 initialSpringVelocity:2 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [line setFrame:CGRectMake(100, 100, 100, 1)];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)viewAndView
{
    UIView * aView = [[UIView alloc] init];
    UIView * bView = [[UIView alloc] init];
    
    [self.view addSubview:aView];
    [aView addSubview:bView];

    
    [aView setBackgroundColor:[UIColor redColor]];
    [bView setBackgroundColor:[UIColor purpleColor]];
    
    aView.layer.anchorPoint = CGPointMake(0, 0);
    
    aView.frame = CGRectMake(100, 100, 100, 100);
    aView.transform = CGAffineTransformMakeScale(2, 2);
    bView.frame = CGRectMake(0, 0, 50, 50);


    NSLog(@"%@ - %@ - %@ \n %@ - %@ - %@", NSStringFromCGRect(aView.frame), NSStringFromCGRect(aView.bounds), NSStringFromCGPoint(aView.center), NSStringFromCGRect(bView.frame), NSStringFromCGRect(bView.bounds), NSStringFromCGPoint(bView.center));
    
    UIView * cView = [[UIView alloc] initWithFrame:CGRectMake(100, 0, 1, 95)];
    UIView * dView = [[UIView alloc] initWithFrame:CGRectMake(200, 0, 1, 100)];
    [cView setBackgroundColor:[UIColor blackColor]];
    [dView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:cView];
    [self.view addSubview:dView];
}

BOOL isDebugger () {
    
    int name[4];
    name[0] = CTL_KERN;
    name[1] = KERN_PROC;
    name[2] = KERN_PROC_PID;
    name[3] = getpid();
    
    struct kinfo_proc info;
    size_t info_size = sizeof(info);
    
    int error = sysctl(name, sizeof(name)/sizeof(*name), &info, &info_size, 0, 0);
    assert(error == 0);
    
    return info.kp_proc.p_flag & P_TRACED;
}

@end
