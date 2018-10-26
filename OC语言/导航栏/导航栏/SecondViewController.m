//
//  SecondViewController.m
//  导航栏
//
//  Created by 66-admin-qs. on 2018/10/10.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "SecondViewController.h"
#import "ThirdViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"二级页面"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 100, 40)];
    [button setBackgroundColor:[UIColor redColor]];
    [button setTitle:@"跳转" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [button setCenter:CGPointMake(self.view.frame.size.width * 0.5, 300)];
    [button addTarget:self action:@selector(pushToVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)pushToVC {
    
    ThirdViewController * vc = [[ThirdViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end
