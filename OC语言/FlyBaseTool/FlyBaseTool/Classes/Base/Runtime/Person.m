//
//  Person.m
//  RunTimeDemo
//
//  Created by walg on 2017/3/22.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
@implementation Person

+ (void)load {
    
    FLYLog(@"%s", __func__);
}

+ (void)initialize {
    
    FLYLog(@"%@ %s", [self class], __func__);
}

- (void)walk {
    
    FLYLog(@"人在走");
}

- (void)eat {
    
    FLYLog(@"人在吃");
}

- (void)run{
    
    FLYLog(@"人跑了");
}

- (void)drink {
    
    FLYLog(@"喝水");
}

+ (void)dance {
    
    FLYLog(@"跳舞");
}

void sleepMethodIMP(id self,SEL _cmd)
{
    FLYLog(@"睡觉了");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    
    if (sel == sel_registerName("sleep")) {
        class_addMethod([self class], sel, (IMP)sleepMethodIMP, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}
@end
