//
//  FlyDrawView.m
//  AOP切面编程
//
//  Created by mx-QS on 2019/7/19.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "FlyDrawView.h"

@implementation FlyDrawView

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    CGFloat lineWidth = 10;
    
    UIColor * lineColor = [UIColor blueColor];
    
    CGPoint startPoint = CGPointMake(self.frame.size.width * 0.2, self.frame.size.height * 0.5);
    CGPoint endPoint   = CGPointMake(self.frame.size.width * 0.7, self.frame.size.height * 0.5);
    
    
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    [lineColor setFill];

    CGFloat radius = lineWidth * 0.5;
    if (startPoint.x == self.frame.size.width * 0.2) {
        [path addArcWithCenter:CGPointMake(startPoint.x + radius, startPoint.y) radius:radius startAngle:0.5 * M_PI endAngle:1.5 * M_PI clockwise:YES];
        [path addLineToPoint:CGPointMake(radius, startPoint.y - radius)];
    } else {
        [path moveToPoint:CGPointMake(startPoint.x, startPoint.y - radius)];
    }
    
    if (endPoint.x == self.frame.size.width * 0.8) {
        [path addLineToPoint:CGPointMake(endPoint.x - radius, startPoint.y - radius)];
        [path addArcWithCenter:CGPointMake(endPoint.x - radius, endPoint.y) radius:radius startAngle:0.5 * M_PI endAngle:1.5 * M_PI clockwise:NO];
        [path addLineToPoint:CGPointMake(endPoint.x - radius, endPoint.y + radius)];
    } else {
        [path addLineToPoint:CGPointMake(endPoint.x, endPoint.y - radius)];
        [path addLineToPoint:CGPointMake(endPoint.x, endPoint.y + radius)];
    }
    
    if (startPoint.x == self.frame.size.width * 0.2) {
        [path addLineToPoint:CGPointMake(startPoint.x + radius, startPoint.y + radius)];
    } else {
        [path addLineToPoint:CGPointMake(startPoint.x, startPoint.y + radius)];
    }
    
    [path fill];
    [path addClip];
}

@end

@implementation FlyDrawLayer

- (void)drawInContext:(CGContextRef)ctx {
    
//    [super drawInContext:ctx];
    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    [[UIColor greenColor] set];
//    CGContextSaveGState(ctx);
//    [[UIColor brownColor] set];
//    CGContextFillRect(ctx, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
//    CGContextRestoreGState(ctx);
//    CGContextFillRect(ctx, CGRectMake(self.frame.size.width / 2 - 25, self.frame.size.height / 2 - 25, 50, 50));
    
//    CGMutablePathRef path = CGPathCreateMutable();
//    //2.2把绘图信息添加到路径里
//    [[UIColor blueColor] set];
//    CGPathMoveToPoint(path, NULL, 20, 20);
//    CGPathAddLineToPoint(path, NULL, 200, 300);
//    //2.3把路径添加到上下文中
//    //把绘制直线的绘图信息保存到图形上下文中
//    CGContextAddPath(ctx, path); //仍需把path加入ctx里
//    //3.渲染
//    CGContextStrokePath(ctx);

    
//    UIGraphicsPushContext(ctx);
//
//    //创建圆形框UIBezierPath:
//    UIBezierPath *pickingFieldPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(20, 100, 100, 100)];
//    //创建外围大方框UIBezierPath:
//    UIBezierPath *bezierPathRect = [UIBezierPath bezierPathWithRect:CGRectMake(20, 80, 80, 80)];
//    //将圆形框path添加到大方框path上去，以便下面用奇偶填充法则进行区域填充：
//    [bezierPathRect appendPath:pickingFieldPath];
//    [[[UIColor blackColor] colorWithAlphaComponent:0.5] set];
//    //填充使用奇偶法则
//    bezierPathRect.usesEvenOddFillRule = YES;
//    [bezierPathRect fill];
//
//    [[UIColor blueColor] set];
//    [pickingFieldPath setLineWidth:2];
//    [pickingFieldPath stroke];
//    UIGraphicsPopContext();
    
    UIGraphicsPushContext(ctx);
    CGFloat lineWidth = 10;

    UIColor * lineColor = [UIColor blueColor];

    CGPoint startPoint  = CGPointMake(self.frame.size.width * 0.2, self.frame.size.height * 0.5);
    CGPoint endPoint    = CGPointMake(self.frame.size.width * 0.8, self.frame.size.height * 0.5);

    UIBezierPath * path = [UIBezierPath bezierPath];
    [lineColor setFill];

    CGFloat radius = lineWidth * 0.5;
    if (startPoint.x == self.frame.size.width * 0.2) {
        [path addArcWithCenter:CGPointMake(startPoint.x + radius, startPoint.y) radius:radius startAngle:0.5 * M_PI endAngle:1.5 * M_PI clockwise:YES];
        [path addLineToPoint:CGPointMake(radius, startPoint.y - radius)];
    } else {
        [path moveToPoint:CGPointMake(startPoint.x, startPoint.y - radius)];
    }

    if (endPoint.x == self.frame.size.width * 0.8) {
        [path addLineToPoint:CGPointMake(endPoint.x - radius, startPoint.y - radius)];
        [path addArcWithCenter:CGPointMake(endPoint.x - radius, endPoint.y) radius:radius startAngle:0.5 * M_PI endAngle:1.5 * M_PI clockwise:NO];
        [path addLineToPoint:CGPointMake(endPoint.x - radius, endPoint.y + radius)];
    } else {
        [path addLineToPoint:CGPointMake(endPoint.x, endPoint.y - radius)];
        [path addLineToPoint:CGPointMake(endPoint.x, endPoint.y + radius)];
    }

    if (startPoint.x == self.frame.size.width * 0.2) {
        [path addLineToPoint:CGPointMake(startPoint.x + radius, startPoint.y + radius)];
    } else {
        [path addLineToPoint:CGPointMake(startPoint.x, startPoint.y + radius)];
    }

    [path fill];
    [path addClip];
    UIGraphicsPopContext();
}

@end
