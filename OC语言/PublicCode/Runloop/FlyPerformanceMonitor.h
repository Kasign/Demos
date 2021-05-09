//
//  FlyPerformanceMonitor.h
//  算法+链表
//
//  Created by mx-QS on 2019/9/27.
//  Copyright © 2019 Fly. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlyPerformanceMonitor : NSObject

+ (instancetype)sharedInstance;

- (void)start;
- (void)stop;

+ (void)beginMonitor;
+ (void)endMonitor;

@end

NS_ASSUME_NONNULL_END
