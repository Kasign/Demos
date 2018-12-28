//
//  FlyCollectionView.m
//  UICollectionView+Runtime
//
//  Created by 66-admin-qs. on 2018/12/26.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "FlyCollectionView.h"

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
