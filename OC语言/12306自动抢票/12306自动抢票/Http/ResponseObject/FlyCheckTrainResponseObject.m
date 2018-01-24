//
//  FlyCheckTrainResponseObject.m
//  12306自动抢票
//
//  Created by qiuShan on 2018/1/23.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "FlyCheckTrainResponseObject.h"

@implementation FlyCheckTrainResponseObject

- (void)serializerWithDic:(NSDictionary*)dic
{
    [super serializerWithDic:dic];
    if (self.result && [self.result isKindOfClass:[NSArray class]]) {
        [self resultArrayWithModel];
    }
}

- (void)resultArrayWithModel
{
    NSMutableArray * mutableArray = [NSMutableArray array];
    for (int i =0; i < self.result.count; i ++)
    {
        NSString * valueStr = [self.result objectAtIndex:i];
        if (valueStr && [valueStr isKindOfClass:[NSString class]]) {
            FlyTrainStateModel * model = [[FlyTrainStateModel alloc] initWithString:valueStr];
            if (model) {
                [mutableArray addObject:model];
            }
        }
    }
    self.result = [mutableArray copy];
}

@end
