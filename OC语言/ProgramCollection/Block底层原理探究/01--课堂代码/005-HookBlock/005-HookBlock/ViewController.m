//
//  ViewController.m
//  005-HookBlock
//
//  Created by Cooci on 2019/7/3.
//  Copyright © 2019 Cooci. All rights reserved.
//

#import "ViewController.h"
#import "LGPerson.h"
#import "LGHookBlock.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // [p logName:]; -- hook ()

    LGPerson *p = [LGPerson new];

    NSInvocation *anIn = [NSInvocation invocationWithMethodSignature:[NSMethodSignature signatureWithObjCTypes:"v@:@"]];
    [anIn setSelector:@selector(logName:)];
    NSString *str = @"lg";
    [anIn setArgument:&str atIndex:2];
    [anIn invokeWithTarget:p];

    // block() -> invoke (hook)
    // 不能让block->invoke -> imp -> 变什么 -> objc_msgforward
    // NSBlock
    // methodsi
    // invocatioN  实现
    // viewdidload
    // invoke()
    // 埋点 插拔式 (无侵入)
    // 功能代码 -> 业务需求
    
    int num = 10;
    void(^testBlock)(void) = ^(){
        NSLog(@"test: %d",num);
    };

    NSInvocation *blockIn = [NSInvocation invocationWithMethodSignature:[NSMethodSignature signatureWithObjCTypes:"v@?"]];
    blockIn.target = testBlock;
    [blockIn invoke];

     [LGHookBlock hookBlock:testBlock callBack:nil];
}


@end


