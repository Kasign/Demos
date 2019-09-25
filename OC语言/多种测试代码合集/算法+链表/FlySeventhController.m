//
//  FlySeventhController.m
//  算法+链表
//
//  Created by mx-QS on 2019/9/10.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "FlySeventhController.h"


@interface FlyNotiObject : NSObject

@end

@implementation FlyNotiObject

- (void)didReceivedNoti:(NSNotification *)noti
{
    sleep(3);
    FLYLog(@" --->>> %@ %@", self, [NSThread currentThread]);
}

@end

/**
 通知结论：
 1、接到通知的方法与发送通知处于同一线程
 2、接到通知的方法同步执行（等上一个方法执行结束，才执行下一个被通知者的方法）
 */
@interface FlySeventhController ()

@property (nonatomic, strong) NSMutableArray   *   objectArray;

@end

@implementation FlySeventhController

- (void)viewDidLoad {
    [super viewDidLoad];
    _objectArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 5; i++) {
        FlyNotiObject * object = [[FlyNotiObject alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:object selector:@selector(didReceivedNoti:) name:@"FlyNoti" object:nil];
        [_objectArray addObject:object];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    dispatch_queue_t queue = nil;
//    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    queue = dispatch_get_main_queue();
    queue = dispatch_queue_create("abc", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FlyNoti" object:nil];
    });
}

@end
