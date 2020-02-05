//
//  ViewController.m
//  Test
//
//  Created by Walg on 2020/1/15.
//  Copyright © 2020 Fly. All rights reserved.
//

#import "ViewController.h"
#import "FLYPerson.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    id pCls = [FLYPerson class];
    void *p = &pCls;
    [(__bridge id)(void *)(&pCls) saySomething];
    
    id pCls1 = [FLYPerson class];
    void *p1 = &pCls1;
    
    NSLog(@"Hello word");
}


@end
