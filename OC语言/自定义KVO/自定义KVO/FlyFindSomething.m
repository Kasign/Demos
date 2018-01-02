//
//  FlyFindSomething.m
//  自定义KVO
//
//  Created by qiuShan on 2017/12/29.
//  Copyright © 2017年 Fly. All rights reserved.
//

#import "FlyFindSomething.h"

@implementation FlyFindSomething

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)startFind
{
    NSDictionary * dict = [NSDictionary dictionary];
    NSString     * name = @"abc";
    [self findSomeThingWithDic:dict name:name block:^(BOOL success, NSString *result) {
        
    }];
}

- (void)findSomeThingWithDic:(NSDictionary *)dic name:(NSString *)name block:(void(^)(BOOL success,NSString * result))block
{
    for (NSString * key in dic.allKeys) {
        if ([key isEqualToString:name]) {
            block (YES,[dic objectForKey:key]);
            return;
        }
    }
    block(NO,nil);
}


@end
