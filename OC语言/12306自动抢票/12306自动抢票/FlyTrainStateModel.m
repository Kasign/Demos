//
//  FlyTrainStateModel.m
//  12306自动抢票
//
//  Created by qiuShan on 2018/1/23.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "FlyTrainStateModel.h"

@implementation FlyTrainStateModel

- (instancetype)initWithString:(NSString *)string
{
    self = [super init];
    if (self) {
        NSArray * comArray  = [string componentsSeparatedByString:@"|"];
        if (comArray.count > 0) {
            [self setValuesWithArray:comArray];
        }
    }
    return self;
}

- (void)setValuesWithArray:(NSArray *)array
{
    for (int i = 0; i < array.count; i ++) {
        NSString * valueStr = [array objectAtIndex:i];
        if (valueStr && [valueStr isKindOfClass:[NSString class]]) {
            switch (i) {
                case 0:
                    _secretStr = valueStr;
                    break;
                case 1:
                    _buttonTextInfo = valueStr;
                    break;
                case 2:
                    _trainNo = valueStr;
                    break;
                case 3:
                    _trainCode = valueStr;
                    break;
                case 4:
                    _startStationCode = valueStr;
                    break;
                case 5:
                    _endStationCode = valueStr;
                    break;
                case 6:
                    _fromStationCode = valueStr;
                    break;
                case 7:
                    _toStationCode = valueStr;
                    break;
                case 8:
                    _startTime = valueStr;
                    break;
                case 9:
                    _arriveTime = valueStr;
                    break;
                    
                    
                case 10:
                    _totalTiem = valueStr;
                    break;
                case 11:
                    _canWebBuy = valueStr;
                    break;
                case 12:
                    _ypInfo = valueStr;
                    break;
                case 13:
                    _startTrainDate = valueStr;
                    break;
                case 14:
                    _trainSeatFeature = valueStr;
                    break;
                case 15:
                    _locationCode = valueStr;
                    break;
                case 16:
                    _fromStationNo = valueStr;
                    break;
                case 17:
                    _toStationNo = valueStr;
                    break;
                case 18:
                    _isSupportCard = valueStr;
                    break;
                case 19:
                    _controlledTrainFlag = valueStr;
                    break;
                    
                    
                case 20:
                    _ggNum = valueStr;
                    break;
                case 21:
                    _grNum = valueStr;
                    break;
                case 22:
                    _qtNum = valueStr;
                    break;
                case 23:
                    _rwNum = valueStr;
                    break;
                case 24:
                    _rzNum = valueStr;
                    break;
                case 25:
                    _tzNum = valueStr;
                    break;
                case 26:
                    _wzNum = valueStr;
                    break;
                case 27:
                    _ybNum = valueStr;
                    break;
                case 28:
                    _ywNum = valueStr;
                    break;
                case 29:
                    _yzNum = valueStr;
                    break;
                    
                    
                case 30:
                    _zeNum = valueStr;
                    break;
                case 31:
                    _zyNum = valueStr;
                    break;
                case 32:
                    _swzNum = valueStr;
                    break;
                case 33:
                    _ypEx = valueStr;
                    break;
                case 34:
                    _seatTypes = valueStr;
                    break;
                case 35:
                    
                    break;
                case 36:
                    
                    break;
                case 37:
                    
                    break;
                    
                default:
                    break;
            }
            
        }
    }
}

@end
