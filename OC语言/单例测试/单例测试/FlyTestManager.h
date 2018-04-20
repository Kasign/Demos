//
//  FlyTestManager.h
//  单例测试
//
//  Created by Q on 2018/4/17.
//  Copyright © 2018 Fly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlyTestManager : NSObject

@property (nonatomic, copy) void(^managerBlock)(void);

+ (instancetype)shareInstance;

- (void)abcWithBlock:(void(^)(void))block;

- (void)sleepWithTimes:(NSTimeInterval)time;

@end
