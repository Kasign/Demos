//
//  FlyDateModel.m
//  Security
//
//  Created by walg on 2017/1/5.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "FlyDataModel.h"

@implementation FlyDataModel

- (instancetype)initWithArray:(NSArray*)array key:(NSString*)keyString
{
    self = [super init];
    if (self) {
        _keyArray = [NSMutableArray array];
        _valueArray = [NSMutableArray array];
        _keyString = keyString;
        for (NSDictionary *dic in array)
        {
            for (NSString *key in dic.allKeys)
            {
                [_keyArray addObject:key];
                NSString *value =[dic objectForKey:key];
                if (!value) {
                    value = @"";
                }
                [_valueArray addObject:value];
            }
        }
    }
    return self;
}
@end
