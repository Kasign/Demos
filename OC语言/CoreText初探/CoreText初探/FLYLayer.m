//
//  FLYLayer.m
//  CoreText初探
//
//  Created by Q on 2018/7/27.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "FLYLayer.h"

@implementation FLYLayer

- (void)drawInContext:(CGContextRef)ctx
{
//    [super drawInContext:ctx];
    CGMutablePathRef path=CGPathCreateMutable();
    //2.2把绘图信息添加到路径里
    CGPathMoveToPoint(path, NULL, 20, 20);
    CGPathAddLineToPoint(path, NULL, 200, 100);
    //2.3把路径添加到上下文中
    //把绘制直线的绘图信息保存到图形上下文中
    CGContextAddPath(ctx, path); //仍需把path加入ctx里
    //3.渲染
    CGContextStrokePath(ctx);
    //4.释放前面创建的两条路径
    CGPathRelease(path);
}

@end
