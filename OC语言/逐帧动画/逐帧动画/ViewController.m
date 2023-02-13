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
    _layer.backgroundColor = [UIColor redColor].CGColor;
    _layer.bounds = CGRectMake(0, 0, 87, 32);
    _layer.position = CGPointMake(160, 284);
    [self.view.layer addSublayer:_layer];
    
//    CADisplayLink *disPlayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(step)];
//
//    [disPlayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)animation {
    
//    [_layer removeAllAnimations];
    
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    keyAnimation.duration = 3;
//    keyAnimation.values = @[@1, @0.8, @0.6, @1.2, @1.1, @1];
//    keyAnimation.keyTimes = @[@0, @0.1, @0.3, @0.4, @0.6, @0.8, @1];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addCurveToPoint:CGPointMake(0, 0) controlPoint1:CGPointMake(0, 1.5) controlPoint2:CGPointMake(0, 0.8)];
//    [path addQuadCurveToPoint:CGPointMake(0, 1.5) controlPoint:CGPointMake(0, 0.8)];
    keyAnimation.path = [path CGPath];
    [_layer addAnimation:keyAnimation forKey:@"scale_animation"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self animation];
}

//-(void)step{
//    static int s = 0;//这里的s只初始化一次
//    if (++s%10 == 0) {
//        NSLog(@"nei : %d",s);//这里放图片切换的代码
//    }
//    NSLog(@"wai : %d",s);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
