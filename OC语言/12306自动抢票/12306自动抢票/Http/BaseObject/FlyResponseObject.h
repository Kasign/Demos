//
//  FlyResponseObject.h
//  12306自动抢票
//
//  Created by qiuShan on 2018/1/23.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define RESPONSE_STATUS_KEY        @"status"
#define RESPONSE_MSGV_KEY          @"messages"
#define RESPONDE_DATA_KEY          @"data"
#define RESPONDE_HTTPSTATUS_KEY    @"httpstatus"

@interface FlyResponseObject : NSObject

@property (nonatomic, strong) NSNumber * status;
@property (nonatomic, copy)   NSString * messages;
@property (nonatomic, copy)   NSString * httpstatus;

+ (FlyResponseObject *)responseWithJsonObject:(id)json;

- (instancetype)initWithResponseDictionary:(NSDictionary *)dict;

- (void)serializerWithDic:(NSDictionary*)dic;

- (NSDictionary *)dictionaryValue;

@end
