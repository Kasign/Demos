//
//  ViewController.m
//  单例测试
//
//  Created by Q on 2018/4/17.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "ViewController.h"
#import "FlyTestManager.h"

@interface ViewController ()
@property (nonatomic, strong) FlyTestManager   *   manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _manager = [FlyTestManager shareInstance];
    
    _manager = nil;
    
    _manager = [FlyTestManager shareInstance];
    
    [FlyTestManager resetToOriginal];
    
    _manager = [FlyTestManager shareInstance];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
