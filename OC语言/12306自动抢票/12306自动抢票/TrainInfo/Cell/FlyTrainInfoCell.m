//
//  FlyTrainInfoCell.m
//  12306自动抢票
//
//  Created by qiuShan on 2018/1/31.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "FlyTrainInfoCell.h"

@implementation FlyTrainInfoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setModel:(FlyTrainStateModel *)model
{
    _model = model;
    
}

@end
