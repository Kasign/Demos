//
//  FlyBaseModel.m
//  12306自动抢票
//
//  Created by qiuShan on 2018/1/23.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "FlyBaseModel.h"
#import <objc/runtime.h>

@implementation FlyBaseModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [self autoSetValusWithDic:dic];
        }
    }
    return self;
}

-(void)autoSetValusWithDic:(NSDictionary*)dic{
    
    unsigned int count = 0;
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    for (int i=0; i<count; i++)
    {
        objc_property_t property = propertys[i];
        const char *key = property_getName(property);
        NSString *name = [NSString stringWithCString:key encoding:NSUTF8StringEncoding];
        NSValue *value = [dic valueForKey:name];
        if (value) {
            [self setValue:value forKey:name];
        }
    }
    free(propertys);
}

@end
