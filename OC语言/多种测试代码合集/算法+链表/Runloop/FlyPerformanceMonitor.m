//
//  FlyPerformanceMonitor.m
//  算法+链表
//
//  Created by mx-QS on 2019/9/27.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "FlyPerformanceMonitor.h"
#import <CrashReporter/CrashReporter.h>

@interface FlyPerformanceMonitor ()

@property (nonatomic, assign) CFRunLoopObserverRef    observer;
@property (nonatomic, assign) int                     timeoutCount;
@property (nonatomic, strong) dispatch_semaphore_t    semaphore;
@property (nonatomic, assign) CFRunLoopActivity       activity;


@end

@implementation FlyPerformanceMonitor

+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

static void RunloopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    FlyPerformanceMonitor * moniotr = (__bridge FlyPerformanceMonitor*)info;
    moniotr.activity = activity;
    dispatch_semaphore_signal(moniotr.semaphore);
}

- (void)stop
{
    if (!_observer) {
        return;
    }
    
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes);
    CFRelease(_observer);
    _observer = NULL;
}

- (void)start
{
    if (_observer) {
        return;
    }
    
    // 信号
    _semaphore = dispatch_semaphore_create(0);
    
    // 注册RunLoop状态观察
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)self,
        &CFRetain,
        &CFRelease,
        NULL
    };
    
    _observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                        kCFRunLoopAllActivities,
                                        YES,
                                        0,
                                        &RunloopObserverCallBack,
                                        &context);
    
    CFRunLoopAddObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes);
    
    __weak typeof(self) weakSelf = self;
    // 在子线程监控时长
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES)
        {
            long st = dispatch_semaphore_wait(weakSelf.semaphore, dispatch_time(DISPATCH_TIME_NOW, 50*NSEC_PER_MSEC));
            if (st != 0)
            {
                if (!weakSelf.observer)
                {
                    weakSelf.timeoutCount = 0;
                    weakSelf.semaphore = 0;
                    weakSelf.activity = 0;
                    return;
                }
                
                if (weakSelf.activity == kCFRunLoopBeforeSources || weakSelf.activity == kCFRunLoopAfterWaiting)
                {
                    if (++weakSelf.timeoutCount < 5)
                    {
                        continue;
                    }
                    
                    PLCrashReporterConfig * config  = [[PLCrashReporterConfig alloc] initWithSignalHandlerType:PLCrashReporterSignalHandlerTypeBSD
                                                                                        symbolicationStrategy:PLCrashReporterSymbolicationStrategyAll];
                    PLCrashReporter * crashReporter = [[PLCrashReporter alloc] initWithConfiguration:config];
                    
                    NSData * data = [crashReporter generateLiveReport];
                    PLCrashReport * reporter = [[PLCrashReport alloc] initWithData:data error:NULL];
                    NSString * report = [PLCrashReportTextFormatter stringValueForCrashReport:reporter
                                                                               withTextFormat:PLCrashReportTextFormatiOS];
                    
                    NSLog(@"卡顿了------------\n%@\n------------", report);
                }
            }
            weakSelf.timeoutCount = 0;
        }
    });
}

+ (void)beginMonitor
{
    [[FlyPerformanceMonitor sharedInstance] start];
}

+ (void)endMonitor
{
    [[FlyPerformanceMonitor sharedInstance] stop];
}

@end
