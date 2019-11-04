//
//  ViewController.m
//  CoreText初探
//
//  Created by Q on 2018/7/27.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "ViewController.h"
#import "FLYLayer.h"

@interface ViewController ()
@property (nonatomic, strong) FLYLayer   *   fly_layer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _fly_layer = [FLYLayer layer];
    [_fly_layer setFrame:CGRectMake(20, 80, 200, 100)];
    [_fly_layer setBackgroundColor:[UIColor blueColor].CGColor];
    [_fly_layer setNeedsDisplay];
    [self.view.layer addSublayer:_fly_layer];
    
    CATextLayer * textLayer = [CATextLayer layer];
    [textLayer setContentsScale:[UIScreen mainScreen].scale];
    [textLayer setFrame:CGRectMake(20, 220, 200, 150)];
    [textLayer setBackgroundColor:[UIColor redColor].CGColor];
    [textLayer setString:@"你好么你好么你好么你好么你好么你好么你好么你好么你好么你好么你好么你好么你好么你好么1123sdfa"];
    [textLayer setFontSize:12.f];
    [textLayer setForegroundColor:[UIColor blackColor].CGColor];
    [textLayer setWrapped:YES];
    [self.view.layer addSublayer:textLayer];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 300, 200, 40)];
    [label setFont:[UIFont systemFontOfSize:12.f]];
    [label setTextColor:[UIColor blackColor]];
    [label setText:@"你好么"];
//    [label setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:label];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
