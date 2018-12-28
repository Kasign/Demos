//
//  FlyCollectionView.m
//  UICollectionView+Runtime
//
//  Created by 66-admin-qs. on 2018/12/26.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "FlyCollectionView.h"
#import "Header.h"

@implementation FlyCollectionView


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (touches.count == 1) {
        UITouch * touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:self];
        //        NSIndexPath * currentIndexPath = [self indexPathForCell:touch.view];
        //        [self.delegate flyCollectionView:self didSelectItemAtIndexPath:currentIndexPath];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
//    FlyLog(@"touchesMoved %@",touches);
    if (touches.count == 1) {
        UITouch * touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:self];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
//    FlyLog(@"touchesEnded %@",touches);
    if (touches.count == 1) {
        UITouch * touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:self];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
//    FlyLog(@"touchesCancelled %@",touches);
    if (touches.count == 1) {
        UITouch * touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:self];
    }
}


@end

@implementation UICollectionReusableView (x)

//- (void)setFrame:(CGRect)frame
//{
//    FlyLog(@"-->>重设了frame： %@ \n-->>%@",self,[NSValue valueWithCGRect:frame]);
//    [self logIndexPath];
//    [super setFrame:frame];
//}
//
//- (void)willMoveToSuperview:(UIView *)newSuperview
//{
//    FlyLog(@"-->>willMoveToSuperview%@\n-->>%@",self,newSuperview);
//    [self logIndexPath];
//    [super willMoveToSuperview:newSuperview];
//}
//
//- (void)didMoveToSuperview
//{
//    FlyLog(@"-->>didMoveToSuperview%@\n -->> %@",self,self.superview);
//    [self logIndexPath];
//    [super didMoveToSuperview];
//    [self logIndexPath];
//}
//
//- (void)removeFromSuperview
//{
//    FlyLog(@"-->>移除了%@",self);
//    [self logIndexPath];
//    [super removeFromSuperview];
//}
//
//- (void)logIndexPath
//{
//    UICollectionView * superView = (UICollectionView *)self.superview;
//    if ([superView isKindOfClass:[UICollectionView class]]) {
//        NSIndexPath * indexPath = [superView indexPathForCell:self];
//        if (indexPath) {
//            FlyLog(@"-->>logIndexPath: %ld - %ld",indexPath.section,indexPath.row);
//        }
//    } else {
//        FlyLog(@"-->>logIndexPath: %@",superView);
//    }
//}

@end
