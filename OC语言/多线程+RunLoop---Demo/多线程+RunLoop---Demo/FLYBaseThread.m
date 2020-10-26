//
//  FLYBaseThread.m
//  多线程+RunLoop---Demo
//
//  Created by Qiushan on 2020/9/10.
//  Copyright © 2020 FLY. All rights reserved.
//

#import "FLYBaseThread.h"

@interface FLYBaseThread ()

@property (nonatomic, assign) BOOL                  cancel;
@property (nonatomic, strong) NSMutableArray     *  actionsArr;
@property (nonatomic, strong) dispatch_semaphore_t  semphore;

@end

@implementation FLYBaseThread

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cancel     = NO;
        _actionsArr = [NSMutableArray array];
        _semphore   = dispatch_semaphore_create(0);
    }
    return self;
}

- (void)onThread:(id)object {
    
//    添加port源，保证runloop正常轮询，不会创建后直接退出。
//    [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
//
//    //开启runloop
//    [[NSRunLoop currentRunLoop] run];

    CFRunLoopSourceContext context = {0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL};
    CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    
    BOOL runAlways = YES; // Introduced to cheat Static Analyzer
    while (runAlways) {
        
//        CFRunLoopRun();
        
        dispatch_semaphore_wait(_semphore, DISPATCH_TIME_FOREVER);
        if(_cancel){
            break;
        }
        
        // 开始执行任务
        dispatch_block_t block = [_actionsArr firstObject];
        if(block){
            [_actionsArr removeObject:block];
            block();
        }
    }
    
//    // Should never be called, but anyway
//    CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
//    CFRelease(source);
    
}

- (void)addAction:(dispatch_block_t)action {
    
    if(!_cancel && action){ // 如果线程已经cancel了，那么直接忽略
        // 将任务放入数组
        [_actionsArr addObject:[action copy]];
        // 发送信号，信号量加1
        dispatch_semaphore_signal(_semphore);
    }
}

- (void)cancelThread {
    
    _cancel = YES;
    // 线程取消后，清空所有的回调
    [_actionsArr removeAllObjects];
    // 相当于发送一个终止任务的信号
    dispatch_semaphore_signal(_semphore);
}

@end
