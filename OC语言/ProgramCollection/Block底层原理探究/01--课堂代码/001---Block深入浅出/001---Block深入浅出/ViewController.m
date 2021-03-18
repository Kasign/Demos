//
//  ViewController.m
//  001---Block深入浅出
//
//  Created by Cooci on 2018/6/24.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import "ViewController.h"

typedef void(^KCBlock)(id data);

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 3block
    // <__NSGlobalBlock__: 0x10cbfe088>
    // <__NSMallocBlock__: 0x600002cd8090>
    // copy 之前
    // <_NSStackBlock__: 0x7ffeeb763440>_
    // 3 系统级别 - NSBlock
    
    int a = 10;
    void (^block)(void) = ^{
        NSLog(@"1233 - %d",a);
    };
    
    block();
    NSLog(@"%@",block);
    NSLog(@"%@",^{
        NSLog(@"1233 - %d",a);
    });
    
    // masonry make.withd.equal(100); block 返回值
    // block 参数 - 函数式 y=f(x) - y=f(f(x))  - f(x) - 表达式 - block
    // RAC 
    
}



@end
