//
//  FlyHttpClient.h
//  12306自动抢票
//
//  Created by qiuShan on 2018/1/23.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FlyRequestObject;
@class FlyResponseObject;

@interface FlyHttpClient : NSObject

@property (nonatomic, strong, readonly) NSMutableDictionary  *  dataDic;

+ (instancetype)sharedInstance;

- (void)getDataWithRequest:(FlyRequestObject*)request block:(void(^)(FlyResponseObject *responseObject,NSError * error))block;

- (void)postDataWithRequest:(FlyRequestObject*)request block:(void(^)(FlyResponseObject *responseObject,NSError * error))block;

@end
