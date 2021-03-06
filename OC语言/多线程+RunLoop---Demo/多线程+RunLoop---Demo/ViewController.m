//
//  ViewController.m
//  多线程+RunLoop---Demo
//
//  Created by Qiushan on 2020/9/8.
//  Copyright © 2020 FLY. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton * sendBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    [_sendBtn setTitle:@"跳转" forState:UIControlStateNormal];
    [_sendBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_sendBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_sendBtn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendBtn];
    [_sendBtn setCenter:self.view.center];
}

- (void)clickAction {
    
    SecondViewController * vc = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
