//
//  FLYViewController.m
//  FlyBaseTool
//
//  Created by Walg on 2025/9/18.
//

#import "FLYViewController.h"

//#define LOG2 FLYTIMELog(@"-[%@ %@] view:%p superview:%p alpha:%f isHidden:%d", [self class], NSStringFromSelector(_cmd), self.view, self.view.superview, self.view.alpha, self.view.isHidden)
#define LOG2 FLYTIMELog(@"-[%@ %@]", [self class], NSStringFromSelector(_cmd))
#define LOG3 FLYTIMELog(@"-[%@ %@]", [self class], NSStringFromSelector(_cmd))

@interface FLYViewController ()

@end

@implementation FLYViewController

- (void)loadView {
    LOG2; // loadView
    [super loadView];
    LOG3;
}

- (void)loadViewIfNeeded {
    LOG2;
    [super loadViewIfNeeded];
    LOG3;
}

- (void)viewDidLoad {
    LOG2; // viewDidLoad
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    LOG3;
}

- (void)viewWillUnload {
    LOG2;
    [super viewWillUnload];
    LOG3;
}

- (void)viewDidUnload {
    LOG2;
    [super viewDidUnload];
    LOG3;
}

- (void)viewWillAppear:(BOOL)animated {
    LOG2; // viewWillAppear
    [super viewWillAppear:animated];
    LOG3;
}

- (void)viewDidAppear:(BOOL)animated {
    LOG2; // viewDidAppear
    [super viewDidAppear:animated];
    LOG3;
}

- (void)viewWillDisappear:(BOOL)animated {
    LOG2; // viewWillDisappear
    [super viewWillDisappear:animated];
    LOG3;
}

- (void)viewDidDisappear:(BOOL)animated {
    LOG2; // viewDidDisappear
    [super viewDidDisappear:animated];
    LOG3;
}

- (void)viewWillLayoutSubviews {
    LOG2;
    [super viewWillLayoutSubviews];
    LOG3;
}

- (void)viewDidLayoutSubviews {
    LOG2;
    [super viewDidLayoutSubviews];
    LOG3;
}

@end
