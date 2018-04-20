//
//  FlyTestManager.m
//  单例测试
//
//  Created by Q on 2018/4/17.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "FlyTestManager.h"

@implementation FlyTestManager

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

+ (void)resetToOriginal
{
    
}

@end
