//
//  FlyStationManager.m
//  12306自动抢票
//
//  Created by qiuShan on 2018/1/23.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "FlyStationManager.h"
#import "FlyHttpClient.h"
#import "FlyDataSource.h"
#import "FlyStationModel.h"
#import "FlyCheckTrainRequestObject.h"

@implementation FlyStationManager

+ (NSDictionary *)stationDictionary
{
    NSMutableDictionary * resultDictionary = [NSMutableDictionary dictionary];
    
    NSString * dataStr = [FlyDataSource stringWithStation];
    NSArray * dataArr  = [dataStr componentsSeparatedByString:@"@"];
    for (NSString * stationStr in dataArr) {
        if (stationStr && [stationStr isKindOfClass:[NSString class]]) {
            if (stationStr.length) {
                FlyStationModel * model = [[FlyStationModel alloc] initWithString:stationStr];
                if (model) {
                    [resultDictionary setObject:model forKey:model.stationName];
                }
            }
        }
    }
    return resultDictionary;
}

+ (void)stationInfoWithServerFromStation:(FlyStationModel *)fromModel toStation:(FlyStationModel *)toModel data:(NSString *)data block:(void(^)(FlyCheckTrainResponseObject *responseObject,NSError * error))block
{
    FlyCheckTrainRequestObject * request = [[FlyCheckTrainRequestObject alloc] init];
    request.from_station  = fromModel.stationCode;
    request.to_station    = toModel.stationCode;
    request.train_date    = data;
    request.purpose_codes = @"ADULT";
    
    [[FlyHttpClient sharedInstance] getDataWithRequest:request block:^(FlyResponseObject *responseObject, NSError *error) {
        FlyCheckTrainResponseObject * trainObject = (FlyCheckTrainResponseObject *)responseObject;
        block(trainObject,error);
    }];
}

@end
