//
//  FlyStationManager.h
//  12306自动抢票
//
//  Created by qiuShan on 2018/1/23.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FlyCheckTrainResponseObject;
@class FlyStationModel;

@interface FlyStationManager : NSObject

/**
 包含各个车站信息，拿的本地数据，车站编号信息
 @return 包含 value: FlyStationModel 的字典 key:车站名字
 */
+ (NSDictionary *)stationDictionary;

/**
 查询车票信息
 @param fromModel 起始站 model
 @param toModel 到达站 model
 @param data 日期 格式"yyyy-MM-dd"
 @param block 请求结果
 */
+ (void)stationInfoWithServerFromStation:(FlyStationModel *)fromModel toStation:(FlyStationModel *)toModel data:(NSString *)data block:(void(^)(FlyCheckTrainResponseObject *responseObject,NSError * error))block;

@end
