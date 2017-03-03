//
//  ViewController.m
//  动画Demos
//
//  Created by walg on 2017/3/3.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<CAAnimationDelegate>
@property (nonatomic, strong) CALayer *layer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *a = [UIImage imageNamed:@"a.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:a];
    
    _layer = [CALayer layer];
    _layer.bounds = CGRectMake(0, 0, 10, 20);
    _layer.position = CGPointMake(50, 150);
    _layer.contents =(id)[UIImage imageNamed:@"ye.png"].CGImage;
    [self.view.layer addSublayer:_layer];
}

-(void)translationAnimation:(CGPoint)location{
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
    keyAnimation.path =[path CGPath];
    
    [_layer addAnimation:keyAnimation forKey:@"KCKeyframeAnimation_Position"];
    
}

-(void)rotationAnimation{
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAnimation.toValue = [NSNumber numberWithInt:M_PI_2*3];
    basicAnimation.duration = 4.0;
    basicAnimation.autoreverses = YES;
    [_layer addAnimation:basicAnimation forKey:@"KCBasicAnimation_Rotation"];
}


-(void)animationDidStart:(CAAnimation *)anim{
    
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"animation(%@) stop.\r_layer.frame=%@",anim,NSStringFromCGRect(_layer.frame));
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    _layer.position=[[anim valueForKey:@"KCBasicAnimationLocation"] CGPointValue];
    
    [CATransaction commit];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
   
    
    CAAnimation *animation = [_layer animationForKey:@"KCBasicAnimation_Translation"];
    if (animation) {
        if (_layer.speed == 0) {
            [self animationResume];
        }else{
            [self animationPause];
        }
        
    }else{
        CGPoint location = [touch locationInView:self.view];
        [self translationAnimation:location];
        [self rotationAnimation];
    }
}

-(void)animationResume{
    CFTimeInterval beginTime = CACurrentMediaTime() - _layer.timeOffset;
    _layer.timeOffset = 0;
    _layer.beginTime = beginTime;
    _layer.speed = 1.0;
}

-(void)animationPause{
    
    CFTimeInterval interval = [_layer convertTime:CACurrentMediaTime() fromLayer:nil];
    [_layer setTimeOffset:interval];
    _layer.speed = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
