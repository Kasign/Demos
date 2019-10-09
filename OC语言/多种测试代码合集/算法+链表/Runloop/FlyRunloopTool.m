//
//  FlyRunloopTool.m
//  算法+链表
//
//  Created by mx-QS on 2019/9/24.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "FlyRunloopTool.h"


@interface FlyRunloopTool ()

@property (nonatomic, assign) NSInteger                 maxTaskCount;
@property (nonatomic, strong) NSMutableDictionary   *   taskDic;
@property (nonatomic, assign) CFRunLoopObserverRef      defaultModeObserver;

@property (nonatomic, assign) NSTimeInterval            currentTime;

@property (nonatomic, strong) dispatch_semaphore_t  dispatchSemaphore;

@property (nonatomic, strong) NSTimer  * cpuMonitorTimer;

@property (nonatomic, assign) NSInteger  timeoutCount;
@property (nonatomic, assign) CFRunLoopActivity  runLoopActivity;

@end

@implementation FlyRunloopTool

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _taskDic = [NSMutableDictionary dictionary];
        _maxTaskCount = 18;
    }
    return self;
}

- (void)startObserver
{
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

- (void)stopObserver
{
    if (_defaultModeObserver) {
        CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), _defaultModeObserver, kCFRunLoopCommonModes);
        CFRelease(_defaultModeObserver);
        _defaultModeObserver = NULL;
    }
}

- (void)startCpuTimer
{
    if (_cpuMonitorTimer == nil) {
        self.cpuMonitorTimer = [NSTimer scheduledTimerWithTimeInterval:3
                                                                target:self
                                                              selector:@selector(updateCPUInfo)
                                                              userInfo:nil
                                                               repeats:YES];
    }
}

- (void)stopCupTimer
{
    if (_cpuMonitorTimer) {
        [self.cpuMonitorTimer invalidate];
        self.cpuMonitorTimer = nil;
    }
}

static void RunloopCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    FlyRunloopTool * tool = (__bridge FlyRunloopTool *)info;
    
    switch (activity) {
        case kCFRunLoopEntry:
        {
            FLYLog(@"-- kCFRunLoopEntry         ---->>  %f  <<-- 1.进入loop", [tool getCurrentTime]);
        }
            break;
        case kCFRunLoopBeforeTimers:
        {
            FLYLog(@"-- kCFRunLoopBeforeTimers  ---->>  %f  <<-- 2.将要处理timer", [tool getCurrentTime]);
        }
            break;
        case kCFRunLoopBeforeSources:
        {
            FLYLog(@"-- kCFRunLoopBeforeSources ---->>  %f  <<-- 3.将要处理source", [tool getCurrentTime]);
        }
            break;
        case kCFRunLoopBeforeWaiting:
        {
            NSTimeInterval current = [tool getCurrentTime];
            NSTimeInterval sub = current - tool.currentTime;
            tool.currentTime = current;
            NSInteger fps = 1 / sub;
            FLYLog(@"-- kCFRunLoopBeforeWaiting ---->>  %f  <<-- 4.将要进入等待状态", [tool getCurrentTime]);
            if (sub > 0.05) {
                FLYLog(@"——-- 唤醒 -> 等待  时间差  ——-->>>>>> %f %ld", sub, (long)fps);
                FLYLog(@"~~~~~~~~~~~~~~~~~~~我卡顿了~~~~~~~~~~~~~~~~~~~%@\n\n", GetCurrentStackInfo());
            } else {
                FLYLog(@"——-- 唤醒 -> 等待  时间差  ——-->>>>>> %f %ld\n\n", sub, (long)fps);
            }
            [tool startPerformTask];
        }
            break;
        case kCFRunLoopAfterWaiting:
        {
            NSTimeInterval current = [tool getCurrentTime];
            NSTimeInterval sub = current - tool.currentTime;
            tool.currentTime = current;
            FLYLog(@"——-- 等待 -> 唤醒  时间差  ——-->>>>>> %f", sub);
            FLYLog(@"-- kCFRunLoopAfterWaiting  ---->>  %f  <<-- 5.将要唤醒", [tool getCurrentTime]);
        }
            break;
        case kCFRunLoopExit:
            FLYLog(@"-- kCFRunLoopExit          ---->>  %f  <<-- 6.退出loop", [tool getCurrentTime]);
            break;
            
        default:
            break;
    }
    
    tool.runLoopActivity = activity;
    
    dispatch_semaphore_t semaphore = tool.dispatchSemaphore;
    dispatch_semaphore_signal(semaphore);
}

- (NSTimeInterval)getCurrentTime
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    return now;
}

- (void)startPerformTask
{
    if (self.taskDic.count > 0) {
        CFRunLoopRef runloop  = CFRunLoopGetCurrent();
        NSString * key = [self keyForLoop:runloop];
        NSMutableArray * array = [self.taskDic objectForKey:key];
        if ([array isKindOfClass:[NSMutableArray class]] && array.count > 0) {
            FlyLoopTask task = array.firstObject;
            if (task) {
                task();
                [array removeObjectAtIndex:0];
            }
        }
    }
}

- (void)toolAddTask:(FlyLoopTask)task
{
    if (task) {
        CFRunLoopRef runloop = CFRunLoopGetCurrent();
        NSString * key = [self keyForLoop:runloop];
        NSMutableArray * array = [self.taskDic objectForKey:key];
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

- (NSString * )keyForLoop:(CFRunLoopRef)loopRef
{
    //    NSThread * td = [NSThread currentThread];
    //    pthread_t t = nil;
    //    pthreadPointer(t);
    return @"key";
}

- (void)stopTasks
{
    [self stopObserver];
}

- (void)beginMonitor
{
    //监测 CPU 消耗
    if (_cpuMonitorTimer) {
        return;
    }
    [self startCpuTimer];
    //监测卡顿
    _dispatchSemaphore = dispatch_semaphore_create(0); //Dispatch Semaphore保证同步
    [self startObserver];
    
    //创建子线程监控
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __strong typeof(weakSelf) self = weakSelf;
        //子线程开启一个持续的loop用来进行监控
        while (YES) {
            long semaphoreWait = dispatch_semaphore_wait(self.dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, 20 * NSEC_PER_MSEC));
            if (semaphoreWait != 0) {
                if (!self.defaultModeObserver) {
                    self.timeoutCount = 0;
                    self.dispatchSemaphore = 0;
                    self.runLoopActivity = 0;
                    return;
                }
                //两个runloop的状态，BeforeSources和AfterWaiting这两个状态区间时间能够检测到是否卡顿
                if (self.runLoopActivity == kCFRunLoopBeforeSources || self.runLoopActivity == kCFRunLoopAfterWaiting) {
                    // 将堆栈信息上报服务器的代码放到这里
                    //出现三次出结果
                    if (++self.timeoutCount < 3) {
                        continue;
                    }
                    FLYLog(@"-*****------------------>>>>>>>>>>>>>>>>>>>>>>>monitor trigger %@", GetCurrentStackInfo());
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        //                        [SMCallStack callStackWithType:SMCallStackTypeAll];
                    });
                } //end activity
            }// end semaphore wait
            self.timeoutCount = 0;
        }// end while
    });
}

- (void)endMonitor
{
    [self stopCupTimer];
    [self stopObserver];
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
                    FLYLog(@"CPU useage overload thread stack %@", GetCurrentStackInfo());
                }
            }
        }
    }
}

- (void)dealloc {
    
    FLYLog(@"----* %@ dealloc *----", [self class]);
}

@end
