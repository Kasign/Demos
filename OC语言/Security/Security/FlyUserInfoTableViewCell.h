//
//  FlyUserInfoTableViewCell.h
//  Security
//
//  Created by walg on 2017/1/5.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "FlyBasicTableViewCell.h"

@interface FlyUserInfoTableViewCell : FlyBasicTableViewCell
@property (nonatomic, assign) BOOL  isOn;
@property (nonatomic, copy) void(^clickBlock)(BOOL on);
@end
