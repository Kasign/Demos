//
//  ViewController.m
//  多线程GCD
//
//  Created by walg on 2017/3/10.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "ViewController.h"
#import "FlyImageData.h"
#import "FLYTimer.h"

#define ROW_COUNT 7
#define COLUMN_COUNT 3
#define ROW_HEIGHT 60
#define ROW_WIDTH 100
#define CELL_SPACING 10

@interface ViewController (){
    NSMutableArray *_imageViews;
    NSMutableArray *_threads;
}

@property (nonatomic, strong) FLYTimer * timer;
@property (nonatomic, strong) dispatch_queue_t  queue;

@end

static NSString *imageUrl = @"https://img5q.duitang.com/uploads/item/201506/23/20150623203928_HzBWU.jpeg";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageViews = [NSMutableArray array];
    _threads = [NSMutableArray array];
    
    for (int i = 0; i<ROW_COUNT; i++) {
        for (int j =0; j<COLUMN_COUNT; j++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(j*ROW_WIDTH+(j*CELL_SPACING)+28, 80+i*ROW_HEIGHT+(i*CELL_SPACING), ROW_WIDTH, ROW_HEIGHT)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.backgroundColor= [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
            [self.view addSubview:imageView];
            [_imageViews addObject:imageView];
        }
    }
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(138, 580, 100, 30)];
    [btn1 setTitle:@"加载图片" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(loadImageWithMulatiThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    
//    self.timer = [FLYTimer timerWithTime:2 dely:1 block:^{
//
//        NSLog(@"222 %@", [NSThread currentThread]);
//    }];
//
//    NSLog(@"开始了");
//    [self.timer resume];
}

- (void)loadImageWithMulatiThread {
    
//    [self testA];
    [self testC];
}

- (void)safeWriteData:(void(^)(void))block {
    
//    NSLog(@"safe 1 -- 1");
    dispatch_barrier_sync(_queue, ^{
//        NSLog(@"safe 1 -- 2");
        if (block) {
            block();
        }
    });
}

- (void)safeReadData:(void(^)(void))block {
    
//    NSLog(@"safe 2 -- 1");
    dispatch_sync(_queue, ^{
//        NSLog(@"safe 2 -- 2");
        if (block) {
            block();
        }
    });
}

- (void)testC {
    
    _queue = dispatch_queue_create("abcd", DISPATCH_QUEUE_CONCURRENT);//并行队列
    
    dispatch_queue_t serialQueue = dispatch_queue_create("aa", DISPATCH_QUEUE_SERIAL);//串行队列
    dispatch_queue_t concurrentQueue1 = dispatch_queue_create("abcd", DISPATCH_QUEUE_CONCURRENT);//并行队列
    dispatch_queue_t concurrentQueue  = dispatch_queue_create("abcd", DISPATCH_QUEUE_CONCURRENT);//并行队列

    __block int j = 0;
    int i = 0;
    for (; i < 20; i ++) {
        [self safeReadData:^{
            NSLog(@"读取4 ： %d %d", i, j);
        }];
        dispatch_async(concurrentQueue1, ^{
            [self safeReadData:^{
                NSLog(@"读取6 ： %d %d", i, j);
            }];
        });
        dispatch_async(concurrentQueue1, ^{
            [self safeWriteData:^{
                j ++;
                NSLog(@"写入1 ： %d %d", i, j);
            }];
        });
        dispatch_async(concurrentQueue1, ^{
            [self safeWriteData:^{
                j ++;
                NSLog(@"写入2 ： %d %d", i, j);
            }];
        });
        dispatch_async(concurrentQueue1, ^{
            [self safeReadData:^{
                NSLog(@"读取1 ： %d %d", i, j);
            }];
            [self safeReadData:^{
                NSLog(@"读取2 ： %d %d", i, j);
            }];
        });
        dispatch_async(concurrentQueue1, ^{
            [self safeReadData:^{
                NSLog(@"读取5 ： %d %d", i, j);
            }];
        });
        [self safeReadData:^{
            NSLog(@"读取3 ： %d %d", i, j);
        }];
    }
}

- (void)testA {
    
    dispatch_queue_t serialQueue = dispatch_queue_create("aa", DISPATCH_QUEUE_SERIAL);//串行队列
    dispatch_queue_t concurrentQueue1 = dispatch_queue_create("abcd", DISPATCH_QUEUE_CONCURRENT);//并行队列
    dispatch_queue_t concurrentQueue  = dispatch_queue_create("abcd", DISPATCH_QUEUE_CONCURRENT);//并行队列

    __block int j = 0;
    int i = 0;
    for (; i < 20; i ++) {
        dispatch_async(concurrentQueue1, ^{
            NSLog(@"1 0-->> %@ %d", [NSThread currentThread], i);
            NSLog(@"1 1-->> %@ %d", [NSThread currentThread], i);
            dispatch_barrier_sync(concurrentQueue, ^{
                j ++;
                NSLog(@"  2 ----->> %@ %d", [NSThread currentThread], j);
            });
            NSLog(@"1 2-->> %@ %d", [NSThread currentThread], i);
            NSLog(@"1 3-->> %@ %d", [NSThread currentThread], i);
        });
    }
}

- (void)testB {
    
    dispatch_queue_t serialQueue = dispatch_queue_create("aa", DISPATCH_QUEUE_SERIAL);//串行队列
    dispatch_queue_t concurrentQueue = dispatch_queue_create("abcd", DISPATCH_QUEUE_CONCURRENT);//并行队列
    //
    //
//        dispatch_async(dispatch_queue_create("abcd", DISPATCH_QUEUE_SERIAL), ^{
//
////            dispatch_sync(serialQueue, ^{
////                [self loadImage:@5];
////            });
////            dispatch_sync(serialQueue, ^{
////                [self loadImage:@6];
////            });
////            dispatch_sync(serialQueue, ^{
////                [self loadImage:@7];
////            });
////            dispatch_sync(serialQueue, ^{
////                [self loadImage:@8];
////            });
//            [self loadImage:@4];
//            dispatch_async(serialQueue, ^{
//                [self loadImage:@0];
//            });
//            dispatch_async(serialQueue, ^{
//                [self loadImage:@1];
//            });
//            dispatch_async(serialQueue, ^{
//                [self loadImage:@2];
//            });
//            dispatch_async(serialQueue, ^{
//                [self loadImage:@3];
//            });
//
//        });

    
//        dispatch_async(serialQueue, ^{
//            [self loadImage:@0];
//        });
//        dispatch_async(serialQueue, ^{
//            [self loadImage:@1];
//        });
//        dispatch_async(serialQueue, ^{
//            [self loadImage:@2];
//        });
//        dispatch_async(serialQueue, ^{
//            [self loadImage:@3];
//        });
    //
    
//        dispatch_sync(concurrentQueue, ^{
//            [self loadImage:@10];
//        });
//        dispatch_sync(concurrentQueue, ^{
//            [self loadImage:@11];
//        });
//        dispatch_sync(concurrentQueue, ^{
//            [self loadImage:@12];
//        });
//        dispatch_sync(concurrentQueue, ^{
//            [self loadImage:@13];
//        });
    
//    dispatch_async(concurrentQueue, ^{
//        [self loadImage:@0];
//    });
//    dispatch_async(concurrentQueue, ^{
//        [self loadImage:@1];
//    });
//    dispatch_async(concurrentQueue, ^{
//        [self loadImage:@2];
//    });
//    dispatch_async(concurrentQueue, ^{
//        [self loadImage:@3];
//    });
    
//        dispatch_async(dispatch_queue_create("aaa", DISPATCH_QUEUE_SERIAL), ^{
//            [self loadImage:@0];
//        });
//        dispatch_async(dispatch_queue_create("bbb", DISPATCH_QUEUE_SERIAL), ^{
//            [self loadImage:@1];
//        });
//        dispatch_async(dispatch_queue_create("ccc", DISPATCH_QUEUE_SERIAL), ^{
//            [self loadImage:@2];
//        });
//        dispatch_async(dispatch_queue_create("ddd", DISPATCH_QUEUE_SERIAL), ^{
//            [self loadImage:@3];
//        });
//        dispatch_async(dispatch_queue_create("eee", DISPATCH_QUEUE_SERIAL), ^{
//            [self loadImage:@4];
//        });

//        dispatch_async(dispatch_queue_create("a", DISPATCH_QUEUE_CONCURRENT), ^{
//            [self loadImage:@14];
//        });
//        dispatch_async(dispatch_queue_create("b", DISPATCH_QUEUE_CONCURRENT), ^{
//            [self loadImage:@15];
//        });
//        dispatch_async(dispatch_queue_create("c", DISPATCH_QUEUE_CONCURRENT), ^{
//            [self loadImage:@16];
//        });
//        dispatch_async(dispatch_queue_create("d", DISPATCH_QUEUE_CONCURRENT), ^{
//            [self loadImage:@17];
//        });
    //    /**
    //     high优先级的获取方法
    //     */
    //    dispatch_queue_t globalHighQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    //    /**
    //     default优先级的获取方法
    //     */
    //    dispatch_queue_t globalDefaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //    /**
    //     low优先级的获取方法
    //     */
    //    dispatch_queue_t globalLowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    //    /**
    //     background优先级的获取方法
    //     */
    //
    //    dispatch_queue_t globalBackgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    //
    //    dispatch_set_target_queue(serialQueue, globalBackgroundQueue);
    //
    //    dispatch_group_t group = dispatch_group_create();
    //    dispatch_group_async(group, serialQueue, ^{
    //
    //    });
    //    dispatch_group_async(group, serialQueue, ^{
    //
    //    });
    //    dispatch_group_async(group, serialQueue, ^{
    //
    //    });
    //    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    //        NSLog(@"done");//执行完成后回调
    //    });
    
//    
//    dispatch_queue_t concurrentQueue = dispatch_queue_create("abcd", DISPATCH_QUEUE_CONCURRENT);//并行队列
    dispatch_async(concurrentQueue, ^{
        [self loadImageWithIndex:@0 message:nil];
        //读取数据0
    });
    dispatch_async(concurrentQueue, ^{
        [self loadImageWithIndex:@1 message:nil];
        //读取数据1
    });
    
    dispatch_sync(concurrentQueue, ^{
        [self loadImageWithIndex:@3 message:@"同步任务"];
        //读取数据3
    });
    
    dispatch_async(concurrentQueue, ^{
        [self loadImageWithIndex:@2 message:nil];
        //读取数据2
    });
    __block NSInteger a = 2;
    dispatch_barrier_async(concurrentQueue, ^{
        [self loadImageWithIndex:@4 message:@"异步栅栏"];
       //异步栅栏写入数据4
        a = 3;
    });
    NSLog(@"-->> %ld", (long)a);
    dispatch_barrier_sync(concurrentQueue, ^{
        [self loadImageWithIndex:@4 message:@"同步栅栏"];
        //同步栅栏写入数据4
        a = 4;
    });
    NSLog(@"-->> %ld", (long)a);
    dispatch_async(concurrentQueue, ^{
        [self loadImageWithIndex:@5 message:nil];
        //读取数据5
    });
    dispatch_async(concurrentQueue, ^{
        [self loadImageWithIndex:@6 message:nil];
        //读取数据6
    });
    dispatch_sync(concurrentQueue, ^{
        [self loadImageWithIndex:@7 message:@"同步任务"];
        //读取数据7
    });
    dispatch_async(concurrentQueue, ^{
        [self loadImageWithIndex:@8 message:nil];
        //读取数据8
    });
    [self loadImage:@9];
    
}

- (void)groupDemo {
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queue = dispatch_queue_create("abc.com", NULL);
    
        
    dispatch_group_async(group, queue, ^{
        
    });
    
    long result = dispatch_group_wait(group, DISPATCH_TIME_FOREVER);

    dispatch_group_notify(group, queue, ^{
        
    });
    
}

- (void)loadImage:(NSNumber*)index {
    
    NSLog(@"执行：%@ 线程信息：%@",index,[NSThread currentThread]);
    int i = [index intValue];
    sleep(0.5);//等待两秒
    
    FlyImageData *imageData = [[FlyImageData alloc] init];
    imageData.data = nil;
    imageData.index = i;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateImage:imageData];
    });
    
}

- (void)loadImageWithIndex:(NSNumber *)index message:(NSString *)message {
    
    NSLog(@"执行：%@ 线程信息：%@ %@", index, [NSThread currentThread], message);
    int i = [index intValue];
    sleep(0.5);//等待
    FlyImageData *imageData = [[FlyImageData alloc] init];
    imageData.data = nil;
    imageData.index = i;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateImage:imageData];
    });
}

- (void)updateImage:(FlyImageData*)imageData {
    
//    UIImage * image = [UIImage imageWithData:imageData.data];
//    UIImageView *imageView = _imageViews[imageData.index];
//    imageView.image = image;
    //    NSLog(@"%d",imageData.index);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
