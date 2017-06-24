//
//  FlyDetailModel.m
//  ccc
//
//  Created by walg on 2017/5/23.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "FlyDetailModel.h"

@implementation FlyDetailModel

-(instancetype)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        self.expect = dic[@"expect"];
        self.opentime = dic[@"opentime"];
        self.opencode = dic[@"opencode"];
        self.opentimestamp = dic[@"opentimestamp"];
    }
    return self;
}
@end
