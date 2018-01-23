//
//  FlyRequestObject.m
//  12306自动抢票
//
//  Created by qiuShan on 2018/1/23.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "FlyRequestObject.h"
#import <objc/runtime.h>

@implementation FlyRequestObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSDictionary *)dictionaryValue
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned int count = 0;
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    for (int i=0; i<count; i++)
    {
        objc_property_t property = propertys[i];
        const char *key = property_getName(property);
        NSString *name = [NSString stringWithCString:key encoding:NSUTF8StringEncoding];
        NSValue *value = [self valueForKey:name];
        if (value) {
            [dict setObject:value forKey:name];
        }
    }
    free(propertys);
    return dict;
}

- (NSString *)api
{
    return @"";
}

- (NSString *)responseObjectClass
{
    NSString * responseStr = NSStringFromClass([self class]);
    NSString * resultStr = [responseStr stringByReplacingOccurrencesOfString:@"Request" withString:@"Response"];
    return resultStr;
}

@end
