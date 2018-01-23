//
//  FlyDateModel.m
//  Security
//
//  Created by walg on 2017/1/5.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "FlyDataModel.h"

@implementation FlyDataModel

- (instancetype)initWithDataDic:(NSDictionary *)dataDic
{
    self = [super init];
    if (self) {
        for (NSString *key in dataDic.allKeys) {
            if ([key isEqualToString:@"id"]) {
                self.itemId = [dataDic objectForKey:key];
            }
            if ([key isEqualToString:@"datatype"]) {
                self.dataType = [dataDic objectForKey:key];
            }
            if ([key isEqualToString:@"username"]) {
                self.userName = [dataDic objectForKey:key];
            }
            if ([key isEqualToString:@"security"]) {
                self.security = [dataDic objectForKey:key];
            }
            if ([key isEqualToString:@"note"]) {
                self.note = [dataDic objectForKey:key];
            }
            if ([key isEqualToString:@"detail1"]) {
                self.detail1 = [dataDic objectForKey:key];
            }
            if ([key isEqualToString:@"detail2"]) {
                self.detail2 = [dataDic objectForKey:key];
            }
            if ([key isEqualToString:@"detail3"]) {
                self.detail3 = [dataDic objectForKey:key];
            }
        }
        
    }
    return self;
}

+ (NSDictionary *)modelKeyDictionary
{
    return @{
             @"datatype":@"类型",
             @"username":@"用户名",
             @"security":@"密码",
             @"note":@"备注",
             @"detail1":@"说明1",
             @"detail2":@"说明2",
             @"detail3":@"说明3",
             @"creattime":@"创建时间",
             @"updatetime":@"更新时间"
             };
}

+ (NSArray *)modelKeyArray
{
    return @[@"datatype",@"username",@"security",@"note",@"detail1",@"detail2",@"detail3",@"creattime",@"updatetime"];
}

- (NSDictionary *)toValueDictionary
{
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    
    if (self.dataType) {
        [dataDic setObject:_dataType forKey:@"datatype"];
    }
    if (self.userName) {
        [dataDic setObject:_userName forKey:@"username"];
    }
    if (self.security) {
        [dataDic setObject:_security forKey:@"security"];
    }
    if (self.note) {
        [dataDic setObject:_note forKey:@"note"];
    }
    if (self.detail1) {
        [dataDic setObject:_detail1 forKey:@"detail1"];
    }
    if (self.detail2) {
        [dataDic setObject:_detail2 forKey:@"detail2"];
    }
    if (self.detail3) {
        [dataDic setObject:_detail3 forKey:@"detail3"];
    }
    if (self.creatTime) {
        [dataDic setObject:_creatTime forKey:@"creattime"];
    }
    if (self.updateTime) {
        [dataDic setObject:_updateTime forKey:@"updatetime"];
    }
    
    return [dataDic copy];
}

@end
