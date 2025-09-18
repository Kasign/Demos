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
    
    FLYTIMELog(@"%s", __func__);
}

+ (void)initialize {
    
    FLYTIMELog(@"%@ %s", [self class], __func__);
}

- (void)walk {
    
    FLYTIMELog(@"人在走");
}

- (void)eat {
    
    FLYTIMELog(@"人在吃");
}

- (void)run{
    
    FLYTIMELog(@"人跑了");
}

- (void)drink {
    
    FLYTIMELog(@"喝水");
}

+ (void)dance {
    
    FLYTIMELog(@"跳舞");
}

void sleepMethodIMP(id self,SEL _cmd)
{
    FLYTIMELog(@"睡觉了");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    
    if (sel == sel_registerName("sleep")) {
        class_addMethod([self class], sel, (IMP)sleepMethodIMP, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}
@end
