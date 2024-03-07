//
//  FlyFirstController.m
//  算法+链表
//
//  Created by Qiushan on 2020/9/10.
//  Copyright © 2020 Fly. All rights reserved.
//

#import "FlyFirstController.h"
#import "FlyButton.h"

@interface FlyFirstController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) FlyButton *button;

@end

@implementation FlyFirstController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //timer会强持有target，执行结束后会释放target
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    _button = [FlyButton buttonWithType:UIButtonTypeCustom];
    [_button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if (_timer) {
        [_timer invalidate];
    }
}

- (void)updateTime:(NSTimer *)timer {
    
    NSLog(@"11111");
}

- (void)clickAction:(UIButton *)button {
    
    NSLog(@"%@", self);
}

@end
