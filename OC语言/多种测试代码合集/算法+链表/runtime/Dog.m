//
//  Dog.m
//  RunTimeDemo
//
//  Created by walg on 2017/3/22.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "Dog.h"
#import "Person.h"
#import <objc/message.h>
@implementation Dog

+(void)load{
    Method method = class_getInstanceMethod([Person class], @selector(drink));
    IMP methodIMP = method_getImplementation(method);
    const char *types = method_getTypeEncoding(method);
    class_addMethod([Person class], sel_registerName("laught"), methodIMP, types);
}

- (void)eat {
    FLYLog(@"狗在吃");
}

- (void)run {
    FLYLog(@"狗在跑");
}
@end
