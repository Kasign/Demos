//
//  NSDate+compare.h
//
//  Created by FLY on 2017/10/20.
//  Copyright © 2017年 FLY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+type.h"

@interface NSDate (compare)

/**
 创建以当地时区的formatter
 @param type formatter 格式 yyyy-MM-dd HH:mm:ss
 @return formatter
 */
+ (NSDateFormatter *)dateFormatterWithType:(NSString*)type;

#pragma mark - Compare with date
/**
 对比两个时间差,返回特定str
 @param date 要对比的时间
 @return 返回值
 */
+ (NSString*)useNowDateCompareWithDate:(NSDate*)date;

+ (NSInteger)yearsFromNowWithDate:(NSDate*)date;

+ (NSInteger)monthsFromNowWithDate:(NSDate*)date;

+ (NSInteger)daysFromNowWithDate:(NSDate*)date;

+ (NSInteger)hoursFromNowWithDate:(NSDate*)date;

+ (NSInteger)minutesFromNowWithDate:(NSDate*)date;

+ (NSInteger)secondsFromNowWithDate:(NSDate*)date;

#pragma mark - Compare with date string
/**
 对比两个时间差,返回特定str
 @param dateStr 要对比的时间，格式：yyyy-MM-dd HH:mm:ss
 @return 返回值
 */
+ (NSString*)useNowDateCompareWithDateStr:(NSString*)dateStr;

+ (NSInteger)yearsFromNowWithDateStr:(NSString*)dateStr;

+ (NSInteger)monthsFromNowWithDateStr:(NSString*)dateStr;

+ (NSInteger)daysFromNowWithDateStr:(NSString*)dateStr;

+ (NSInteger)hoursFromNowWithDateStr:(NSString*)dateStr;

+ (NSInteger)minutesFromNowWithDateStr:(NSString*)dateStr;

+ (NSInteger)secondsFromNowWithDateStr:(NSString*)dateStr;

#pragma mark - Conver type

+ (NSString*)stringWithDate:(NSDate*)date formatterType:(NSString*)type;

+ (NSString*)stringWithDateString:(NSString*)dateStr formatterType:(NSString*)type;

#pragma mark - Days form date
+ (NSInteger)getDaysFromDate:(NSDate*)date;
+ (NSInteger)getDaysFromDateStr:(NSString*)dateStr;

@end
