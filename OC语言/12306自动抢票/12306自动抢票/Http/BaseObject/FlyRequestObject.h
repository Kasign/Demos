//
//  FlyRequestObject.h
//  12306自动抢票
//
//  Created by qiuShan on 2018/1/23.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlyRequestObject : NSObject

- (NSDictionary *)dictionaryValue;

- (NSString *)api;

/**
 这里写了一个自动生成，但必须要求对应的response与request名称对应，否则需要重写当前方法
 @return 对应的responseObject类
 */
- (NSString *)responseObjectClass;

@end
