//
//  FlyAlertViewController.m
//  AlertView+Demo
//
//  Created by Q on 2018/5/22.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "FlyAlertViewController.h"
#import <objc/runtime.h>

@interface FlyAlertViewController ()

@end

@implementation FlyAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setMessage:(NSString *)message
{
    NSLog(@"       ---->>>>>%s",__FUNCTION__);
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    NSLog(@"       ---->>>>>%s",__FUNCTION__);
}

- (void)addAction:(UIAlertAction *)action
{
    [super addAction:action];
    NSLog(@"       ---->>>>>%s",__FUNCTION__);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"       ---->>>>>%s",__FUNCTION__);
}

- (void)viewWillLayoutSubviews {
//    [super viewWillLayoutSubviews];
    NSLog(@"       ---->>>>>%s",__FUNCTION__);
}

- (void)viewDidLayoutSubviews
{
//    [super viewDidLayoutSubviews];
    NSLog(@"       ---->>>>>%s",__FUNCTION__);
    NSLog(@"---------begin-------------");
    [self subView:self.view];
    NSLog(@"---------end-------------");
}

- (void)subView:(UIView *)view
{
    for (UIView * subView in view.subviews) {
        NSLog(@"     ******\n    %@    \n*********   ",subView);
        [self subView:subView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

+ (void) abcd {
    
    NSLog(@"aaaaa");
}

@end
