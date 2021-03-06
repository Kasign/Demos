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
 互斥锁 1、@synchronized   2、NSLock   3、pthread_mutex
 自旋锁 1、OSSpinLock（已废弃） 2、os_unfair_lock:(互斥锁)
 读写锁 1、pthread_rwlock（）
 递归锁 1、NSRecursiveLock  2、pthread_mutex(recursive) 需要设置一些信息
 条件锁 1、NSCondition  2、NSConditionLock
 信号量 1、dispatch_semaphore
 
 简介：
 
 ⾃旋锁：
         线程反复检查锁变量是否可⽤。由于线程在这⼀过程中保持执⾏，
         因此是⼀种忙等待。⼀旦获取了⾃旋锁，线程会⼀直保持该锁，直⾄显式释
         放⾃旋锁。 ⾃旋锁避免了进程上下⽂的调度开销，因此对于线程只会阻塞很
         短时间的场合是有效的。
 
 线程获取锁的时候，如果锁被其他线程持有，则当前线程将循环等待，直到获取到锁。
 自旋锁等待期间，线程的状态不会改变，线程一直是用户态并且是活动的(active)。
 自旋锁如果持有锁的时间太长，则会导致其它等待获取锁的线程耗尽CPU。
 自旋锁本身无法保证公平性，同时也无法保证可重入性。
 基于自旋锁，可以实现具备公平性和可重入性质的锁。
 
 作者：Java高级架构狮
 链接：https://www.jianshu.com/p/9d3660ad4358
 来源：简书
 
        • OSSpinLock（已废弃）
        • os_unfair_lock:(互斥锁)
 互斥锁：
         是⼀种⽤于多线程编程中，防⽌两条线程同时对同⼀公共资源（⽐
         如全局变量）进⾏读写的机制。该⽬的通过将代码切⽚成⼀个⼀个的临界区
         ⽽达成
         这⾥属于互斥锁的有：
         • NSLock
         • pthread_mutex
         • @synchronized
 条件锁：
         就是条件变量，当进程的某些资源要求不满⾜时就进⼊休眠，也就
         是锁住了。当资源被分配到了，条件锁打开，进程继续运⾏
         • NSCondition
         • NSConditionLock
 递归锁：
         就是同⼀个线程可以加锁N次⽽不会引发死锁
         • NSRecursiveLock
         • pthread_mutex(recursive)
 信号量（semaphore）：
         是⼀种更⾼级的同步机制，互斥锁可以说是semaphore在仅取值0/1时的特例。信号量可以有更多的取值空间，⽤来实
         现更加复杂的同步，⽽不单单是线程间互斥。
         • dispatch_semaphore
 
 其实基本的锁就包括了三类 ⾃旋锁 互斥锁 读写锁，
 其他的⽐如条件锁，递归锁，信号量都是上层的封装和实现！
 
 读写锁：
         读写锁实际是⼀种特殊的⾃旋锁，它把对共享资源的访问者划分成读者和写者，读者只对共享资源
         进⾏读访问，写者则需要对共享资源进⾏写操作。这种锁相对于⾃旋锁⽽⾔，能提⾼并发性，因为
         在多处理器系统中，它允许同时有多个读者来访问共享资源，最⼤可能的读者数为实际的逻辑CPU
         数。写者是排他性的，⼀个读写锁同时只能有⼀个写者或多个读者（与CPU数相关），但不能同时
         既有读者⼜有写者。在读写锁保持期间也是抢占失效的。
         如果读写锁当前没有读者，也没有写者，那么写者可以⽴刻获得读写锁，否则它必须⾃旋在那⾥，
         直到没有任何写者或读者。如果读写锁没有写者，那么读者可以⽴即获得该读写锁，否则读者必须
         ⾃旋在那⾥，直到写者释放该读写锁。
         ⼀次只有⼀个线程可以占有写模式的读写锁, 但是可以有多个线程同时占有读模式的读写锁. 正
         是因为这个特性,
         当读写锁是写加锁状态时, 在这个锁被解锁之前, 所有试图对这个锁加锁的线程都会被阻塞.
         当读写锁在读加锁状态时, 所有试图以读模式对它进⾏加锁的线程都可以得到访问权, 但是如果
         线程希望以写模式对此锁进⾏加锁, 它必须直到所有的线程释放锁.
         通常, 当读写锁处于读模式锁住状态时, 如果有另外线程试图以写模式加锁, 读写锁通常会阻塞
         随后的读模式锁请求, 这样可以避免读模式锁⻓期占⽤, ⽽等待的写模式锁请求⻓期阻塞.
         读写锁适合于对数据结构的读次数⽐写次数多得多的情况. 因为, 读模式锁定时可以共享, 以写
         模式锁住时意味着独占, 所以读写锁⼜叫共享-独占锁.
         
         读写锁适合于对数据结构的读次数⽐写次数多得多的情况. 因为, 读模式锁定时可以共享, 以写模式锁住时意味
         着独占, 所以读写锁⼜叫共享-独占锁.
         #include <pthread.h>
         int pthread_rwlock_init(pthread_rwlock_t *restrict rwlock, const pthread_rwlockattr_t *restrict attr);
         int pthread_rwlock_destroy(pthread_rwlock_t *rwlock)
         成功则返回0, 出错则返回错误编号.
         同互斥量以上, 在释放读写锁占⽤的内存之前, 需要先通过pthread_rwlock_destroy对读写锁进⾏清理⼯作, 释
         放由init分配的资源.
         #include <pthread.h>
         int pthread_rwlock_rdlock(pthread_rwlock_t *rwlock);
         int pthread_rwlock_wrlock(pthread_rwlock_t *rwlock);
         int pthread_rwlock_unlock(pthread_rwlock_t *rwlock);
         成功则返回0, 出错则返回错误编号.
         这3个函数分别实现获取读锁, 获取写锁和释放锁的操作. 获取锁的两个函数是阻塞操作, 同样, ⾮阻塞的函数为:
         #include <pthread.h>
         int pthread_rwlock_tryrdlock(pthread_rwlock_t *rwlock);
         int pthread_rwlock_trywrlock(pthread_rwlock_t *rwlock);
         成功则返回0, 出错则返回错误编号.
         ⾮阻塞的获取锁操作, 如果可以获取则返回0, 否则返回错误的EBUSY.
 
 
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
    _lockType = @"@synchronized";
//    _lockType = @"dispatch_semaphore";
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
//    queue = dispatch_queue_create("abc", DISPATCH_QUEUE_CONCURRENT);
    queue = dispatch_queue_create("bcd", DISPATCH_QUEUE_SERIAL);
    
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
