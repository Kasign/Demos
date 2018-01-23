//
//  FlyCheckTrainResponseObject.h
//  12306自动抢票
//
//  Created by qiuShan on 2018/1/23.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "FlyResponseObject.h"

@interface FlyCheckTrainResponseObject : FlyResponseObject

@property (nonatomic, assign) NSInteger        flag;
@property (nonatomic, strong) NSDictionary  *  map;
@property (nonatomic, strong) NSArray       *  result;

@end
