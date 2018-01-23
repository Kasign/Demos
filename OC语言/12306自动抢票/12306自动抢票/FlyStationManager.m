//
//  FlyStationManager.m
//  12306自动抢票
//
//  Created by qiuShan on 2018/1/23.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "FlyStationManager.h"
#import "FlyDataSource.h"
#import "FlyStationModel.h"

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


@end
