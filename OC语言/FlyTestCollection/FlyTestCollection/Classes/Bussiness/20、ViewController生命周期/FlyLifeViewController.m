//
//  FlyLifeViewController.m
//  FlyTestCollection
//
//  Created by Walg on 2025/8/16.
//

#import "FlyLifeViewController.h"

#define LOG2 FLYTIMELog(@" --- %s view:%p superview:%p alpha:%f isHidden:%d", __func__, self.view, self.view.superview, self.view.alpha, self.view.isHidden)

@interface FlyLifeViewController ()

@end

@implementation FlyLifeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Second";

    UIButton *popBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [popBtn setTitle:@"Pop" forState:UIControlStateNormal];
    popBtn.frame = CGRectMake(0, 0, 120, 44);
    popBtn.center = self.view.center;
    [popBtn addTarget:self action:@selector(popTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popBtn];

    // 加一个会触发长时间任务/弱引用的示例，帮助观察转场期间的行为（可注释）
    // dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //     NSLog(@"Delayed log in SecondViewController");
    // });
}

- (void)popTapped {
    FLYTIMELog(@" ============= pop");
    [self.navigationController popViewControllerAnimated:YES];
}

@end
