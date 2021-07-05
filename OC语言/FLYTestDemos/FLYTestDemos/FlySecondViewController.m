//
//  FlySecondViewController.m
//  FLYTestDemos
//
//  Created by Walg on 2021/6/30.
//  Copyright © 2021 Fly. All rights reserved.
//

#import "FlySecondViewController.h"
#import "JGTimeReportMananger.h"
#import "FlyThirdViewController.h"

@interface FlySecondViewController ()

@end

@implementation FlySecondViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        JGStartRecordClass
    }
    return self;
}

- (void)loadView {
    
    [super loadView];
    JGRecordNode
}

- (void)viewDidLoad {
    [super viewDidLoad];
    JGRecordNode
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    JGRecordNode
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    JGRecordNode
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    JGRecordNode
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    JGRecordNode
    
    NSLog(@"%@", [JGTimeReportMananger sharedInstance].logAllRecord);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    [super touchesBegan:touches withEvent:event];
    
    FlyThirdViewController *vc = [[FlyThirdViewController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
}

@end
