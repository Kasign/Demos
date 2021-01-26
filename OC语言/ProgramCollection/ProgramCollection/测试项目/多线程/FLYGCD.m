//
//  FLYGCD.m
//  多线程+RunLoop---Demo
//
//  Created by Qiushan on 2020/9/10.
//  Copyright © 2020 FLY. All rights reserved.
//

#import "FLYGCD.h"
@interface FLYGCD ()

@property (nonatomic, strong, readwrite) dispatch_queue_t queue;
@property (nonatomic, strong, readwrite) NSRunLoop * runLoop;
@property (nonatomic, strong, readwrite) NSThread  * thread;
@property (nonatomic, strong) NSMachPort * machPort;

@property (nonatomic, assign) FLYThreadType type;
@property (nonatomic, assign) BOOL          shouldKeepRunning;

@end

@implementation FLYGCD

+ (instancetype)threadWithType:(FLYThreadType)threadType {
    
    return [[self alloc] initWithType:threadType];
}

- (instancetype)initWithType:(FLYThreadType)threadType {
    
    self = [super init];
    if (self) {
        _type = threadType;
    }
    return self;
}

- (dispatch_queue_t)queue {
    
    if (_queue == nil) {
        if (_type == FLYThreadType_SERIAL) {
            _queue = dispatch_queue_create("com.66rpg.www", DISPATCH_QUEUE_SERIAL);
        } else if (_type == FLYThreadType_CONCURRENT) {
            _queue = dispatch_queue_create("com.66rpg.www", DISPATCH_QUEUE_CONCURRENT);
        }
    }
    return _queue;
}

- (NSMachPort *)machPort {
    
    if (_machPort == nil) {
        _machPort = [[NSMachPort alloc] init];
    }
    return _machPort;
}

- (void)startRunLoopImmediatelyWithName:(NSString *)name {
    
    if (self.queue && !_runLoop && !_thread) {
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        __weak __typeof(self) weakSelf = self;
        dispatch_async(_queue, ^{
            if (weakSelf.shouldKeepRunning) {
                weakSelf.thread = [NSThread currentThread];
                if ([name isKindOfClass:[NSString class]]) {
                    [weakSelf.thread setName:name];
                } else {
                    [weakSelf.thread setName:[NSString stringWithFormat:@"com.66rpg.www_%p", self]];
                }
                weakSelf.runLoop = [NSRunLoop currentRunLoop];
                [weakSelf.runLoop addPort:weakSelf.machPort forMode:NSDefaultRunLoopMode];
                NSLog(@"已启动1： %@\n\n", weakSelf.thread);
                dispatch_semaphore_signal(semaphore);
                while (weakSelf.shouldKeepRunning && [weakSelf.runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
                NSLog(@"已启动2： %@\n\n", weakSelf.thread);
            }
        });
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
}

- (void)startRunLoop:(NSString *)threadName {
    
    _shouldKeepRunning = YES;
    [self startRunLoopImmediatelyWithName:threadName];
}

- (void)stopRunLoop {
    
    if (_runLoop && _machPort) {
        [_runLoop removePort:_machPort forMode:NSDefaultRunLoopMode];
//        CFRunLoopStop(_runLoop.getCFRunLoop);//这里不能强制退出，可能还有任务未执行完
    }
    _shouldKeepRunning = NO;
    _thread  = nil;
    _runLoop = nil;
}

- (void)asyncAddTask:(void(^)(void))task {
    
    if (_shouldKeepRunning) {
        [_runLoop performBlock:task];
    } else {
        dispatch_async(self.queue, task);
    }
}

- (void)syncAddTask:(void(^)(void))task {
    
    if (_shouldKeepRunning) {
        [_runLoop performBlock:task];
    } else {
        dispatch_sync(self.queue, task);
    }
}

- (void)dealloc {
    
    if (_machPort) {
        [self stopRunLoop];
        _machPort = nil;
    }
}

@end
