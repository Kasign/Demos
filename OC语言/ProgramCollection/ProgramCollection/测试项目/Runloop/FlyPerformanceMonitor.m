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
        __strong typeof(weakSelf) self = weakSelf;
        while (YES)
        {
            long st = dispatch_semaphore_wait(self.semaphore, dispatch_time(DISPATCH_TIME_NOW, 50 * NSEC_PER_MSEC));
            if (st != 0)
            {
                if (!self.observer)
                {
                    self.timeoutCount = 0;
                    self.semaphore = 0;
                    self.activity = 0;
                    return;
                }
                
                if (self.activity == kCFRunLoopBeforeSources || self.activity == kCFRunLoopAfterWaiting)
                {
                    if (++self.timeoutCount < 5)
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
                    
                    FLYLog(@"卡顿了------------\n%@\n------------", report);
                }
            }
            self.timeoutCount = 0;
        }
    });
}

- (void)updateCPUInfo
{
    thread_act_array_t threads;
    mach_msg_type_number_t threadCount = 0;
    const task_t thisTask = mach_task_self();
    kern_return_t kr = task_threads(thisTask, &threads, &threadCount);
    if (kr != KERN_SUCCESS) {
        return;
    }
    for (int i = 0; i < threadCount; i++) {
        thread_info_data_t threadInfo;
        thread_basic_info_t threadBaseInfo;
        mach_msg_type_number_t threadInfoCount = THREAD_INFO_MAX;
        if (thread_info((thread_act_t)threads[i], THREAD_BASIC_INFO, (thread_info_t)threadInfo, &threadInfoCount) == KERN_SUCCESS) {
            threadBaseInfo = (thread_basic_info_t)threadInfo;
            if (!(threadBaseInfo->flags & TH_FLAGS_IDLE)) {
                integer_t cpuUsage = threadBaseInfo->cpu_usage / 10;
                if (cpuUsage > 70) {
                    //cup 消耗大于 70 时打印和记录堆栈
                    //                        NSString *reStr = smStackOfThread(threads[i]);
                    //记录数据库中
                    //                    [[[SMLagDB shareInstance] increaseWithStackString:reStr] subscribeNext:^(id x) {}];
                    //                        NSLog(@"CPU useage overload thread stack：\n%@",reStr);
//                    FLYLog(@"CPU useage overload thread stack %@", GetCurrentStackInfo());
                }
            }
        }
    }
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
