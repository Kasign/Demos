//
//  FlyCheckTrainRequestObject.m
//  12306自动抢票
//
//  Created by qiuShan on 2018/1/23.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "FlyCheckTrainRequestObject.h"

@implementation FlyCheckTrainRequestObject

- (NSString *)api
{
    return @"otn/leftTicket/queryZ";
}

- (NSDictionary *)dictionaryValue
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.to_station) {
        [dict setValue:self.to_station forKey:@"leftTicketDTO.to_station"];
    }
    if (self.from_station) {
        [dict setValue:self.from_station forKey:@"leftTicketDTO.from_station"];
    }
    if (self.train_date) {
        [dict setValue:self.train_date forKey:@"leftTicketDTO.train_date"];
    }
    if (self.purpose_codes) {
        [dict setValue:self.purpose_codes forKey:@"purpose_codes"];
    }
    return dict;
}

@end
