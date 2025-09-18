//
//  FLYNavigationController.m
//  FlyBaseTool
//
//  Created by Walg on 2025/9/18.
//

#import "FLYNavigationController.h"

#define LOG FLYTIMELog(@"-[%@ %@]", [self class], NSStringFromSelector(_cmd))
#define LOG1 FLYTIMELog(@"-[%@ %@]", [self class], NSStringFromSelector(_cmd))
//#define LOG FLYTIMELog(@"-[%@ %@] view:%p superview:%p alpha:%f isHidden:%d", [self class], NSStringFromSelector(_cmd), self.view, self.view.superview, self.view.alpha, self.view.isHidden)

@interface FLYNavigationController ()

@end

@implementation FLYNavigationController

- (void)loadView {
    LOG;
    [super loadView];
    LOG1;
}

- (void)loadViewIfNeeded {
    LOG;
    [super loadViewIfNeeded];
    LOG1;
}

- (void)viewDidLoad {
    LOG;
    [super viewDidLoad];
    LOG1;
}

- (void)viewWillUnload {
    LOG;
    [super viewWillUnload];
    LOG1;
}

- (void)viewDidUnload {
    LOG;
    [super viewDidUnload];
    LOG1;
}

- (void)viewWillAppear:(BOOL)animated {
    LOG;
    [super viewWillAppear:animated];
    LOG1;
}

- (void)viewDidAppear:(BOOL)animated {
    LOG;
    [super viewDidAppear:animated];
    LOG1;
}

- (void)viewWillDisappear:(BOOL)animated {
    LOG;
    [super viewWillDisappear:animated];
    LOG1;
}

- (void)viewDidDisappear:(BOOL)animated {
    LOG;
    [super viewDidDisappear:animated];
    LOG1;
}

- (void)viewWillLayoutSubviews {
    LOG;
    [super viewWillLayoutSubviews];
    LOG1;
}

- (void)viewDidLayoutSubviews {
    LOG;
    [super viewDidLayoutSubviews];
    LOG1;
}

@end
