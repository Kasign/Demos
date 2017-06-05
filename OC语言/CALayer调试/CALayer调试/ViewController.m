//
//  ViewController.m
//  CALayer调试
//
//  Created by walg on 2017/3/9.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) CALayer *backlayer;
@property (nonatomic, strong) CALayer *firstLayer;
@property (nonatomic, strong) CALayer *secondLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
//    _backlayer = [CALayer layer];
//    _backlayer.frame = CGRectMake(100, 100, 200, 200);
//    _backlayer.backgroundColor = [UIColor orangeColor].CGColor;
////    _backlayer.opaque = YES;
////    _backlayer.shouldRasterize = YES;
//    _backlayer.opacity = 0.5;
//    [self.view.layer addSublayer:_backlayer];
//    
//    _firstLayer = [CALayer layer];
//    _firstLayer.frame = CGRectMake(20, 20, 100, 100);
////    _firstLayer.backgroundColor = [UIColor whiteColor].CGColor;
//    _firstLayer.opacity = 0.5;
//    [_backlayer addSublayer:_firstLayer];
    
    //create opaque button
    UIButton *button1 = [self customButton];
    button1.center = CGPointMake(150, 150);
    [self.view addSubview:button1];
    
    //create translucent button
    UIButton *button2 = [self customButton];
    button2.center = CGPointMake(150,350);
    button2.alpha = 0.5;
    [self.view addSubview:button2];
    
    //enable rasterization for the translucent button
    button2.layer.shouldRasterize = YES;
    button2.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
}
- (UIButton *)customButton
{
    CGRect frame = CGRectMake(0, 0, 150, 50);
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.cornerRadius = 10;
    
    frame = CGRectMake(20, 10, 110, 30);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor orangeColor];
    label.text = @"Hello World";
    label.textAlignment = NSTextAlignmentCenter;
    [button addSubview:label];
    return button;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
