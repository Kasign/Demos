//
//  ViewController.m
//  Test+M
//
//  Created by Walg on 2019/6/3.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *arr1 = @[@1,@2,@3,@4,@5,@6,@7,@8];
    NSArray *arr2 = @[@4,@5,@6,@7,@8,@9,@10,@11];
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:1];
    [mArray removeObjectsInArray:arr1];
    
    
}


@end
