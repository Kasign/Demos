//
//  ViewController.m
//  多线程GCD
//
//  Created by walg on 2017/3/10.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "ViewController.h"
#import "FlyImageData.h"

#define ROW_COUNT 7
#define COLUMN_COUNT 3
#define ROW_HEIGHT 60
#define ROW_WIDTH 100
#define CELL_SPACING 10

@interface ViewController (){
    NSMutableArray *_imageViews;
    NSMutableArray *_threads;
}

@end

static NSString *imageUrl = @"http://img5q.duitang.com/uploads/item/201506/23/20150623203928_HzBWU.jpeg";

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
    
}

-(void)loadImageWithMulatiThread{
    
    //    dispatch_queue_t serialQueue = dispatch_queue_create("aa", DISPATCH_QUEUE_SERIAL);//串行队列
    //
    //
    //    dispatch_async(dispatch_queue_create("abcd", DISPATCH_QUEUE_SERIAL), ^{
    //
    //        dispatch_sync(serialQueue, ^{
    //            [self loadImage:@5];
    //        });
    //        dispatch_sync(serialQueue, ^{
    //            [self loadImage:@6];
    //        });
    //        dispatch_sync(serialQueue, ^{
    //            [self loadImage:@7];
    //        });
    //        dispatch_sync(serialQueue, ^{
    //            [self loadImage:@8];
    //        });
    //
    //    });
    //
    //    dispatch_async(dispatch_queue_create("aaa", DISPATCH_QUEUE_SERIAL), ^{
    //        [self loadImage:@0];
    //    });
    //    dispatch_async(dispatch_queue_create("aaa", DISPATCH_QUEUE_SERIAL), ^{
    //        [self loadImage:@1];
    //    });
    //    dispatch_async(dispatch_queue_create("aaa", DISPATCH_QUEUE_SERIAL), ^{
    //        [self loadImage:@2];
    //    });
    //    dispatch_async(dispatch_queue_create("aaa", DISPATCH_QUEUE_SERIAL), ^{
    //        [self loadImage:@3];
    //    });
    //    dispatch_async(dispatch_queue_create("aaa", DISPATCH_QUEUE_SERIAL), ^{
    //        [self loadImage:@4];
    //    });
    //
    //
    //    dispatch_async(serialQueue, ^{
    //        [self loadImage:@0];
    //    });
    //    dispatch_async(serialQueue, ^{
    //        [self loadImage:@1];
    //    });
    //    dispatch_async(serialQueue, ^{
    //        [self loadImage:@2];
    //    });
    //    dispatch_async(serialQueue, ^{
    //        [self loadImage:@3];
    //    });
    //
    //    dispatch_queue_t concurrentQueue = dispatch_queue_create("abcd", DISPATCH_QUEUE_CONCURRENT);//并行队列
    //
    //    dispatch_sync(concurrentQueue, ^{
    //        [self loadImage:@10];
    //    });
    //    dispatch_sync(concurrentQueue, ^{
    //        [self loadImage:@11];
    //    });
    //    dispatch_sync(concurrentQueue, ^{
    //        [self loadImage:@12];
    //    });
    //    dispatch_sync(concurrentQueue, ^{
    //        [self loadImage:@13];
    //    });
    //
    //    dispatch_async(dispatch_queue_create("abcd", DISPATCH_QUEUE_CONCURRENT), ^{
    //        [self loadImage:@14];
    //    });
    //    dispatch_async(dispatch_queue_create("abcd", DISPATCH_QUEUE_CONCURRENT), ^{
    //        [self loadImage:@15];
    //    });
    //    dispatch_async(dispatch_queue_create("abcd", DISPATCH_QUEUE_CONCURRENT), ^{
    //        [self loadImage:@16];
    //    });
    //    dispatch_async(dispatch_queue_create("abcd", DISPATCH_QUEUE_CONCURRENT), ^{
    //        [self loadImage:@17];
    //    });
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
    
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("abcd", DISPATCH_QUEUE_CONCURRENT);//并行队列
    dispatch_async(concurrentQueue, ^{
        [self loadImage:@0];
        //读取数据1
    });
    dispatch_async(concurrentQueue, ^{
        [self loadImage:@1];
        //读取数据2
    });
    dispatch_async(concurrentQueue, ^{
        [self loadImage:@2];
        //读取数据3
    });
    dispatch_async(concurrentQueue, ^{
        [self loadImage:@3];
        //读取数据4
    });
    dispatch_barrier_async(concurrentQueue, ^{
        [self loadImage:@4];
       //写入数据
    });
    dispatch_barrier_sync(concurrentQueue, ^{
        [self loadImage:@4];
        //写入数据
    });
    dispatch_async(concurrentQueue, ^{
        [self loadImage:@5];
        //读取数据5
    });
    dispatch_async(concurrentQueue, ^{
        [self loadImage:@6];
        //读取数据6
    });
    dispatch_async(concurrentQueue, ^{
        [self loadImage:@7];
        //读取数据7
    });
    dispatch_async(concurrentQueue, ^{
        [self loadImage:@8];
        //读取数据8
    });
    
    
}

-(void)loadImage:(NSNumber*)index{
    NSLog(@"%@ %@",index,[NSThread currentThread]);
    int i = [index intValue];
    sleep(2);//等待两秒
    NSData *data = [self requestData:i];
    FlyImageData *imageData = [[FlyImageData alloc] init];
    imageData.data = data;
    imageData.index = i;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateImage:imageData];
    });
    
}

-(void)updateImage:(FlyImageData*)imageData{
    UIImage *image = [UIImage imageWithData:imageData.data];
    UIImageView *imageView = _imageViews[imageData.index];
    imageView.image = image;
    //    NSLog(@"%d",imageData.index);
}

-(NSData*)requestData:(int)index{
    NSURL *url = [NSURL URLWithString:imageUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return data;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
