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

-(void)walk{
    NSLog(@"人在走");
}

-(void)eat{
    NSLog(@"人在吃");
}

-(void)run{
    NSLog(@"人跑了");
}

-(void)drink{
    NSLog(@"喝水");
}

+ (void)dance
{
    NSLog(@"跳舞");
}

void sleepMethodIMP(id self,SEL _cmd){
    NSLog(@"睡觉了");
}

+(BOOL)resolveInstanceMethod:(SEL)sel{
    if (sel == sel_registerName("sleep")) {
        class_addMethod([self class], sel, (IMP)sleepMethodIMP, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}
@end
