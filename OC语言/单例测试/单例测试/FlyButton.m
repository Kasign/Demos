//
//  FlyButton.m
//  单例测试
//
//  Created by Q on 2018/4/20.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "FlyButton.h"

@implementation FlyButton

+ (id)allocWithZone:(NSZone *)zone
{
    FlyButton * button = [super allocWithZone:zone];
    if (button) {
        [button setMethodAndBlock];
    }
    return button;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setMethodAndBlock];
    }
    return self;
}

- (void)setMethodAndBlock
{
    [self addTarget:self action:@selector(buttonDidClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonDidClick
{
    if (_buttonBlock) {
        __block typeof(self) blockSelf = self;
        _buttonBlock(blockSelf);
    }
}

- (void)dealloc
{
    NSLog(@"-----%s------",__func__);
}

@end
