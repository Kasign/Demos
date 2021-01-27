//
//  FLYGCD.m
//  多线程+RunLoop---Demo
//
//  Created by Qiushan on 2020/9/10.
//  Copyright © 2020 FLY. All rights reserved.
//

#import "FLYGCD.h"

@interface FLYMachPort : NSObject
@property (nonatomic, strong) NSMachPort  * machPort;
@end

@interface FLYRunLoop : NSObject

@property (nonatomic, strong) NSRunLoop * runLoop;
@property (nonatomic, strong) NSThread  * thread;

@end

@implementation FLYRunLoop

- (void)dealloc {
    
    NSLog(@"%s", __func__);
}

@end

@implementation FLYMachPort

- (NSMachPort *)machPort {
    
    if (_machPort == nil) {
        _machPort = (NSMachPort *)[NSMachPort port];
    }
    return _machPort;
}

- (void)dealloc {
    
    NSLog(@"%s", __func__);
}

@end

@interface FLYGCD ()

@property (nonatomic, strong, readwrite) dispatch_queue_t queue;

@property (nonatomic, strong) FLYRunLoop  * runLoopObj;
@property (nonatomic, strong) FLYMachPort * portObj;
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

- (FLYMachPort *)portObj {
    
    if (_portObj == nil) {
        _portObj = [[FLYMachPort alloc] init];
    }
    return _portObj;
}

- (FLYRunLoop *)runLoopObj {
    
    if (_runLoopObj == nil) {
        _runLoopObj = [[FLYRunLoop alloc] init];
    }
    return _runLoopObj;
}

- (NSRunLoop *)runLoop {
    
    return _runLoopObj.runLoop;
}

- (void)startRunLoopImmediatelyWithName:(NSString *)name {
    
    if (self.queue && !_runLoopObj) {
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        __weak __typeof(self) weakSelf = self;
        dispatch_async(_queue, ^{
            if (weakSelf.shouldKeepRunning) {
                NSThread * thread = [NSThread currentThread];
                if ([name isKindOfClass:[NSString class]]) {
                    [thread setName:name];
                } else {
                    [thread setName:[NSString stringWithFormat:@"com.66rpg.www_%p", self]];
                }
                weakSelf.runLoopObj.thread  = thread;
                weakSelf.runLoopObj.runLoop = [NSRunLoop currentRunLoop];
                [weakSelf.runLoopObj.runLoop addPort:weakSelf.portObj.machPort forMode:NSDefaultRunLoopMode];
                dispatch_semaphore_signal(semaphore);
                while (weakSelf.shouldKeepRunning && [weakSelf.runLoopObj.runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
                if (weakSelf.runLoopObj.runLoop) {
                    CFRunLoopStop(weakSelf.runLoopObj.runLoop.getCFRunLoop);
                }
                weakSelf.runLoopObj.runLoop = nil;
                weakSelf.runLoopObj = nil;
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
    
    if (_runLoopObj.runLoop && _portObj) {
        [_runLoopObj.runLoop removePort:_portObj.machPort forMode:NSDefaultRunLoopMode];
        __weak __typeof(self) weakSelf = self;
        [_runLoopObj.runLoop performBlock:^{
            if (weakSelf.runLoopObj.runLoop) {
                CFRunLoopStop(weakSelf.runLoopObj.runLoop.getCFRunLoop);
            }
        }];
    }
    _shouldKeepRunning = NO;
    _portObj = nil;
}

- (void)asyncAddTask:(void(^)(void))task {
    
    if (_shouldKeepRunning) {
        [_runLoopObj.runLoop performBlock:task];
    } else {
        dispatch_async(self.queue, task);
    }
}

- (void)syncAddTask:(void(^)(void))task {
    
    if (_shouldKeepRunning) {
        [_runLoopObj.runLoop performBlock:task];
    } else {
        dispatch_sync(self.queue, task);
    }
}

- (void)dealloc {
    
    if (_portObj) {
        [self stopRunLoop];
        _portObj = nil;
    }
    NSLog(@"%s", __func__);
}

@end
