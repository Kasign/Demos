//
//  FlyThirdViewController.m
//  FLYTestDemos
//
//  Created by Walg on 2021/6/30.
//  Copyright © 2021 Fly. All rights reserved.
//

#import "FlyThirdViewController.h"
#import "JGTimeReportMananger.h"

@interface FlyThirdViewController ()

@end

@implementation FlyThirdViewController

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

@end
