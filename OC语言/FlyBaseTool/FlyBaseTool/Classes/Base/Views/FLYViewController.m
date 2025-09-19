//
//  FLYViewController.m
//  FlyBaseTool
//
//  Created by Walg on 2025/9/18.
//

#import "FLYViewController.h"
#import "FlyBaseView.h"

#define LOG4 FLYTIMELog(@"-[%@ %@] view:%p superview:%p alpha:%f isHidden:%d", [self class], NSStringFromSelector(_cmd), self.view, self.view.superview, self.view.alpha, self.view.isHidden)

@interface FLYViewController ()

@end

@implementation FLYViewController

- (void)loadView {
    FLYFUNLog(@""); // loadView
    //    [super loadView];
    FlyBaseView *root = [[FlyBaseView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    root.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view = root;
    LOG4;
}

- (void)loadViewIfNeeded {
    FLYFUNLog(@"");
    [super loadViewIfNeeded];
    FLYFUNLog(@"");
}

- (void)viewDidLoad {
    LOG4; // viewDidLoad
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    LOG4;
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
    LOG4; // viewWillAppear
    [super viewWillAppear:animated];
    FLYFUNLog(@"");
}

- (void)viewIsAppearing:(BOOL)animated {
    LOG4;
    [super viewIsAppearing:animated];
    FLYFUNLog(@"");
}

- (void)viewDidAppear:(BOOL)animated {
    FLYFUNLog(@""); // viewDidAppear
    [super viewDidAppear:animated];
    FLYFUNLog(@"");
}

- (void)viewWillDisappear:(BOOL)animated {
    FLYFUNLog(@""); // viewWillDisappear
    [super viewWillDisappear:animated];
    FLYFUNLog(@"");
}

- (void)viewDidDisappear:(BOOL)animated {
    FLYFUNLog(@""); // viewDidDisappear
    [super viewDidDisappear:animated];
    FLYFUNLog(@"");
}

- (void)viewWillLayoutSubviews {
    LOG4;
    [super viewWillLayoutSubviews];
    FLYFUNLog(@"");
}

- (void)viewDidLayoutSubviews {
    LOG4;
    [super viewDidLayoutSubviews];
    FLYFUNLog(@"");
}

@end
