//
//  ViewController.m
//  弹性动画
//
//  Created by walg on 2017/3/6.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *backImage = [UIImage imageNamed:@"4.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backImage];
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"5.png"]];
    _imageView.bounds = CGRectMake(0, 0, 60, 80);
    _imageView.center = CGPointMake(50, 150);
    [self.view addSubview:_imageView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInView:self.view];
    //方法1：block 方式
    //    //基本动画  结束后不会回到初始位置
    //    [UIView animateWithDuration:5.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
    //        _imageView.center = location;
    //    } completion:^(BOOL finished) {
    //
    //    }];
    
    //方法2 ：静态方法   明显优于第一种方法
    //
    //    [UIView beginAnimations:@"KCBasicAnimation" context:nil];
    //    [UIView setAnimationDuration:5.0];
    ////    [UIView setAnimationDelay:1.0];
    ////    [UIView setAnimationRepeatAutoreverses:NO];
    ////    [UIView setAnimationRepeatCount:10.0];
    ////    [UIView setAnimationWillStartSelector:@selector(null)];
    ////    [UIView setAnimationDidStopSelector:@selector(null)];
    //
    //    _imageView.center = location;
    //    [UIView commitAnimations];
    
    
    /**
     弹簧动画效果
     damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
     velocity:弹性复位的速度，越大越快
     */
    //    [UIView animateWithDuration:5.0 delay:0 usingSpringWithDamping:0.1 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveLinear animations:^{
    //        _imageView.center = location;
    //    } completion:^(BOOL finished) {
    //
    //
    //    }];
    
    
    
    /**
     关键帧动画
     */
    [UIView animateKeyframesWithDuration:5.0 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        //第二个关键帧 （第一个关键帧是开始位置） ：从0秒开始持续50%的时间，也就是5.0*0.5 = 2.5秒；
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.33 animations:^{
            _imageView.center=CGPointMake(80.0, 220.0);
        }];
        
        //第三个关键帧 从0.5*0.5秒开始，也就是5.0*0.25 = 1.25秒；
        [UIView addKeyframeWithRelativeStartTime:0.33 relativeDuration:0.33 animations:^{
            _imageView.center=CGPointMake(45.0,300.0);
        }];
        
           //第四个关键帧 ,从0.75*5.0秒开始，也就是5.0*0.25 = 1.25秒；
        [UIView addKeyframeWithRelativeStartTime:0.67 relativeDuration:0.33 animations:^{
            _imageView.center=CGPointMake(85.0,400.0);
        }];
        
        
    } completion:^(BOOL finished) {
        
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
