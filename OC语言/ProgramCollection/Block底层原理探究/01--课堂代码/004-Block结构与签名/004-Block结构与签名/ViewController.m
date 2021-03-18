//
//  ViewController.m
//  004-Block结构与签名
//
//  Created by Cooci on 2019/7/3.
//  Copyright © 2019 Cooci. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    int a = 10;
    // 
    // 全局 - 栈 - 堆
    // YES 有签名
    
    /**
     BLOCK_DEALLOCATING =      (0x0001),  // runtime
     BLOCK_REFCOUNT_MASK =     (0xfffe),  // runtime
     BLOCK_NEEDS_FREE =        (1 << 24), // runtime
     BLOCK_HAS_COPY_DISPOSE =  (1 << 25), // compiler
     BLOCK_HAS_CTOR =          (1 << 26), // compiler: helpers have C++ code
     BLOCK_IS_GC =             (1 << 27), // runtime
     BLOCK_IS_GLOBAL =         (1 << 28), // compiler
     BLOCK_USE_STRET =         (1 << 29), // compiler: undefined if !BLOCK_HAS_SIGNATURE
     BLOCK_HAS_SIGNATURE  =    (1 << 30), // compiler
     BLOCK_HAS_EXTENDED_LAYOUT=(1 << 31)  // compiler
     */
    
            
    void (^block1)(void) = ^{
        NSLog(@"LG_Block - %d");
    };
    block1();
}


@end
