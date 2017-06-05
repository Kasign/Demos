//
//  ViewController.m
//  贝塞尔曲线
//
//  Created by walg on 2017/3/2.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MyView *view = [[MyView alloc]initWithFrame:self.view.bounds];
    view.backgroundColor= [UIColor whiteColor];
    [self.view addSubview:view];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

@implementation MyView
-(void)drawRect:(CGRect)rect{
    UIBezierPath *mPath = [UIBezierPath bezierPath];
    [mPath moveToPoint:CGPointMake(100, 100)];
    [mPath addLineToPoint:CGPointMake(100, 300)];
    [mPath addLineToPoint:CGPointMake(300, 400)];
    
    [mPath closePath];
    
    UIColor *greenColor = [UIColor greenColor];          //设置颜色
    [greenColor set];                                    //填充颜色
    [mPath fill];                                       //贝塞尔线进行填充
    
    UIColor *redColor = [UIColor redColor];               //设置红色画笔线
    [redColor set];                                       //填充颜色
    [mPath stroke];                                     //贝塞尔线进行画笔填充

    //创建一个椭圆的贝塞尔曲线 半径相等 就是圆了
    UIBezierPath *mPath1 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(60, 60, 40, 40)];
    [mPath1 fill];

    //创建一个矩形的贝塞尔线
    UIBezierPath *mPath2 = [UIBezierPath bezierPathWithRect:CGRectMake(200,70, 40, 40)];
    [mPath2 stroke];

    UIColor *blueColor = [UIColor blueColor];
    [blueColor set];
    //创建一个圆弧 传的弧度
    UIBezierPath *mPath3 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50, 250)radius:20 startAngle:0 endAngle:180/M_PI clockwise:NO];//clockwise表示是否闭合
    [mPath3 stroke];
    UIColor *orangeColor = [UIColor orangeColor];
    [orangeColor set];
    [mPath3 fill];

    //创建一个 矩形的贝塞尔曲线, 带圆角
    UIBezierPath *mPath4 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(250, 80, 20, 20) cornerRadius:3];
    [mPath4 stroke];

    //定义一个矩形 边角会变成 设置的角度  方位/角度大小
    UIBezierPath *mPath5 =[UIBezierPath bezierPathWithRoundedRect:CGRectMake(250, 145, 40, 40) byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(10, -10)];//-10跟10效果一样
    [mPath5 fill];

    
    //定义一个二级的赛贝尔曲线 重点|拐弯点
    UIBezierPath *mPath6 = [UIBezierPath bezierPath];
    [mPath6 moveToPoint:CGPointMake(10,360)];
    [mPath6 addQuadCurveToPoint:CGPointMake(200,460) controlPoint:CGPointMake(85, 240)];
    [mPath6 setLineWidth:3];
    [mPath6 stroke];
    [blueColor set];
    [mPath6 fill];
    
    CGPoint controll1 = CGPointMake(50, 470);
    CGPoint controll2 = CGPointMake(150, 570);
    //定义一个三级的赛贝尔曲线 终点|拐点1|拐点2
    UIBezierPath *mPath7 = [UIBezierPath bezierPath];
    [mPath7 moveToPoint:CGPointMake(10,590)];
    [mPath7 addCurveToPoint:CGPointMake(300, 590)
              controlPoint1:controll1
              controlPoint2:controll2];
    [mPath7 stroke];
    
    UIColor *yellowColor = [UIColor yellowColor];
    [redColor set];
    UIBezierPath *mPath8 = [UIBezierPath bezierPathWithArcCenter:controll1 radius:5 startAngle:0 endAngle:180/M_PI clockwise:YES];
    [mPath8 stroke];
    
    [yellowColor set];
    UIBezierPath *mPath9 = [UIBezierPath bezierPathWithArcCenter:controll2 radius:5 startAngle:0 endAngle:180/M_PI clockwise:YES];
    [mPath9 stroke];
    
    
    //当前贝塞尔的点
//    NSLog(@"mPath7 currentPoint is  : %@",NSStringFromCGPoint(mPath7.currentPoint));
}

@end
