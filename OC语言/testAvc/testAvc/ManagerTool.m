//
//  ManagerTool.m
//  testAvc
//
//  Created by 秋山 on 2017/9/7.
//  Copyright © 2017年 秋山. All rights reserved.
//

#import "ManagerTool.h"

@interface ManagerTool ()
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *weight;
@end

@implementation ManagerTool
- (instancetype)initWithDic:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
