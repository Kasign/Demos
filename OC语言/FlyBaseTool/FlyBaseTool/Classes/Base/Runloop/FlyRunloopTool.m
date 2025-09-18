//
//  FlyRunloopTool.m
//  算法+链表
//
//  Created by mx-QS on 2019/9/24.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "FlyRunloopTool.h"
//#import <CrashReporter/CrashReporter.h>


@interface FlyRunloopTool ()

@property (nonatomic, assign) NSInteger            maxTaskCount;
@property (nonatomic, strong) NSMutableDictionary  *taskDic;
@property (nonatomic, assign) CFRunLoopObserverRef defaultModeObserver;
@property (nonatomic, assign) NSTimeInterval       currentTime;

@end

@implementation FlyRunloopTool

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        _taskDic = [NSMutableDictionary dictionary];
        _maxTaskCount = 18;
    }
    return self;
}

- (void)startObserver {
    
    if (_defaultModeObserver == nil) {
        CFRunLoopObserverContext context = {
            0,
            (__bridge void *)self,
            &CFRetain,
            &CFRelease,
            NULL
        };
        _defaultModeObserver = CFRunLoopObserverCreate(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, &RunloopCallBack, &context);
        CFRunLoopAddObserver(CFRunLoopGetCurrent(), _defaultModeObserver, kCFRunLoopCommonModes);
        _currentTime = [self getCurrentTime];
    }
}

- (void)stopObserver {
    
    if (_defaultModeObserver) {
        CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), _defaultModeObserver, kCFRunLoopCommonModes);
        CFRelease(_defaultModeObserver);
        _defaultModeObserver = NULL;
    }
}

static void RunloopCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    
    CFRunLoopMode currentMode = CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent());
    FlyRunloopTool *tool = (__bridge FlyRunloopTool *)info;
    NSTimeInterval currentTime = [tool getCurrentTime];
    
    FLYTIMELog(@"\nTime : %f \nMode:%@", currentTime, currentMode);
    switch (activity) {
        case kCFRunLoopEntry:
        {
            FLYTIMELog(@"-- kCFRunLoopEntry  ---->> 1.进入loop");
        }
            break;
        case kCFRunLoopBeforeTimers:
        {
            FLYTIMELog(@"-- kCFRunLoopBeforeTimers  ---->> 2.将要处理timer");
        }
            break;
        case kCFRunLoopBeforeSources:
        {
            FLYTIMELog(@"-- kCFRunLoopBeforeSources ---->> 3.将要处理source");
        }
            break;
        case kCFRunLoopBeforeWaiting:
        {
            FLYTIMELog(@"-- kCFRunLoopBeforeWaiting ---->> 4.将要进入等待状态");
            [tool startPerformTask];
        }
            break;
        case kCFRunLoopAfterWaiting:
        {
            FLYTIMELog(@"-- kCFRunLoopAfterWaiting  ---->> 5.将要唤醒");
        }
            break;
        case kCFRunLoopExit:
            FLYTIMELog(@"-- kCFRunLoopExit ---->> 6.退出loop");
            break;
            
        default:
            break;
    }
//    FLYTIMELog(@"%@", [tool getCurrentTrack]);
}

//- (NSString *)getCurrentTrack {
//    
//    PLCrashReporterConfig *config  = [[PLCrashReporterConfig alloc] initWithSignalHandlerType:PLCrashReporterSignalHandlerTypeBSD symbolicationStrategy:PLCrashReporterSymbolicationStrategyAll];
//    PLCrashReporter *crashReporter = [[PLCrashReporter alloc] initWithConfiguration:config];
//    
//    NSData *data = [crashReporter generateLiveReport];
//    PLCrashReport *reporter = [[PLCrashReport alloc] initWithData:data error:NULL];
//    NSString *report = [PLCrashReportTextFormatter stringValueForCrashReport:reporter withTextFormat:PLCrashReportTextFormatiOS];
//    
//    return report;
//}

- (NSTimeInterval)getCurrentTime {
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    return now;
}

- (void)startPerformTask {
    
    if (self.taskDic.count > 0) {
        CFRunLoopRef runloop  = CFRunLoopGetCurrent();
        NSString *key = [self keyForLoop:runloop];
        NSMutableArray *array = [self.taskDic objectForKey:key];
        if ([array isKindOfClass:[NSMutableArray class]] && array.count > 0) {
            FlyLoopTask task = array.firstObject;
            if (task) {
                FLYTIMELog(@"执行了任务");
                task();
                [array removeObjectAtIndex:0];
            }
        }
    }
}

- (void)toolAddTask:(FlyLoopTask)task {
    
    if (task) {
        CFRunLoopRef runloop = CFRunLoopGetCurrent();
        NSString *key = [self keyForLoop:runloop];
        NSMutableArray *array = [self.taskDic objectForKey:key];
        if (![array isKindOfClass:[NSMutableArray class]]) {
            if ([array isKindOfClass:[NSArray class]]) {
                array = [array mutableCopy];
            } else {
                array = [NSMutableArray array];
            }
            [self.taskDic setObject:array forKey:key];
        }
        [array addObject:task];
        if (array.count > _maxTaskCount) {
            [array removeObjectAtIndex:0];
        }
    }
}

- (NSString *)keyForLoop:(CFRunLoopRef)loopRef {
    
    //    NSThread *td = [NSThread currentThread];
    //    pthread_t t = nil;
    //    pthreadPointer(t);
    return @"key";
}

- (void)stopTasks {
    
    [self stopObserver];
}

- (void)dealloc {
    
    FLYTIMELog(@"----* %@ dealloc *----", [self class]);
}

@end
