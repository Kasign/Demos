//
//  FlyCheckTrainRequestObject.h
//  12306自动抢票
//
//  Created by qiuShan on 2018/1/23.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "FlyRequestObject.h"

@interface FlyCheckTrainRequestObject : FlyRequestObject

@property (nonatomic, copy) NSString  *  train_date;
@property (nonatomic, copy) NSString  *  from_station;
@property (nonatomic, copy) NSString  *  to_station;
@property (nonatomic, copy) NSString  *  purpose_codes;

@end
