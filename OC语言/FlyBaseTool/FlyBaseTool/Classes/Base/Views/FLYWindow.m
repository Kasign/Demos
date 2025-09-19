//
//  FLYWindow.m
//  FlyBaseTool
//
//  Created by Walg on 2025/9/19.
//

#import "FLYWindow.h"

@implementation FLYWindow

- (void)setRootViewController:(UIViewController *)rootViewController {
    FLYFUNLog(@"");
    [super setRootViewController:rootViewController];
    FLYFUNLog(@"");
}

- (void)setFrame:(CGRect)frame
{
    FLYFUNLog(@"");
    [super setFrame:frame];
    FLYFUNLog(@"");
}

- (void)addSubview:(UIView *)view
{
    FLYFUNLog(@" sub:%@", view);
    [super addSubview:view];
    FLYFUNLog(@"");
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    FLYFUNLog(@"");
    [super willMoveToSuperview:newSuperview];
    FLYFUNLog(@"%@ willMoveToSuperview %@",self, newSuperview);
}

- (void)didMoveToSuperview
{
    FLYFUNLog(@"");
    [super didMoveToSuperview];
    FLYFUNLog(@"");
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    FLYFUNLog(@"");
    [super willMoveToWindow:newWindow];
    FLYFUNLog(@"");
}

- (void)didMoveToWindow {
    
    FLYFUNLog(@"");
    [super didMoveToWindow];
    FLYFUNLog(@"");
}

- (void)setNeedsLayout
{
    FLYFUNLog(@"");
    [super setNeedsLayout];
    FLYFUNLog(@"");
}

- (void)layoutIfNeeded
{
    FLYFUNLog(@"");
    [super layoutIfNeeded];
    FLYFUNLog(@"");
}

- (void)layoutSubviews
{
    FLYFUNLog(@"");
    [super layoutSubviews];
    FLYFUNLog(@"");
}

- (NSString *)description {
    
    return [self debugDescription];
}

- (NSString *)debugDescription
{
    return FlyStringFormat(@"<%@ %p>", [self class], self);
}

@end
