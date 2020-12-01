//
//  FlyFourteenController.m
//  ProgramCollection
//
//  Created by Qiushan on 2020/12/1.
//  Copyright © 2020 FLY. All rights reserved.
//

#import "FlyFourteenController.h"

@interface FlyFourteenController ()

@property (nonatomic, copy)   void (^kBlock)(int a);

@end

@implementation FlyFourteenController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testBasicBlock];
}

- (void)testBasicBlock {
    
    // 3block
    // <__NSGlobalBlock__: 0x10cbfe088>
    // <__NSMallocBlock__: 0x600002cd8090>
    // copy 之前
    // <_NSStackBlock__: 0x7ffeeb763440>_
    // 3 系统级别 - NSBlock
    
    int a = 10;
    //__NSGlobalBlock__
    FLYClearLog(@"1 -> %@",^{
        NSLog(@"111");
    });
    
    //__NSMallocBlock__
    FLYClearLog(@"2 -> %@",^{
        NSLog(@"222 - %d", a);
    });
    
    void (^block1)(void) = ^{
        FLYClearLog(@"333");
    };
    
    block1();
    //__NSGlobalBlock__
    FLYClearLog(@"3 -> %@", block1);
    
    void (^block2)(void) = ^{
        FLYClearLog(@"333 - %d", a);
    };
    
    block2();
    //__NSMallocBlock__
    FLYClearLog(@"4 -> %@", block2);
    
    void (^block3)(int) = ^(int b){
        NSLog(@"%d %d", b, a);
    };
    FLYClearLog(@"5 -> %@", block3);
    self.kBlock = block3;
    FLYClearLog(@"6 -> %@", block3);
    FLYClearLog(@"7 -> %@", self.kBlock);
}

@end
