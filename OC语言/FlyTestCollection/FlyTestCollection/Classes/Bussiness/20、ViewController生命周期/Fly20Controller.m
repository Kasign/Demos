//
//  Fly20Controller.m
//  AFNetworking
//
//  Created by Walg on 2025/8/16.
//

#import "Fly20Controller.h"
#import "FlyLifeViewController.h"

#define LOG FLYLog(@"%s view:%p superview:%p alpha:%f isHidden:%d", __func__, self.view, self.view.superview, self.view.alpha, self.view.isHidden)

@interface Fly20Controller ()

@end

@implementation Fly20Controller

- (void)loadView {
    [super loadView];
    LOG; // loadView
}

- (void)loadViewIfNeeded {
    [super loadViewIfNeeded];
    LOG; 
}

+ (NSString *)functionName {
    
    return @"ViewController生命周期";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    LOG; // viewDidLoad
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [pushBtn setTitle:@"Push" forState:UIControlStateNormal];
    pushBtn.frame = CGRectMake(0, 0, 120, 44);
    pushBtn.center = CGPointMake(self.view.center.x, self.view.center.y - 50);
    [pushBtn addTarget:self action:@selector(pushTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushBtn];

    UIButton *inspectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [inspectBtn setTitle:@"Inspect Views" forState:UIControlStateNormal];
    inspectBtn.frame = CGRectMake(0, 0, 160, 44);
    inspectBtn.center = CGPointMake(self.view.center.x, self.view.center.y + 10);
    [inspectBtn addTarget:self action:@selector(inspectViews) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inspectBtn];
}

- (void)inspectViews {
    NSLog(@"--- view hierarchy under navigation controller's view ---");
    UIViewController *top = self.navigationController.topViewController;
    NSLog(@"topViewController = %@", top);
    NSArray *subs = self.navigationController.view.subviews;
    [subs enumerateObjectsUsingBlock:^(UIView *v, NSUInteger idx, BOOL *stop) {
        NSLog(@"sub[%lu] = %@ frame=%@", (unsigned long)idx, v, NSStringFromCGRect(v.frame));
    }];
}

- (void)pushTapped {
    
    FLYLog(@" ============= push");
    FlyLifeViewController *vc = [[FlyLifeViewController alloc] init];
    // 下面这行如果取消注释，会提前访问 vc.view，从而触发 viewDidLoad 在 push 更早发生。
    // (void)vc.view;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillUnload {
    [super viewWillUnload];
    LOG;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    LOG;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    LOG; // viewWillAppear
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    LOG; // viewDidAppear
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    LOG; // viewWillDisappear
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    LOG; // viewDidDisappear
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    LOG; // viewWillLayoutSubviews
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    LOG; // viewDidLayoutSubviews
}

@end
