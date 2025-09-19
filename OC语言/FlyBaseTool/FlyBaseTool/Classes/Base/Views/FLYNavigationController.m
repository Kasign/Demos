//
//  FLYNavigationController.m
//  FlyBaseTool
//
//  Created by Walg on 2025/9/18.
//

#import "FLYNavigationController.h"

@interface FLYNavigationController ()

@end

@implementation FLYNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    FLYFUNLog(@"");
    self = [super initWithRootViewController:rootViewController];
    FLYFUNLog(@"");
    return self;
}

- (void)loadView {
    FLYFUNLog(@"");
    [super loadView];
    FLYFUNLog(@"");
}

- (void)loadViewIfNeeded {
    FLYFUNLog(@"");
    [super loadViewIfNeeded];
    FLYFUNLog(@"");
}

- (void)viewDidLoad {
    FLYFUNLog(@"");
    [super viewDidLoad];
    FLYFUNLog(@"");
}

- (void)viewWillUnload {
    FLYFUNLog(@"");
    [super viewWillUnload];
    FLYFUNLog(@"");
}

- (void)viewDidUnload {
    FLYFUNLog(@"");
    [super viewDidUnload];
    FLYFUNLog(@"");
}

- (void)viewWillAppear:(BOOL)animated {
    FLYFUNLog(@"");
    [super viewWillAppear:animated];
    FLYFUNLog(@"");
}

- (void)viewDidAppear:(BOOL)animated {
    FLYFUNLog(@"");
    [super viewDidAppear:animated];
    FLYFUNLog(@"");
}

- (void)viewWillDisappear:(BOOL)animated {
    FLYFUNLog(@"");
    [super viewWillDisappear:animated];
    FLYFUNLog(@"");
}

- (void)viewDidDisappear:(BOOL)animated {
    FLYFUNLog(@"");
    [super viewDidDisappear:animated];
    FLYFUNLog(@"");
}

- (void)viewWillLayoutSubviews {
    FLYFUNLog(@"");
    [super viewWillLayoutSubviews];
    FLYFUNLog(@"");
}

- (void)viewDidLayoutSubviews {
    FLYFUNLog(@"");
    [super viewDidLayoutSubviews];
    FLYFUNLog(@"");
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    FLYFUNLog(@"push to : %@", viewController);
    [super pushViewController:viewController animated:animated];
    FLYFUNLog(@"push to : %@", viewController);
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    FLYFUNLog(@"");
    UIViewController *v = [super popViewControllerAnimated:animated];
    FLYFUNLog(@"");
    return v;
}

@end
