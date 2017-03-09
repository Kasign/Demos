//
//  ViewController.m
//  逐帧动画
//
//  Created by walg on 2017/3/6.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) CALayer *layer;
@property (nonatomic, strong) NSMutableArray *_images;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _layer = [CALayer layer];
    _layer.bounds = CGRectMake(0, 0, 87, 32);
    _layer.position = CGPointMake(160, 284);
    [self.view.layer addSublayer:_layer];
    
    CADisplayLink *disPlayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(step)];

    [disPlayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

-(void)step{
    static int s = 0;//这里的s只初始化一次
    if (++s%10 == 0) {
        NSLog(@"nei : %d",s);//这里放图片切换的代码
    }
    NSLog(@"wai : %d",s);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
