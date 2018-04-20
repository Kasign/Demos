//
//  FlyHomeViewController.m
//  单例测试
//
//  Created by Q on 2018/4/20.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "FlyHomeViewController.h"
#import "FlySecondViewController.h"
#import "FlyThirdViewController.h"
#import "FlyButton.h"

@interface FlyHomeViewController ()

@end

@implementation FlyHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FlyButton * button = [[FlyButton alloc] initWithFrame:CGRectMake(100, 100, 180, 20)];
    [button setTitle:@"跳转第二页面" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    __weak typeof(self) weakSelf = self;
    [button setButtonBlock:^(FlyButton *sender) {
        FlySecondViewController * secondVC = [[FlySecondViewController alloc] init];
        [weakSelf.navigationController pushViewController:secondVC animated:YES];
    }];
    [self.view addSubview:button];
    
    FlyButton * thirdButton = [[FlyButton alloc] initWithFrame:CGRectMake(100, 200, 180, 20)];
    [thirdButton setTitle:@"跳转第三页面" forState:UIControlStateNormal];
    [thirdButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [thirdButton setButtonBlock:^(FlyButton *sender) {
        FlyThirdViewController * secondVC = [[FlyThirdViewController alloc] init];
        [weakSelf.navigationController pushViewController:secondVC animated:YES];
    }];
    [self.view addSubview:thirdButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
