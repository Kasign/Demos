//
//  ViewController.m
//  多线程Demo1
//
//  Created by walg on 2017/3/9.
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
    NSMutableArray * _imageViews;
    NSMutableArray * _threads;
}

@end

static NSString *imageUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1599553213989&di=e87006b6f993d01aed9dd632bd41a126&imgtype=0&src=http%3A%2F%2Fa1.att.hudong.com%2F05%2F00%2F01300000194285122188000535877.jpg";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageViews = [NSMutableArray array];
    _threads = [NSMutableArray array];
    
    for (int i = 0; i<ROW_COUNT; i++) {
        for (int j =0; j<COLUMN_COUNT; j++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(j*ROW_WIDTH+(j*CELL_SPACING)+28, 80+i*ROW_HEIGHT+(i*CELL_SPACING), ROW_WIDTH, ROW_HEIGHT)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
            [self.view addSubview:imageView];
            [_imageViews addObject:imageView];
        }
    }
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(60, 580, 100, 30)];
    [btn1 setTitle:@"加载图片" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(loadImageWithMulatiThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(160, 580, 100, 30)];
    [btn2 setTitle:@"取消加载" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(stopThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}

- (void)loadImageWithMulatiThread {
    
    [_threads removeAllObjects];
    
    int count = ROW_COUNT * COLUMN_COUNT;
    
    for (int i= 0; i < count; ++i) {
        NSThread * thread = [[NSThread alloc] initWithTarget:self selector:@selector(loadImage:) object:[NSNumber numberWithInt:i]];
        
        thread.name = [NSString stringWithFormat:@"myThread%d", i];
        
        thread.threadPriority = i * 1.0 / count;;//线程优先级，范围 0.0 ~ 1.0，1.0为最高
        
        [_threads addObject:thread];
    }
    for (NSThread * thread in _threads) {
        
        [thread start];//开始线程
    }
}

- (void)loadImage:(NSNumber *)index{
    
    int i = [index intValue];
    
    NSData * data = [self requestData:i];
    
    NSThread * currentThread = [NSThread currentThread];
    if (currentThread.isCancelled) {
        [NSThread exit];//退出当前线程
    }
    
    NSLog(@"current thread:%d \n %@", i, currentThread);//打印
    
    FlyImageData *imageData = [[FlyImageData alloc] init];
    imageData.data = data;
    imageData.index = i;
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:imageData waitUntilDone:YES];//在主线程更新视图
    
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    
    //开启runloop
    [[NSRunLoop currentRunLoop] run];
}

- (void)updateImage:(FlyImageData*)imageData {
    
    UIImage *image = [UIImage imageWithData:imageData.data];
    UIImageView *imageView = _imageViews[imageData.index];
    imageView.image = image;
}

- (NSData *)requestData:(int)index {
    
    sleep(0.3);
    NSURL * url   = [NSURL URLWithString:imageUrl];
    NSData * data = [NSData dataWithContentsOfURL:url];
    return data;
}

- (void)stopThread {
    
    for (NSThread *thread in _threads) {
        if (!thread.isFinished) {//如果线程没有完成
            [thread cancel];//取消线程
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
