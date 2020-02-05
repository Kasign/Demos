//
//  ViewController.m
//  iOS绘制
//
//  Created by mx-QS on 2019/7/22.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "ViewController.h"
#import "FlyDrawView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    FlyDrawView * view = [[FlyDrawView alloc] initWithFrame:self.view.bounds];
    [view setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.2]];
    [self.view addSubview:view];
    
    FlyDrawLayer * layer = [FlyDrawLayer layer];
    [layer setFrame:self.view.bounds];
    [layer setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.2].CGColor];
    [layer setNeedsDisplay];
    [self.view.layer addSublayer:layer];
    
    UIView * tipView1 = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 0.2, self.view.frame.size.height * 0.5 - 100, 1.f, 100)];;
    [tipView1 setBackgroundColor:[[UIColor purpleColor] colorWithAlphaComponent:1.f]];
    [self.view addSubview:tipView1];
    
    UIView * tipView2 = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 0.8, self.view.frame.size.height * 0.5 - 100, 1.f, 100)];;
    [tipView2 setBackgroundColor:[[UIColor purpleColor] colorWithAlphaComponent:1.f]];
    [self.view addSubview:tipView2];
    
}

@end
