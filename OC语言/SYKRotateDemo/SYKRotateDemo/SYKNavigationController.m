//
//  SYKNavigationController.m
//  SYKRotateDemo
//
//  Created by Walg on 2021/8/11.
//

#import "SYKNavigationController.h"

@interface SYKNavigationController ()

@end

@implementation SYKNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)shouldAutorotate {
    
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskAll;
}

@end
