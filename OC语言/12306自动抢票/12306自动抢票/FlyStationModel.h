//
//  FlyStationModel.h
//  12306自动抢票
//
//  Created by qiuShan on 2018/1/23.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "FlyBaseModel.h"

@interface FlyStationModel : FlyBaseModel

//    bjb|北京北|VAP|beijingbei|bjb|0

@property (nonatomic, copy) NSString  *  stationNameSimpleNum;
@property (nonatomic, copy) NSString  *  stationName;
@property (nonatomic, copy) NSString  *  stationCode;
@property (nonatomic, copy) NSString  *  stationNamePinyin;
@property (nonatomic, copy) NSString  *  stationNameSimple;
@property (nonatomic, copy) NSString  *  stationNum;

- (instancetype)initWithString:(NSString *)string;

@end
