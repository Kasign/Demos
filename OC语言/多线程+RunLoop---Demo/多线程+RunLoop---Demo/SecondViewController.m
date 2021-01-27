//
//  SecondViewController.m
//  多线程+RunLoop---Demo
//
//  Created by Qiushan on 2021/1/27.
//  Copyright © 2021 FLY. All rights reserved.
//

#import "SecondViewController.h"

#import "FlyImageData.h"

#import "FLYOperation.h"
#import "FLYThread.h"
#import "FLYGCD.h"

@interface SecondViewController ()

@property (nonatomic, strong) FLYOperation  *  flyOperation;
@property (nonatomic, strong) FLYThread     *  flyThread;
@property (nonatomic, strong) FLYGCD        *  flyGCD;
@property (nonatomic, strong) NSMutableArray  *  imageViews;
@property (nonatomic, strong) NSMutableArray  *  threadArr;

@end


#define ROW_COUNT    7.f
#define COLUMN_COUNT 3.f
#define CELL_SPACING 10

static NSString * imageUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1599553213989&di=e87006b6f993d01aed9dd632bd41a126&imgtype=0&src=http%3A%2F%2Fa1.att.hudong.com%2F05%2F00%2F01300000194285122188000535877.jpg";

@implementation SecondViewController

- (FLYOperation *)flyOperation {
    
    if (_flyOperation == nil) {
        _flyOperation = [[FLYOperation alloc] init];
    }
    return _flyOperation;
}

- (FLYThread *)flyThread {
    
    if (_flyThread == nil) {
        _flyThread = [[FLYThread alloc] init];
    }
    return _flyThread;
}

- (FLYGCD *)flyGCD {
    
    if (_flyGCD == nil) {
        _flyGCD = [FLYGCD threadWithType:FLYThreadType_CONCURRENT];
    }
    return _flyGCD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageViews = [NSMutableArray array];
    _threadArr  = [NSMutableArray array];
    
    CGFloat rowW = (self.view.frame.size.width - 56.f - (COLUMN_COUNT - 1) * CELL_SPACING)/COLUMN_COUNT;
    CGFloat rowH = rowW * 9.f/30.f;
    for (int i = 0; i< ROW_COUNT; i++) {
        for (int j =0; j< COLUMN_COUNT; j++) {
            
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(j * rowW + (j * CELL_SPACING) + 28, 80 + i * rowH + (i * CELL_SPACING), rowW, rowH)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
            [self.view addSubview:imageView];
            [_imageViews addObject:imageView];
            
        }
    }
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [btn1 setTitle:@"加载图片" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(loadImageWithMulatiThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [btn1 setCenter:CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height - 80)];
}

- (void)loadImageWithMulatiThread {
    
    [self.flyGCD startRunLoop:@"com.fly.www"];
    NSLog(@"---------------------\n%@\n%@", self.flyGCD.runLoop, self.flyGCD.thread);
    
    int count = ROW_COUNT * COLUMN_COUNT;
    int i = 0;
    for (; i < 10; ++i) {

//        [thread addAction:^{
//            [self loadImage:[NSNumber numberWithInteger:i]];
//        }];

        [self.flyGCD asyncAddTask:^{
            [self loadImage:[NSNumber numberWithInteger:i]];
        }];
    }
    [self.flyGCD stopRunLoop];
    for (; i < count; ++i) {
        
//        [thread addAction:^{
//            [self loadImage:[NSNumber numberWithInteger:i]];
//        }];
        
        [self.flyGCD syncAddTask:^{
            [self loadImage:[NSNumber numberWithInteger:i]];
        }];
    }
    NSLog(@"Finish");
}

- (void)loadImage:(NSNumber *)index {
    
    int i = [index intValue];
    
    NSData *data = [self requestData:i];
    FlyImageData *imageData = [[FlyImageData alloc] init];//创建的目的是因为NSThread只能传一个参数，这里operation可以传多个参数，所以没必要用此对象，此处为了方便
    imageData.data = data;
    imageData.index = i;
    
    NSLog(@"当前：%d\n%@", i, [NSThread currentThread]);
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self updateImage:imageData];
    }];
}

- (void)updateImage:(FlyImageData*)imageData {
    
    UIImage * image = [UIImage imageWithData:imageData.data];
    UIImageView * imageView = _imageViews[imageData.index];
    imageView.image = image;
}

- (NSData *)requestData:(int)index {
    
    NSURL  * url  = [NSURL URLWithString:imageUrl];
    NSData * data = [NSData dataWithContentsOfURL:url];
    return data;
}


@end

