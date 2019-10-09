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

static NSArray * GetCurrentStackInfo()
{
    void * callstack[128];
    int frames  = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    int i;
    NSMutableArray * backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (i = 0; i < frames; i++){
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    NSArray * array = [NSThread callStackSymbols];
    
    [backtrace addObject:array];
    
    return backtrace;
}

@interface FlyRunloopTool : NSObject

- (void)toolAddTask:(FlyLoopTask)task;
- (void)stopTasks;

- (void)beginMonitor;
- (void)endMonitor;

@end

NS_ASSUME_NONNULL_END
