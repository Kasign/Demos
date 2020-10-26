//
//  FLYTimer.m
//  多线程GCD
//
//  Created by Walg on 2020/2/26.
//  Copyright © 2020 walg. All rights reserved.
//

#import "FLYTimer.h"

@interface FLYTimer ()

@property (nonatomic, assign) float time;
@property (nonatomic, assign) float dely;
@property (nonatomic, copy)   FLYTimerBlock callBackBlock;
@property (nonatomic, strong) dispatch_source_t source;
@property (nonatomic, assign) BOOL isRunning;

@end


@implementation FLYTimer

+ (instancetype)timerWithTime:(float)time block:(FLYTimerBlock)block {
    
    return [self timerWithTime:time dely:0 block:block];
}

+ (instancetype)timerWithTime:(float)time dely:(float)dely block:(FLYTimerBlock)block {
    
    FLYTimer * timer = nil;
    if (time > 0 && dely >= 0 && block) {
        timer = [[FLYTimer alloc] initWithTime:time dely:dely block:block];
    }
    return timer;
}

- (instancetype)initWithTime:(NSInteger)time dely:(NSInteger)dely block:(FLYTimerBlock)block
{
    self = [super init];
    if (self) {
        
        _callBackBlock = block;
        _time = time;
        _dely = dely;
        _isRunning = NO;
        
        [self initSource];
    }
    return self;
}

- (void)initSource {
    
    dispatch_queue_t queue = dispatch_queue_create("flytimer.com", NULL);
    self.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    __weak __typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.source, ^{
        
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.callBackBlock) {
            strongSelf.callBackBlock();
        }
    });
    
    dispatch_source_set_cancel_handler(self.source, ^{
        
        
    });
    
    dispatch_source_set_timer(self.source, dispatch_time(DISPATCH_TIME_NOW, _dely * NSEC_PER_SEC), NSEC_PER_SEC * _time, 1000ull);
}

- (void)resume {
    
    if (!_isRunning) {
        dispatch_resume(self.source);
        _isRunning = YES;
    }
}

- (void)suspend {
    
    if (_isRunning) {
        dispatch_suspend(self.source);
        _isRunning = NO;
    }
}

- (void)cancel {
    
    if (dispatch_source_testcancel(self.source) == 0) {
        dispatch_source_cancel(self.source);
    }
    _isRunning = NO;
}

- (void)dealloc {
    
    NSLog(@"+++++++++++++++");
}

@end
