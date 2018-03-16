//
//  ViewController.m
//  Runtime+Demo
//
//  Created by qiuShan on 2018/3/8.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    void (*glt_msgsend)(id, SEL, NSString *,...) = (void (*)(id, SEL, NSString *,...))objc_msgSend;//如果不转换，会崩溃
    glt_msgsend(self,@selector(resolveMethod:),@"aaa",@"bbb");
    
//    [self addNewMethod]; //1.动态添加方法
//    NSLog(@"--------%@",[self performSelector:@selector(abc)]);
}

//********************** 动态添加方法 **********************//
- (void)addNewMethod
{
    IMP imp = class_getMethodImplementation([self class], @selector(resolveMethod:));
    
    BOOL success = class_addMethod([UIView class], @selector(resolveMethod:), imp, "v@:@");
    
    if (success) {
        NSLog(@"添加成功");
    } else {
        NSLog(@"添加失败");
    }
    
    if (class_respondsToSelector([UIView class], @selector(resolveMethod:))) {
        void (*glt_msgsend)(id, SEL, NSString *) = (void (*)(id, SEL, NSString *))objc_msgSend;
        glt_msgsend([[UIView alloc] init],@selector(resolveMethod:),@"aaa");
    }
}

- (void)resolveMethod:(NSString *)args
{
    NSLog(@"class:%@ resolveMethod %@", NSStringFromClass([self class]),args);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
