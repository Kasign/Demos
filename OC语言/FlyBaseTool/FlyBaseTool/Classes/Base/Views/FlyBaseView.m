//
//  FlyBaseView.m
//  算法+链表
//
//  Created by Walg on 2020/10/24.
//  Copyright © 2020 Fly. All rights reserved.
//

#import "FlyBaseView.h"

#define LOGView FLYFUNLog(@"view:%@ superview:%@ view-alpha:%f view-Hidden:%d", self, self.superview, self.alpha, self.isHidden)

@implementation FlyBaseView

- (void)setFrame:(CGRect)frame
{
    LOGView;
    [self fly_willChangeFrame];
    [super setFrame:frame];
    [self fly_didChangeFrame];
    LOGView;
}

- (void)addSubview:(UIView *)view
{
    LOGView;
    [self fly_willAddSubview:view];
    [super addSubview:view];
    [self fly_didAddSubview:view];
    FLYFUNLog(@"sub:%p", view);
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    LOGView;
    [super willMoveToSuperview:newSuperview];
    FLYFUNLog(@"%@ willMoveToSuperview <%@ %p>", self, newSuperview.class, newSuperview);
}

- (void)didMoveToSuperview
{
    LOGView;
    [super didMoveToSuperview];
    LOGView;
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    LOGView;
    [super willMoveToWindow:newWindow];
    LOGView;
}

- (void)didMoveToWindow {
    
    LOGView;
    [super didMoveToWindow];
    LOGView;
}

- (void)setNeedsLayout
{
    LOGView;
    [super setNeedsLayout];
    LOGView;
}

- (void)layoutIfNeeded
{
    LOGView;
    [super layoutIfNeeded];
    LOGView;
}

- (void)layoutSubviews
{
    LOGView;
    [super layoutSubviews];
    LOGView;
}

- (void)fly_willAddSubview:(UIView *)subview
{
//    FLYNSLog(@"%@ willAddSubview %@", self, subview);
}

- (void)fly_didAddSubview:(UIView *)subview
{
//    FLYNSLog(@"%@ fly_didAddSubview %@", self, subview);
}

- (void)fly_willChangeFrame
{
//    FLYNSLog(@"%@ %s", self, __func__);
}

- (void)fly_didChangeFrame
{
//    FLYNSLog(@"%@ %s", self, __func__);
}

- (NSString *)description {
    
    return [self debugDescription];
}

- (NSString *)debugDescription
{
    return FlyStringFormat(@"<%@ %p>", [self class], self);
}

@end
