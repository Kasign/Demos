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

@property (nonatomic, assign) NSInteger             ticketCount;
@property (nonatomic, copy)   NSString          *   lockType;

@property (nonatomic, strong) NSLock            *   nslock;
@property (nonatomic, assign) pthread_mutex_t       pthread_mutex_t;
//@property (nonatomic, assign) OSSpinLock        osspinLock;
//@property (nonatomic, assign) os_unfair_lock_t  oc_unfair_lock;
@property (nonatomic, assign) pthread_rwlock_t      pthread_rwlock_t;
@property (nonatomic, strong) NSRecursiveLock   *   recursiveLock;
@property (nonatomic, strong) NSCondition       *   condition;
@property (nonatomic, strong) NSConditionLock   *   conditionLock;
@property (nonatomic, strong) dispatch_semaphore_t   semaphore;

@end

@implementation FlyForthController

/**
 互斥锁 1、@synchronized 2、NSLock 3、pthread_mutex
 自旋锁 1、OSSpinLock（已废弃） 2、os_unfair_lock:(互斥锁)
 读写锁 1、pthread_rwlock（）
 递归锁 1、NSRecursiveLock 2、pthread_mutex(recursive) 需要设置一些信息
 条件锁 1、NSCondition 2、NSConditionLock
 信号量 1、dispatch_semaphore
 
 简介：
 
 1->>
 读写锁 pthread_rwlock
 //加读锁
 pthread_rwlock_rdlock(&rwlock);
 //解锁
 pthread_rwlock_unlock(&rwlock);
 //加写锁
 pthread_rwlock_wrlock(&rwlock);
 //解锁
 pthread_rwlock_unlock(&rwlock);
 
 
 2->>
 信号量 dispatch_semaphore
 GCD 中的信号量是指 Dispatch Semaphore，是持有计数的信号。类似于过高速路收费站的栏杆。可以通过时，打开栏杆，不可以通过时，关闭栏杆。在 Dispatch Semaphore 中，使用计数来完成这个功能，计数为0时等待，不可通过。计数为1或大于1时，计数减1且不等待，可通过。
 1.dispatch_semaphore_create：创建一个Semaphore并初始化信号的总量 如果初始为0，lock等待任务完成加一，如果初始为1，先执行任务(尽量设为1)
 2.dispatch_semaphore_signal：
  这个函数会使传入的信号量dsema的值加1，返回值为long类型，当返回值为0时表示当前并没有线程等待其处理的信号量，其处理的信号量的值加1即可。当返回值不为0时，表示其当前有（一个或多个）线程等待其处理的信号量，并且该函数唤醒了一个等待的线程（当线程有优先级时，唤醒优先级最高的线程；否则随机唤醒）。dispatch_semaphore_wait的返回值也为long型。当其返回0时表示在timeout之前，该函数所处的线程被成功唤醒。当其返回不为0时，表示timeout发生。
 
 3.dispatch_semaphore_wait：可以使总信号量减1，如果当前信号总量为0时，该函数就会一直等待（阻塞所在线程）等待timeout，否则就可以正常执行。
  这个函数会使传入的信号量dsema的值减1；这个函数的作用是这样的，如果dsema信号量的值大于0，该函数所处线程就继续执行下面的语句，并且将信号量的值减1；如果desema的值为0，那么这个函数就阻塞当前线程等待timeout（注意timeout的类型为dispatch_time_t，不能直接传入整形或float型数），如果等待的期间desema的值被dispatch_semaphore_signal函数加1了，且该函数（即dispatch_semaphore_wait）所处线程获得了信号量，那么就继续向下执行并将信号量减1。如果等待期间没有获取到信号量或者信号量的值一直为0，那么等到timeout时，其所处线程自动执行其后语句。
 
 理解：
    关于信号量，一般可以用停车来比喻。
 
 　　停车场剩余4个车位，那么即使同时来了四辆车也能停的下。如果此时来了五辆车，那么就有一辆需要等待。
 
 　　信号量的值就相当于剩余车位的数目，dispatch_semaphore_wait函数就相当于来了一辆车，dispatch_semaphore_signal
 
 　　就相当于走了一辆车。停车位的剩余数目在初始化的时候就已经指明了（dispatch_semaphore_create（long value）），
 
 　　调用一次dispatch_semaphore_signal，剩余的车位就增加一个；调用一次dispatch_semaphore_wait剩余车位就减少一个；
 
 　　当剩余车位为0时，再来车（即调用dispatch_semaphore_wait）就只能等待。有可能同时有几辆车等待一个停车位。有些车主
 
 　　没有耐心，给自己设定了一段等待时间，这段时间内等不到停车位就走了，如果等到了就开进去停车。而有些车主就像把车停在这，
 
 　　所以就一直等下去。
 
    https://www.cnblogs.com/SUPER-F/p/8916490.html （参考）
 
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"锁 + 多线程";

    _nslock = [NSLock new];
    pthread_mutex_init(&_pthread_mutex_t, NULL);
//    _osspinLock = OS_SPINLOCK_INIT;
//    _oc_unfair_lock = &(OS_UNFAIR_LOCK_INIT);
    _recursiveLock = [NSRecursiveLock new];
    _conditionLock = [[NSConditionLock alloc] initWithCondition:0];
    _condition = [NSCondition new];
    _semaphore = dispatch_semaphore_create(1);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    _lockType = @"@synchronized";
    _lockType = @"dispatch_semaphore";
//    _lockType = @"nslock";
//    _lockType = @"NSRecursiveLock";
//    _lockType = @"pthread_mutex_t";
    [self startTest];
}

- (void)startTest
{
    FLYLog(@" ---->>>>> 当前锁类型：%@", _lockType);
    FLYLog(@"------------------------Start-----------------------");

    if ([_lockType isEqualToString:@"dispatch_semaphore"]) {
        [self lockTestSemaphore];
    } else {
//        [self lockTest];
        [self lockTest2];
    }
    FLYLog(@"------------------------End-----------------------");
}

- (void)testDispatch
{
    __block int a = 0;
    while (a < 5) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            a ++;
            FLYLog(@"%@ - %d", [NSThread currentThread], a);
        });
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        FLYLog(@"最终结果 ***** %@ - %d", [NSThread currentThread], a);
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        FLYLog(@"%d", a);
    });
    
    FLYLog(@" >>>>--- >>> %d", a);
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
        overTime = DISPATCH_TIME_FOREVER;
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
            [self logString:string];
        }
    } else {
        if ([self fly_lock]) {
            [self logString:string];
            [self fly_unlock];
        }
    }
}

- (void)logString:(NSString *)string
{
    FLYLog(@"start-->> %@ %@", string, [NSThread currentThread]);
    sleep(3);
    FLYLog(@"  end-->> %@ %@", string, [NSThread currentThread]);
}

- (void)lockTest
{
    FLYLog(@"*** 外部1 ***");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FLYLog(@"=== 进入 线程1 --");
        [self lockAndlogStrings:@"线程1 异步 执行"];
        FLYLog(@"=== 离开 线程1 ++");
    });
    
    FLYLog(@"*** 外部2 ***");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FLYLog(@"=== 进入 线程2 --");
        [self lockAndlogStrings:@"线程2 异步 执行"];
        FLYLog(@"=== 离开 线程2 ++");
    });
    
    FLYLog(@"*** 外部3 ***");
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FLYLog(@"=== 进入 线程3 --");
        [self lockAndlogStrings:@"线程3 同步 执行"];
        FLYLog(@"=== 离开 线程3 ++");
    });
    
    FLYLog(@"*** 外部4 ***");
    [self lockAndlogStrings:@"线程4 异步 执行"];
    
    FLYLog(@"*** 外部5 ***");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FLYLog(@"=== 进入 线程5 --");
        [self lockAndlogStrings:@"线程5 异步 执行"];
        FLYLog(@"=== 离开 线程5 ++");
    });
    
    FLYLog(@"*** 外部6 ***");
}

- (void)lockTest2
{
    dispatch_queue_t queue = nil;
//    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    queue = dispatch_queue_create("abc", DISPATCH_QUEUE_CONCURRENT);
//    queue = dispatch_queue_create("bcd", DISPATCH_QUEUE_SERIAL);
    
    FLYLog(@"*** 外部1 ***");
    dispatch_async(queue, ^{
        FLYLog(@"=== 进入 线程1 --");
        [self lockAndlogStrings:@"线程1 异步 执行"];
        FLYLog(@"=== 离开 线程1 ++");
    });
    
    FLYLog(@"*** 外部2 ***");
    dispatch_async(queue, ^{
        FLYLog(@"=== 进入 线程2 --");
        [self lockAndlogStrings:@"线程2 异步 执行"];
        FLYLog(@"=== 离开 线程2 ++");
    });
    
    FLYLog(@"*** 外部3 ***");
    dispatch_sync(queue, ^{
        FLYLog(@"=== 进入 线程3 --");
        [self lockAndlogStrings:@"线程3 同步 执行"];
        FLYLog(@"=== 离开 线程3 ++");
    });
    FLYLog(@"*** 外部4 ***");
    
    dispatch_async(queue, ^{
        FLYLog(@"=== 进入 线程4 --");
        [self lockAndlogStrings:@"线程4 异步 执行"];
        FLYLog(@"=== 离开 线程4 ++");
    });
    
    FLYLog(@"*** 外部5 ***");
}

- (void)lockTestSemaphore
{
    FLYLog(@"*** 外部1 ***");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self fly_lock];
        [self logString:@"线程1 异步 执行"];
        [self fly_unlock];
    });

    FLYLog(@"*** 外部2 ***");
//    [self fly_lock];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self fly_lock];
        [self logString:@"线程2 异步 执行"];
        [self fly_unlock];
    });

    FLYLog(@"*** 外部3 ***");
//    [self fly_lock];
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self fly_lock];
        [self logString:@"线程3 同步 执行"];
        [self fly_unlock];
    });

    FLYLog(@"*** 外部4 ***");
    [self lockAndlogStrings:@"线程4 异步 执行"];

    FLYLog(@"*** 外部5 ***");
//    [self fly_lock];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self fly_lock];
        [self logString:@"线程5 异步 执行"];
        [self fly_unlock];
    });

    FLYLog(@"*** 外部6 ***");
    
    _ticketCount = 50;
    dispatch_queue_t queue1 = dispatch_queue_create("net.bujige.testQueue1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue2 = dispatch_queue_create("net.bujige.testQueue2", DISPATCH_QUEUE_CONCURRENT);
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(queue1, ^{
        [weakSelf saleTicketSafe];
    });
    
    dispatch_async(queue2, ^{
        [weakSelf saleTicketSafe];
    });
}

- (void)saleTicketSafe
{
    while (1) {
        //加锁
        [self fly_lock];
        if (self.ticketCount > 0) {
            //如果还有票，继续售卖
            self.ticketCount--;
            FLYLog(@"%@", [NSString stringWithFormat:@"剩余票数：%ld 窗口：%@", self.ticketCount, [NSThread currentThread]]);
            sleep(1);
            //解锁
            [self fly_unlock];
        } else {
            //如果已卖完，关闭售票窗口
            FLYLog(@"所有火车票均已售完");
            //解锁
            [self fly_unlock];
            break;
        }
    }
}

@end
