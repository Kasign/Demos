//
//  FlyForthController.m
//  算法+链表
//
//  Created by mx-QS on 2019/9/5.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "FlyForthController.h"
#import <pthread.h>
//#import <OSSpinLockDeprecated.h>

@interface FlyForthController ()

@property (nonatomic, copy) NSString   *   lockType;

@property (nonatomic, strong) NSLock        *   nslock;
@property (nonatomic, assign) pthread_mutex_t   pthread_mutex_t;
//@property (nonatomic, assign) OSSpinLock        osspinLock;
//@property (nonatomic, assign) os_unfair_lock_t  oc_unfair_lock;
@property (nonatomic, assign) pthread_rwlock_t    pthread_rwlock_t;
@property (nonatomic, strong) NSRecursiveLock   *   recursiveLock;
@property (nonatomic, strong) NSCondition       *   condition;
@property (nonatomic, strong) NSConditionLock   *   conditionLock;
@property (nonatomic, strong) dispatch_semaphore_t   semaphore;

@end

@implementation FlyForthController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"🔐锁🔐";

//    互斥锁 1、@synchronized 2、NSLock 3、pthread_mutex
//    自旋锁 1、OSSpinLock（已废弃） 2、os_unfair_lock:(互斥锁)
//    读写锁 1、pthread_rwlock（）
//    递归锁 1、NSRecursiveLock 2、pthread_mutex(recursive) 需要设置一些信息
//    条件锁 1、NSCondition 2、NSConditionLock
//    信号量 1、dispatch_semaphore
    
    _nslock = [NSLock new];
    pthread_mutex_init(&_pthread_mutex_t, NULL);
//    _osspinLock = OS_SPINLOCK_INIT;
//    _oc_unfair_lock = &(OS_UNFAIR_LOCK_INIT);
    _recursiveLock = [NSRecursiveLock new];
    _condition = [NSCondition new];
    _conditionLock = [[NSConditionLock alloc] initWithCondition:0];
    _semaphore = dispatch_semaphore_create(1);
    
    _lockType = @"@synchronized";
}

/*
 读写锁 pthread_rwlock
 //加读锁
 pthread_rwlock_rdlock(&rwlock);
 //解锁
 pthread_rwlock_unlock(&rwlock);
 //加写锁
 pthread_rwlock_wrlock(&rwlock);
 //解锁
 pthread_rwlock_unlock(&rwlock);
 */

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self startTest];
}

- (void)startTest
{
    FlyLog(@" ---->>>>> 当前锁类型：%@", _lockType);
    FlyLog(@"------------------------Start-----------------------");
//    [self lockTest];
    [self lockTest2];
    FlyLog(@"------------------------End-----------------------");
}

- (BOOL)fly_lock
{
    BOOL result = YES;
    NSString * typeString = _lockType.lowercaseString;
    if ([typeString isEqualToString:@"nslock"]) {
        [_nslock lock];
    } else if ([typeString isEqualToString:@"pthread_mutex_t"]) {
        result = pthread_mutex_trylock(&_pthread_mutex_t) == 0;
//        if (result) {
//            pthread_mutex_lock(&_pthread_mutex_t);
//        }
    } else if ([typeString isEqualToString:@"osspinlock"]) {
        
    } else if ([typeString isEqualToString:@"os_unfair_lock_t"]) {
        
    } else if ([typeString isEqualToString:@"pthread_rwlock"]) {
        
    } else if ([typeString isEqualToString:@"nsrecursivelock"]) {
        [_recursiveLock lock];
    } else if ([typeString isEqualToString:@"nscondition"]) {
        [_condition wait];
    } else if ([typeString isEqualToString:@"nsconditionlock"]) {
        if ([_conditionLock tryLockWhenCondition:1]) {
            [_conditionLock lockWhenCondition:1];
        }
    } else if ([typeString isEqualToString:@"dispatch_semaphore"]) {
        dispatch_time_t overTime = dispatch_time(DISPATCH_TIME_NOW, 6 * NSEC_PER_SEC);
        dispatch_semaphore_wait(_semaphore, overTime);
    }
    return result;
}

- (void)fly_unlock
{
    NSString * typeString = _lockType.lowercaseString;
    if ([typeString isEqualToString:@"nslock"]) {
        [_nslock unlock];
    } else if ([typeString isEqualToString:@"pthread_mutex_t"]) {
        pthread_mutex_unlock(&_pthread_mutex_t);
    } else if ([typeString isEqualToString:@"osspinlock"]) {
        
    } else if ([typeString isEqualToString:@"os_unfair_lock_t"]) {
        
    } else if ([typeString isEqualToString:@"pthread_rwlock"]) {
        
    } else if ([typeString isEqualToString:@"nsrecursivelock"]) {
        [_recursiveLock unlock];
    } else if ([typeString isEqualToString:@"nscondition"]) {
        [_condition signal];
    } else if ([typeString isEqualToString:@"nsconditionlock"]) {
        [_conditionLock unlockWithCondition:1];
    } else if ([typeString isEqualToString:@"dispatch_semaphore"]) {
        dispatch_semaphore_signal(_semaphore);
    }
}

- (void)lockAndlogStrings:(NSString *)string
{
    sleep(2);
    if ([_lockType.lowercaseString isEqualToString:@"@synchronized"]) {
        @synchronized(self) {
            FlyLog(@"start-->> %@ %@", string, [NSThread currentThread]);
            sleep(3);
            FlyLog(@"  end-->> %@ %@", string, [NSThread currentThread]);
        }
    } else {
        if ([self fly_lock]) {
            FlyLog(@"start-->> %@ %@", string, [NSThread currentThread]);
            sleep(3);
            FlyLog(@"  end-->> %@ %@", string, [NSThread currentThread]);
            [self fly_unlock];
        }
    }
}

- (void)lockTest
{
    FlyLog(@"*** 外部1 ***");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FlyLog(@"=== 进入 线程1 --");
        [self lockAndlogStrings:@"线程1 异步 执行"];
        FlyLog(@"=== 离开 线程1 ++");
    });
    
    FlyLog(@"*** 外部2 ***");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FlyLog(@"=== 进入 线程2 --");
        [self lockAndlogStrings:@"线程2 异步 执行"];
        FlyLog(@"=== 离开 线程2 ++");
    });
    
    FlyLog(@"*** 外部3 ***");
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FlyLog(@"=== 进入 线程3 --");
        [self lockAndlogStrings:@"线程3 同步 执行"];
        FlyLog(@"=== 离开 线程3 ++");
    });
    FlyLog(@"*** 外部4 ***");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FlyLog(@"=== 进入 线程4 --");
        [self lockAndlogStrings:@"线程4 异步 执行"];
        FlyLog(@"=== 离开 线程4 ++");
    });
    
    FlyLog(@"*** 外部5 ***");
}

- (void)lockTest2
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    FlyLog(@"*** 外部1 ***");
    dispatch_async(queue, ^{
        FlyLog(@"=== 进入 线程1 --");
        [self lockAndlogStrings:@"线程1 异步 执行"];
        FlyLog(@"=== 离开 线程1 ++");
    });
    
    FlyLog(@"*** 外部2 ***");
    dispatch_async(queue, ^{
        FlyLog(@"=== 进入 线程2 --");
        [self lockAndlogStrings:@"线程2 异步 执行"];
        FlyLog(@"=== 离开 线程2 ++");
    });
    
    FlyLog(@"*** 外部3 ***");
    dispatch_sync(queue, ^{
        FlyLog(@"=== 进入 线程3 --");
        [self lockAndlogStrings:@"线程3 同步 执行"];
        FlyLog(@"=== 离开 线程3 ++");
    });
    FlyLog(@"*** 外部4 ***");
    
    dispatch_async(queue, ^{
        FlyLog(@"=== 进入 线程4 --");
        [self lockAndlogStrings:@"线程4 异步 执行"];
        FlyLog(@"=== 离开 线程4 ++");
    });
    
    FlyLog(@"*** 外部5 ***");
}



@end
