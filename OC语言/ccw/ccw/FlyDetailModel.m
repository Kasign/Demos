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

-(instancetype)initWithBmobObject:(BmobObject *)object{
    self = [super init];
    if (self) {
        self.expect = [object objectForKey:@"expect"];
        self.opentime = [object objectForKey:@"opentime"];
        self.opencode = [object objectForKey:@"opencode"];
        self.opentimestamp = [object objectForKey:@"opentimestamp"];
    }
    return self;
}

@end
