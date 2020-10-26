//
//  FlyFifthController.m
//  算法+链表
//
//  Created by mx-QS on 2019/9/10.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "FlyFifthController.h"

@interface FlyFifthController ()

@property (nonatomic, strong) FlyBaseView   *   lineView;
@property (nonatomic, strong) CADisplayLink *   displayLink;

@end

@implementation FlyFifthController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateFrames)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [self viewAndView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self testLayoutSubviewsMethod];
    });
}

- (void)updateFrames {
    
    FLYAccurateLog(@"%s", __func__);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self drawLine];
}

- (void)drawLine
{
    [_lineView removeFromSuperview];
    _lineView = [[FlyBaseView alloc] initWithFrame:CGRectMake(100, 500, 0, 1)];
    [_lineView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:_lineView];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:2 initialSpringVelocity:2 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [weakSelf.lineView setFrame:CGRectMake(weakSelf.lineView.frame.origin.x, weakSelf.lineView.frame.origin.y, 100, weakSelf.lineView.frame.size.height)];
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
    
    FLYClearLog(@"======================");
}

/**
 Allows you to perform layout before the drawing cycle happens. -layoutIfNeeded forces layout early
 
 概要
 如果布局更新正在等待中，请立即布置子视图。
 -（void）layoutIfNeeded;
 使用此方法可以强制视图立即更新其布局。当使用“自动布局”时，布局引擎会根据需要更新视图的位置，以满足约束的更改。使用接收消息的视图作为根视图，此方法从根开始布置视图子树。如果没有任何布局更新待处理，则此方法将退出，而不修改布局或调用任何与布局相关的回调。

 概要
 使接收器的当前布局无效，并在下一个更新周期内触发布局更新。
 -（void）setNeedsLayout;
 要调整视图子视图的布局时，请在应用程序的主线程上调用此方法。此方法记录请求并立即返回。因为此方法不会强制立即更新，而是等待下一个更新周期，所以您可以使用它在更新任何视图之前使多个视图的布局无效。此行为使您可以将所有布局更新合并到一个更新周期，这通常可以提高性能。
 */
- (void)testLayoutSubviewsMethod
{
    FLYClearLog(@"============TEST==========");

    FlyBaseView * view1 = [[FlyBaseView alloc] init];
//    [view1 setFrame:CGRectMake(1, 1, 1, 1)];
//    [self.view addSubview:view1];
//
    FlyBaseView * view2 = [[FlyBaseView alloc] init];
    [view2 setFrame:CGRectMake(1, 1, 1, 1)];
    [view1 addSubview:view2];
    
    FLYClearLog(@"============TEST==========");
    
    float time = 1.0;
    float dis  = 1.0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        FLYClearLog(@"============>0<==========");
        [self.view addSubview:view1];
        FLYClearLog(@"============>0<==========");
    });
    
    time += dis;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        FLYClearLog(@"============>1<==========");
        [view1 setNeedsLayout];
        [view1 layoutIfNeeded];
        FLYClearLog(@"============>1<==========");
    });
    
    time += dis;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        FLYClearLog(@"============>2<==========");
        [view1 layoutIfNeeded];
        [view1 setNeedsLayout];
        FLYClearLog(@"============>2<==========");
    });
    
    time += dis;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        FLYClearLog(@"============>3<==========");
        [view1 setNeedsLayout];
        FLYClearLog(@"============>3<==========");
    });
    
    time += dis;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        FLYClearLog(@"============>4<==========");
        [view1 setFrame:CGRectMake(1, 1, 4, 4)];
        [view1 layoutIfNeeded];
        FLYClearLog(@"============>4<==========");
    });
    
    time += dis;
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        FLYClearLog(@"============>5<==========");
        [weakSelf.displayLink setPaused:YES];
        FLYClearLog(@"============>5<==========");
    });
}

@end
