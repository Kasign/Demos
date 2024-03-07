//
//  FlyRunloopTool.h
//  算法+链表
//
//  Created by mx-QS on 2019/9/24.
//  Copyright © 2019 Fly. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <mach/mach.h>
//#include <libkern/OSAtomic.h>
#include <execinfo.h>


NS_ASSUME_NONNULL_BEGIN

typedef void(^FlyLoopTask)(void);

@interface FlyRunloopTool : NSObject

- (void)startObserver;
- (void)toolAddTask:(FlyLoopTask)task;
- (void)stopTasks;

@end

NS_ASSUME_NONNULL_END
