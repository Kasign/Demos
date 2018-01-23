//
//  FlyServerManager.h
//  12306自动抢票
//
//  Created by qiuShan on 2018/1/23.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlyServerManager : NSObject


+ (instancetype)sharedInstanced;

- (void)getDataWithUrlStr:(NSString *)urlStr block:(void(^)(NSDictionary * dataResponse,NSError * error))block;

- (void)postDataWithUrlStr:(NSString *)urlStr parameter:(NSString *)parameterStr block:(void(^)(NSDictionary * dataResponse,NSError * error))block;

@end
