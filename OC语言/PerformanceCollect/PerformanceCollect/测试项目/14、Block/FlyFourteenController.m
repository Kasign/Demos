//
//  FlyFourteenController.m
//  ProgramCollection
//
//  Created by Qiushan on 2020/12/1.
//  Copyright © 2020 FLY. All rights reserved.
//

#import "FlyFourteenController.h"

@interface FlyFourteenController ()

@property (nonatomic, copy)   NSString  *  name;
@property (nonatomic, copy)   void (^kBlock)(int a);
@property (nonatomic, copy)   void (^gBlock)(void);

@end

@implementation FlyFourteenController

/**
 这里总结block对外界变量的捕获
 局部变量：
    block结构体直接持有
 静态变量：
    block结构体持有指向该变量的指针(&)
 全局变量：
    block结构体不持有该变量，在block内部imp内直接操作
 __block 修饰的变量
    block结构体持有指向该变量结构体的指针(&)，该结构体的forwarding指向堆copy的新结构体，改变值的时候，只改变堆内的新结构体的值
 
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testBasicBlock];
//    [self testBlockCopy];
}

- (void)testBasicBlock {
    
    // 未持有外部变量
    // <__NSGlobalBlock__: 0x10cbfe088>
    // 持有外部变量被copy之后
    // <__NSMallocBlock__: 0x600002cd8090>
    // 持有外部变量且被copy之前
    // <_NSStackBlock__: 0x7ffeeb763440>_
    
    int a = 10;
    //__NSGlobalBlock__
    FLYClearLog(@"1 -> %@",^{
        NSLog(@"111");
    });
    
    
    //__NSStackBlock__
    FLYClearLog(@"2 -> %@",^{
        NSLog(@"222 - %d", a);
    });
    
    
    //__NSGlobalBlock__
    void (^block1)(void) = ^{
        FLYClearLog(@"333");
    };
    block1();
    FLYClearLog(@"3 -> %@", block1);
    
    
    
    //__NSMallocBlock__
    void (^block2)(void) = ^{
        FLYClearLog(@"333 - %d", a);
    };
    block2();
    FLYClearLog(@"4 -> %@", block2);
    
    
    
    //__NSMallocBlock__
    void (^block3)(int) = ^(int b){
        NSLog(@"%d %d", b, a);
    };
    self.kBlock = block3;
    FLYClearLog(@"6 -> %@", self.kBlock);
    
    //__NSGlobalBlock__
    void (^block4)(void) = ^{
        NSLog(@"---");
    };
    self.gBlock = block4;
    FLYClearLog(@"10 -> %@", self.gBlock);
    
    __weak __typeof(self) weakSelf = self;
    void (^block5)(void) = ^{
        NSLog(@"--- %@", weakSelf);
    };
    self.gBlock = block5;
}

- (void)testBlockCopy {
    
    _name = @"abcd";
    __block NSString * nameA = _name;
    __block int a = 20;
    __weak __typeof(self) weakSelf = self;
    void (^block3)(int) = ^(int b){
        
        NSLog(@"%d %d %@ %@", b, a, nameA, weakSelf.name);
        nameA = @"bdcdd";
        NSLog(@"%d %d %@", b, a, nameA);
    };
    self.kBlock = block3;
    self.kBlock(2);
}

- (void)testBlockArr {
    
    NSMutableArray * arr = [NSMutableArray array];
    void (^block)(void) = ^() {
        [arr addObject:@"abcd_2"];
    };
    block();
    NSLog(@"%@", arr);
}

@end
