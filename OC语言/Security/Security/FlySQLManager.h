//
//  FlySQLManager.h
//  Security
//
//  Created by walg on 2017/7/10.
//  Copyright © 2017年 walg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FlyDataModel;
@interface FlySQLManager : NSObject

/**
 单例
 */
+ (instancetype)shareInstance;

/**
 时间样式
 */
+ (NSString *)stringFromDateFormat;

/**
 创建数据表
 */
- (void)creatBaseTable;

/**
 读取所有数据
 */
- (NSArray *)readAllData;

/**
 插入数据
 */
- (void)insertDateWithModel:(FlyDataModel*)model;

/**
 更新数据
 */
- (void)updateDateWithModel:(FlyDataModel*)model;

/**
 删除数据
 */
- (void)deleteDataWithItemID:(NSString *)itemId dataType:(NSString*)dataType;

@end
