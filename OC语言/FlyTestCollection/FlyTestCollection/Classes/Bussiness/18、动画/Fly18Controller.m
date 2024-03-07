//
//  Fly18Controller.m
//  FlyTestCollection
//
//  Created by Walg on 2024/3/7.
//

#import "Fly18Controller.h"

@interface Fly18Controller ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) CALayer *layer;

@end

@implementation Fly18Controller

+ (NSString *)functionName {
    
    return @"动画";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = touches.anyObject;
}

- (void)test1 {
    
    UIImage *backImage = [UIImage imageNamed:@"4.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backImage];
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"5.png"]];
    _imageView.bounds = CGRectMake(0, 0, 60, 80);
    _imageView.center = CGPointMake(50, 150);
    [self.view addSubview:_imageView];
}

- (void)startAnimation1:(UITouch *)touch {
    
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
            self.imageView.center=CGPointMake(80.0, 220.0);
        }];
        
        //第三个关键帧 从0.5*0.5秒开始，也就是5.0*0.25 = 1.25秒；
        [UIView addKeyframeWithRelativeStartTime:0.33 relativeDuration:0.33 animations:^{
            self.imageView.center=CGPointMake(45.0,300.0);
        }];
        
           //第四个关键帧 ,从0.75*5.0秒开始，也就是5.0*0.25 = 1.25秒；
        [UIView addKeyframeWithRelativeStartTime:0.67 relativeDuration:0.33 animations:^{
            self.imageView.center=CGPointMake(85.0,400.0);
        }];
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - test2
- (void)test2 {
    
    UIImage *a = [UIImage imageNamed:@"a.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:a];
    
    _layer = [CALayer layer];
    _layer.bounds = CGRectMake(0, 0, 10, 20);
    _layer.position = CGPointMake(50, 150);
    _layer.contents =(id)[UIImage imageNamed:@"ye.png"].CGImage;
    [self.view.layer addSublayer:_layer];
}

- (void)startAnimation2:(UITouch *)touch {
    
    CAAnimation *animation = [_layer animationForKey:@"KCBasicAnimation_Translation"];
    if (animation) {
        if (_layer.speed == 0) {
            [self animationResume];
        } else {
            [self animationPause];
        }
    } else {
        CGPoint location = [touch locationInView:self.view];
        [self translationAnimation:location];
        [self rotationAnimation];
    }
}

- (void)translationAnimation:(CGPoint)location {
    
//    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
//    basicAnimation.delegate = self;
////    basicAnimation.fromValue = [NSNumber numberWithInt:50];
////    basicAnimation.repeatCount = HUGE_VALF;
//    basicAnimation.toValue = [NSValue valueWithCGPoint:location];
//    basicAnimation.duration = 5.0;
//    [basicAnimation setValue:[NSValue valueWithCGPoint:location] forKey:@"KCBasicAnimationLocation"];
//    [_layer addAnimation:basicAnimation forKey:@"KCBasicAnimation_Translation"];
    
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyAnimation.duration = 8.0;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(_layer.position.x, _layer.position.y)];
    [path addCurveToPoint:CGPointMake(255, 600) controlPoint1:CGPointMake(160, 280) controlPoint2:CGPointMake(-100, 400)];
    
//    [path stroke];//无用
    keyAnimation.path = [path CGPath];
    
    [_layer addAnimation:keyAnimation forKey:@"KCKeyframeAnimation_Position"];
    
}

- (void)rotationAnimation {
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAnimation.toValue = [NSNumber numberWithInt:M_PI_2*3];
    basicAnimation.duration = 4.0;
    basicAnimation.autoreverses = YES;
    [_layer addAnimation:basicAnimation forKey:@"KCBasicAnimation_Rotation"];
}


- (void)animationDidStart:(CAAnimation *)anim{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    NSLog(@"animation(%@) stop.\r_layer.frame=%@",anim,NSStringFromCGRect(_layer.frame));
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    _layer.position=[[anim valueForKey:@"KCBasicAnimationLocation"] CGPointValue];
    
    [CATransaction commit];
}

- (void)animationResume {
    
    CFTimeInterval beginTime = CACurrentMediaTime() - _layer.timeOffset;
    _layer.timeOffset = 0;
    _layer.beginTime = beginTime;
    _layer.speed = 1.0;
}

- (void)animationPause {
    
    CFTimeInterval interval = [_layer convertTime:CACurrentMediaTime() fromLayer:nil];
    [_layer setTimeOffset:interval];
    _layer.speed = 0;
}

@end
