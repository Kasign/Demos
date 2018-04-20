//
//  FlyTestManager.m
//  单例测试
//
//  Created by Q on 2018/4/17.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "FlyTestManager.h"

@implementation FlyTestManager

- (id)initWithZone:(NSZone *)zone
{
   return [[FlyTestManager alloc] initWithZone:zone];
}

+ (instancetype)shareInstance
{
    static FlyTestManager * _manager = nil;
    static dispatch_once_t onceToken;
    NSLog(@" start ** %ld",onceToken);
    dispatch_once(&onceToken, ^{
        NSLog(@" ing ** %ld",onceToken);
        _manager = [[FlyTestManager alloc] init];
    });
    NSLog(@" end ** %ld",onceToken);
    return _manager;
}

- (void)abcWithBlock:(void(^)(void))block
{
    [NSThread sleepForTimeInterval:3.f];
    if (block) {
        block();
    }
}

- (void)sleepWithTimes:(NSTimeInterval)time
{
    [NSThread sleepForTimeInterval:time];
    if (_managerBlock) {
        _managerBlock();
    }
}

@end
