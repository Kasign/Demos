//
//  FlyResponseObject.m
//  12306自动抢票
//
//  Created by qiuShan on 2018/1/23.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "FlyResponseObject.h"

@implementation FlyResponseObject

+ (FlyResponseObject *)responseWithJsonObject:(id)json
{
    return [[self alloc] initWithResponseDictionary:json];
}

- (instancetype)initWithResponseDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            for (NSString *key in [dict allKeys])
            {
                if ([key isEqualToString:RESPONSE_MSGV_KEY]) {
                    _messages = [dict objectForKey:key];
                }
                if ([key isEqualToString:RESPONSE_STATUS_KEY]) {
                    _status = [dict objectForKey:key];
                }
                if ([key isEqualToString:RESPONDE_HTTPSTATUS_KEY]) {
                    _httpstatus = [dict objectForKey:key];
                }
                if ([key isEqualToString:RESPONDE_DATA_KEY]) {
                    NSDictionary * dataDic = [dict objectForKey:key];
                    if ([dataDic isKindOfClass:[NSDictionary class]]) {
                        [self serializerWithDic:dataDic];
                    }
                }
            }
        }
    }
    return self;
}

- (void)serializerWithDic:(NSDictionary*)dic
{
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

- (NSDictionary *)dictionaryValue
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if (self.messages) {
        [dict setObject:self.messages forKey:RESPONSE_MSGV_KEY];
    }
    if (self.status) {
        [dict setObject:self.status forKey:RESPONSE_STATUS_KEY];
    }
    
    return dict;
}

@end
