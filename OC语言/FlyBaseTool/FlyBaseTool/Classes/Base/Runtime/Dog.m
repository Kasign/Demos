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

    FLYTIMELog(@"%s", __func__);
}

//+ (void)initialize {
//
//    FLYTIMELog(@"%s", __func__);
//}

- (void)eat {
    FLYTIMELog(@"狗在吃");
}

- (void)run {
    FLYTIMELog(@"狗在跑");
}
@end
