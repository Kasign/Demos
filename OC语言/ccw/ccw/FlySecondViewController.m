//
//  FlySecondViewController.m
//  ccw
//
//  Created by Walg on 2017/5/20.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import "FlySecondViewController.h"
#import "HVWLuckyWheel.h"

@interface FlySecondViewController ()<FinishAnimationDelegate>

@end

@implementation FlySecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"看运气";

    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [backImage setImage:[UIImage imageNamed:@"LuckyBackground.jpg"]];
    [self.view addSubview:backImage];
    
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 30)];
    [topLabel setBackgroundColor:[UIColor clearColor]];
    [topLabel setTextAlignment:NSTextAlignmentCenter];
    [topLabel setCenter:CGPointMake(MainWidth/2.0, 50)];
    [topLabel setText:@"选择星座，再开始转轮盘"];
    [topLabel setTextColor:[UIColor yellowColor]];
    [self.view addSubview:topLabel];

    
    // 加载转盘
    HVWLuckyWheel *luckyWheel = [HVWLuckyWheel hvwLuckyWheel];
    luckyWheel.finishDelegate = self;
    luckyWheel.center = CGPointMake(self.view.frame.size.width/2, 220);
    [luckyWheel startRotate];
    
    [self.view addSubview:luckyWheel];

}

-(void)didFinish{
    
    int num = arc4random()%40;
    
    NSString *message = [NSString stringWithFormat:@"幸运数字是：%d",num];
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"记住了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setValue:@(num) forKey:@"luckNum"];
        
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
