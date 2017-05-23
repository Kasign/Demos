//
//  ViewController.m
//  ccc
//
//  Created by walg on 2017/5/23.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "ViewController.h"
#import "FlyShowOldViewController.h"
#import "FlyHallViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
       FlyHallViewController *vc = [[FlyHallViewController alloc] init];
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:vc];
 
    [self presentViewController:nv animated:YES completion:nil];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
