//
//  FlyTrainInfoViewController.h
//  12306自动抢票
//
//  Created by qiuShan on 2018/1/31.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "FlyBaseViewController.h"

@class FlyStationModel;

@interface FlyTrainInfoViewController : FlyBaseViewController

@property (nonatomic, strong) NSString         *  data;
@property (nonatomic, strong) FlyStationModel  *  fromModel;
@property (nonatomic, strong) FlyStationModel  *  toModel;

@end
