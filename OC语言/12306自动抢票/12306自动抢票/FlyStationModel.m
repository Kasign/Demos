//
//  FlyStationModel.m
//  12306自动抢票
//
//  Created by qiuShan on 2018/1/23.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "FlyStationModel.h"

@implementation FlyStationModel

- (instancetype)initWithString:(NSString *)string
{
    self = [super init];
    if (self) {
        if (string.length) {
            NSArray * subStringArr = [string componentsSeparatedByString:@"|"];
            if (subStringArr.count > 0) {
                for (int i = 0; i < subStringArr.count; i++) {
                    NSString * subString = [subStringArr objectAtIndex:i];
                    if (subString && [subString isKindOfClass:[NSString class]]) {
                        if (i == 0) {
                            _stationNameSimpleNum = subString;
                        } else if (i == 1) {
                            _stationName = subString;
                        } else if (i == 2) {
                            _stationCode = subString;
                        } else if (i == 3) {
                            _stationNamePinyin = subString;
                        } else if (i == 4) {
                            _stationNameSimple = subString;
                        } else if (i == 5) {
                            _stationNum = subString;
                        }
                    }
                }
            }
        }
    }
    return self;
}

@end
