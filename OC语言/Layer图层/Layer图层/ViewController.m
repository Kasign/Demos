//
//  ViewController.m
//  Layer图层
//
//  Created by walg on 2017/3/7.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) CALayer *whiteLayer;
@property (nonatomic, strong) CALayer *blueLayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    _whiteLayer = [CALayer layer];
    _whiteLayer.bounds = CGRectMake(0, 0, 100, 100);
    _whiteLayer.position = CGPointMake(100, 100);
    _whiteLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.view.layer addSublayer:_whiteLayer];
    
    _blueLayer = [CALayer layer];
    _blueLayer.bounds = CGRectMake(0, 0, 50, 50);
    _blueLayer.position = CGPointMake(150, 150);
    _blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.view.layer addSublayer:_blueLayer];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    
    CGPoint locationPoint = [touch locationInView:self.view];
    
    CGPoint whitPoint = [_whiteLayer convertPoint:locationPoint fromLayer:self.view.layer];
    CGPoint bluePoint = [_blueLayer convertPoint:locationPoint fromLayer:self.view.layer];
    
    NSLog(@"white:%@",NSStringFromCGPoint(whitPoint));
    NSLog(@"blue:%@",NSStringFromCGPoint(bluePoint));
    
    if ([_whiteLayer containsPoint:whitPoint]) {
        [[[UIAlertView alloc] initWithTitle:@"Inside white" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    
    if ([_blueLayer containsPoint:bluePoint]) {
         [[[UIAlertView alloc] initWithTitle:@"Inside blue" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
