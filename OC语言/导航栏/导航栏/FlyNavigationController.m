//
//  FlyNavigationController.m
//  导航栏
//
//  Created by 66-admin-qs. on 2018/10/10.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "FlyNavigationController.h"

@interface FlyNavigationController ()

@end

@implementation FlyNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置返回按钮样式
//    UIImage * backButtonImage = [[UIImage imageNamed:@"nav_back_bg1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    self.navigationBar.tintColor = [UIColor grayColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:16.f], NSFontAttributeName, nil];
    self.navigationBar.titleTextAttributes = dict;
    
    self.interactivePopGestureRecognizer.enabled = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
