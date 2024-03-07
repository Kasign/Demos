//
//  FlyBaseView.m
//  算法+链表
//
//  Created by Walg on 2020/10/24.
//  Copyright © 2020 Fly. All rights reserved.
//

#import "FlyBaseView.h"

@implementation FlyBaseView

- (void)setFrame:(CGRect)frame
{
    [self fly_willChangeFrame];
    [super setFrame:frame];
    [self fly_didChangeFrame];
}

- (void)addSubview:(UIView *)view
{
    [self fly_willAddSubview:view];
    [super addSubview:view];
    [self fly_didAddSubview:view];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    FLYAccurateLog(@"%@ willMoveToSuperview %@",self, newSuperview);
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    FLYAccurateLog(@"%@ didMoveToSuperview", self);
}

- (void)setNeedsLayout
{
    [super setNeedsLayout];
    FLYAccurateLog(@"%@ %s", self, __func__);
}

- (void)layoutIfNeeded
{
    [super layoutIfNeeded];
    FLYAccurateLog(@"%@ %s", self, __func__);
}

- (void)fly_willAddSubview:(UIView *)subview
{
    FLYAccurateLog(@"%@ willAddSubview %@", self, subview);
}

- (void)fly_didAddSubview:(UIView *)subview
{
    FLYAccurateLog(@"%@ fly_didAddSubview %@", self, subview);
}

- (void)fly_willChangeFrame
{
    FLYAccurateLog(@"%@ %s", self, __func__);
}

- (void)fly_didChangeFrame
{
    FLYAccurateLog(@"%@ %s", self, __func__);
}

- (void)layoutSubviews
{    
    [super layoutSubviews];
    FLYAccurateLog(@"%@ layoutSubviews", self);
}

- (NSString *)description {
    
    return [self debugDescription];
}

- (NSString *)debugDescription
{
    return FlyStringFormat(@"<%@ %p>", [self class], self);
}

@end
