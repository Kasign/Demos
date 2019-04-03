//
//  ViewController.m
//  锁
//
//  Created by mx-QS on 2019/4/2.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, assign) NSInteger       ticketsCount;
@property (nonatomic, strong) dispatch_semaphore_t   lock;
@property (nonatomic, strong) NSMutableDictionary   *   dict;

@end

@implementation ViewController
@synthesize dict = _dict;

- (void)viewDidLoad {
    [super viewDidLoad];
    _lock = dispatch_semaphore_create(1);
    _dict = [NSMutableDictionary dictionary];
}

- (NSString *)pathForFile
{
    NSArray * documentArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path = [[documentArr firstObject] stringByAppendingString:@"/temp"];
    return path;
}

- (void)setDict:(NSMutableDictionary *)dict
{
//    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    _dict = dict;
    [_dict writeToFile:[self pathForFile] atomically:NO];
//    dispatch_semaphore_signal(_lock);
}

- (NSMutableDictionary *)dict
{
//    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    NSDictionary * dis = [NSDictionary dictionaryWithContentsOfFile:[self pathForFile]];
    if (dis) {
        [_dict removeAllObjects];
        [_dict addEntriesFromDictionary:dis];
    }
//    dispatch_semaphore_signal(_lock);
    return _dict;
}

/** 卖1张票 */
- (void)saleTicket
{
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    self.ticketsCount--;
    NSLog(@"--Sale-->> %ld \n %@", self.ticketsCount, [NSThread currentThread]);
    dispatch_semaphore_signal(_lock);
}

- (void)getTicket
{
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    self.ticketsCount++;
    NSLog(@"--Get-->> %ld \n %@", self.ticketsCount, [NSThread currentThread]);
    dispatch_semaphore_signal(_lock);
}

/** 卖票演示 */
- (void)ticketTest
{
    self.ticketsCount = 15;
    dispatch_queue_t queue = dispatch_queue_create("fly-com-1", DISPATCH_QUEUE_CONCURRENT);
    // 窗口一
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self saleTicket];
            NSLog(@"%ld",(long)self.ticketsCount);
        }
        NSLog(@"--1-->>%@", [NSThread currentThread]);
    });
    
    
    queue = dispatch_queue_create("fly-com-2", DISPATCH_QUEUE_CONCURRENT);
    // 窗口二
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self getTicket];
            NSLog(@"%ld",(long)self.ticketsCount);
        }
        NSLog(@"--2-->>%@", [NSThread currentThread]);
    });
    
    
    queue = dispatch_queue_create("fly-com-3", DISPATCH_QUEUE_CONCURRENT);
    // 窗口三
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self saleTicket];
            NSLog(@"%ld",(long)self.ticketsCount);
        }
        NSLog(@"--3-->>%@", [NSThread currentThread]);
    });
}

- (void)dictDataTest
{
    dispatch_queue_t queue = dispatch_queue_create("fly-com-1", DISPATCH_QUEUE_CONCURRENT);
    __block NSMutableDictionary * blockDict = self.dict;
    dispatch_async(queue, ^{
        NSInteger i = 0;
        while (i <= 200) {
            NSString * value0 = [@"name" stringByAppendingFormat:@"%ld",(long)i];
            NSString * value1 = [@"age" stringByAppendingFormat:@"%ld",(long)i];
            [blockDict setObject:value0 forKey:[value0 copy]];
            [blockDict setObject:value1 forKey:[value1 copy]];
            i ++;
        }
        NSLog(@"---->>>>> %p", &blockDict);
        [self setDict:blockDict];
    });
    dispatch_async(queue, ^{
        NSInteger i = 0;
        while (i <= 105) {
            NSLog(@"---->>>>\n%@",self.dict);
            i ++;
        }
    });
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesEnded:touches withEvent:event];
//    [self ticketTest];
    [self dictDataTest];
}

@end
