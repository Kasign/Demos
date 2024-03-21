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

+ (void)load {

    FLYLog(@"%s", __func__);
}

//+ (void)initialize {
//
//    FLYLog(@"%s", __func__);
//}

- (void)eat {
    FLYLog(@"狗在吃");
}

- (void)run {
    FLYLog(@"狗在跑");
}
@end
