//
//  ViewController.m
//  UIView+Enlarge+Demo
//
//  Created by 66-admin-qs. on 2018/11/19.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "ViewController.h"
#import "UIResponder+Extension.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubViews];
}


- (void)initSubViews {
    
    UIButton * button1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 300, 300)];
    [button1 setTitle:@"button1" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(button1ClickAction) forControlEvents:UIControlEventTouchUpInside];
    [button1 setBackgroundColor:[UIColor grayColor]];
    [button1 setTag:100];
    [self.view addSubview:button1];
    
    UIButton * button2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 150, 150)];
    [button2 setTitle:@"button2" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(button2ClickAction) forControlEvents:UIControlEventTouchUpInside];
    [button2 setBackgroundColor:[UIColor cyanColor]];
    [button2 setTag:200];
    [self.view addSubview:button2];
    
    UIButton * button3 = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [button3 setTitle:@"button3" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(button3ClickAction) forControlEvents:UIControlEventTouchUpInside];
    [button3 setBackgroundColor:[UIColor purpleColor]];
    [button3 setTag:300];
    [self.view addSubview:button3];
//    [button3 setHidden:YES];
    [button3 setAlpha:0.1];
    
}


- (void)button1ClickAction {
    
    NSLog(@"1");
}

- (void)button2ClickAction {
    
    NSLog(@"2");
}

- (void)button3ClickAction {
    
    NSLog(@"3");
}

@end
