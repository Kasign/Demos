//
//  FlyFifthController.m
//  算法+链表
//
//  Created by mx-QS on 2019/9/10.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "FlyFifthController.h"


@interface FlyFifthController ()

@end

@implementation FlyFifthController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewAndView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //    [self drawLine];
}


- (void)drawLine {
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 0, 1)];
    [line setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:line];
    
    //    [UIView beginAnimations:@"frame" context:nil];
    //    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //    [UIView setAnimationDuration:8];
    //
    //    [line setFrame:CGRectMake(100, 100, 100, 1)];
    //
    //    [UIView commitAnimations];
    //
    [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:2 initialSpringVelocity:2 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [line setFrame:CGRectMake(100, 100, 100, 1)];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)viewAndView
{
//    CGFloat startX = 100;
//    CGFloat startY = 100;
//    CGFloat width  = 100;
//    CGFloat height = 100;
    
    UIView * aView = [[UIView alloc] init];
    UIView * bView = [[UIView alloc] init];
    
//    aView.frame = CGRectMake(100, 100, 100, 100);
//    aView.transform = CGAffineTransformMakeScale(2, 2);
//    bView.frame = CGRectMake(0, 0, 50, 50);
    
    [self.view addSubview:aView];
    [aView addSubview:bView];
    
//    FLYLog(@"\naFrame-> %@\naBound-> %@\naCenter-> %@\n\nbFrame-> %@\nbBound-> %@\nbCenter-> %@", NSStringFromCGRect(aView.frame), NSStringFromCGRect(aView.bounds), NSStringFromCGPoint(aView.center), NSStringFromCGRect(bView.frame), NSStringFromCGRect(bView.bounds), NSStringFromCGPoint(bView.center));
    
    [aView setBackgroundColor:[UIColor redColor]];
    [bView setBackgroundColor:[UIColor purpleColor]];
    
    aView.layer.anchorPoint = CGPointMake(0, 0);
    
    aView.frame = CGRectMake(100, 100, 100, 100);
    aView.transform = CGAffineTransformMakeScale(2, 2);
    bView.frame = CGRectMake(0, 0, 50, 50);
    
    FLYLog(@"\naFrame-> %@\naBound-> %@\naCenter-> %@\n\nbFrame-> %@\nbBound-> %@\nbCenter-> %@", NSStringFromCGRect(aView.frame), NSStringFromCGRect(aView.bounds), NSStringFromCGPoint(aView.center), NSStringFromCGRect(bView.frame), NSStringFromCGRect(bView.bounds), NSStringFromCGPoint(bView.center));
    
    UIView * cView = [[UIView alloc] initWithFrame:CGRectMake(100, 0, 1, 95)];
    UIView * dView = [[UIView alloc] initWithFrame:CGRectMake(200, 0, 1, 100)];
    [cView setBackgroundColor:[UIColor blackColor]];
    [dView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:cView];
    [self.view addSubview:dView];
}

@end
