//
//  FlyBaseModel.h
//  12306自动抢票
//
//  Created by qiuShan on 2018/1/23.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlyBaseModel : NSObject

-(instancetype)initWithDic:(NSDictionary*)dic;

-(void)autoSetValusWithDic:(NSDictionary*)dic;

@end
