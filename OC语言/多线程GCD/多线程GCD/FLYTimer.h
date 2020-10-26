//
//  FLYTimer.h
//  多线程GCD
//
//  Created by Walg on 2020/2/26.
//  Copyright © 2020 walg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FLYTimerBlock)(void);

@interface FLYTimer : NSObject

+ (instancetype)timerWithTime:(float)time block:(FLYTimerBlock)block;
+ (instancetype)timerWithTime:(float)time dely:(float)dely block:(FLYTimerBlock)block;
- (void)resume;
- (void)suspend;
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
