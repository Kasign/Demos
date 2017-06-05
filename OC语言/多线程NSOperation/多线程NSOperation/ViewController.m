//
//  ViewController.m
//  多线程NSOperation
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
    
    int count =ROW_COUNT*COLUMN_COUNT;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 5;//控制最大线程数
    
    for (int i= 0; i < count; ++i) {
        /*
        // 方法一 ：用NSInvocationOperation
         
         NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(loadImage:) object:[NSNumber numberWithInteger:i]];
        [queue addOperation:invocationOperation];
         
         */
        
//         方法二 ：用NSBlockOperation
        
        NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
            [self loadImage:[NSNumber numberWithInteger:i]];
        }];
        [queue addOperation:blockOperation];
    }
    
    /*
    //线程依赖：A依赖B，只有等B执行完了才执行A。（避免循环依赖，否则不会执行）
    NSBlockOperation *firstOperation = [NSBlockOperation blockOperationWithBlock:^{
     
    }];
    NSBlockOperation *lastOperation = [NSBlockOperation blockOperationWithBlock:^{
     
    }];
    [firstOperation addDependency:lastOperation];
    */
}

-(void)loadImage:(NSNumber*)index{
    
    int i = [index intValue];
    
    NSData *data = [self requestData:i];
    FlyImageData *imageData = [[FlyImageData alloc] init];//创建的目的是因为NSThread只能传一个参数，这里operation可以传多个参数，所以没必要用此对象，此处为了方便
    imageData.data = data;
    imageData.index = i;
    
    [[NSOperationQueue mainQueue ] addOperationWithBlock:^{
        
        [self updateImage:imageData];
        
    }];
    
}

-(void)updateImage:(FlyImageData*)imageData{
    UIImage *image = [UIImage imageWithData:imageData.data];
    UIImageView *imageView = _imageViews[imageData.index];
    imageView.image = image;
}

-(NSData*)requestData:(int)index{
    
    NSURL *url = [NSURL URLWithString:imageUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return data;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
