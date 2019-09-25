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

@end

@implementation FlyRunloopTool

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _taskDic = [NSMutableDictionary dictionary];
        _maxTaskCount = 18;
        
        CFRunLoopObserverContext context = {
            0,
            (__bridge void *)self,
            &CFRetain,
            &CFRelease,
            NULL
        };
        _currentTime = [self getCurrentTime];
        _defaultModeObserver = CFRunLoopObserverCreate(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, &RunloopCallBack, &context);
        CFRunLoopAddObserver(CFRunLoopGetCurrent(), _defaultModeObserver, kCFRunLoopCommonModes);
    }
    return self;
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
                FLYLog(@"~~~~~~~~~~~~~~~~~~~我卡顿了~~~~~~~~~~~~~~~~~~~\n\n");
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
}

- (NSTimeInterval)getCurrentTime
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    return now;
}

- (void)startPerformTask
{
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

- (void)toolAddTask:(FlyLoopTask)task
{
    if (task) {
        CFRunLoopRef runloop = CFRunLoopGetCurrent();
        NSString * key = [self keyForLoop:runloop];
        NSMutableArray * array = [self.taskDic objectForKey:key];
        if (![array isKindOfClass:[NSMutableArray class]]) {
            array = [NSMutableArray array];
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

- (void)stop
{
    CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), _defaultModeObserver, kCFRunLoopCommonModes);
    CFRelease(_defaultModeObserver);
}

- (void)dealloc {
    
    FLYLog(@"----* %@ dealloc *----", [self class]);
}

@end
