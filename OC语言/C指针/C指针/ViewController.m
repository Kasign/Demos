//
//  ViewController.m
//  C指针
//
//  Created by Q on 2018/6/13.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "ViewController.h"
#import "FlyPerson.h"

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray   *   personArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
}

- (void)initData
{
    NSMutableArray * personArr = [NSMutableArray array];
    FlyPerson * p0 = [[FlyPerson alloc] initWithName:@"a" age:20 height:16.f];
    FlyPerson * p1 = [[FlyPerson alloc] initWithName:@"b" age:31 height:17.f];
    FlyPerson * p2 = [[FlyPerson alloc] initWithName:@"c" age:42 height:18.f];
    FlyPerson * p3 = [[FlyPerson alloc] initWithName:@"d" age:53 height:20.f];
    [personArr addObject:p0];
    [personArr addObject:p1];
    [personArr addObject:p2];
    [personArr addObject:p3];
    _personArr = personArr;
    
    NSLog(@"before:%@",personArr);
    for (FlyPerson * p in personArr) {
//        [p setAge:80];
        
        NSLog(@"%p",&p);
    }
    NSLog(@"end:%@",personArr);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
