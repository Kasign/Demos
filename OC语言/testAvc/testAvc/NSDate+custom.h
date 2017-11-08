//
//  NSDate+custom.h
//  leci
//
//  Created by 熊文博 on 14-2-28.
//  Copyright (c) 2014年 Leci. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (custom)

#pragma mark - 时间的判断
/**
 判断时间是否为过去、今天、和明天
 */
- (BOOL)isPastDate;
- (BOOL)isDateToday;
- (BOOL)isDateYesterday;

#pragma mark - 获取到特殊时间
/**
 获取当前的北京时间
 */
+ (NSDate *)chinaDate;

/**
 获取当天凌晨0点时间
 
 */
- (NSDate*)midnightDate;

#pragma mark - 将NSDate转换成其他类型
/**
 将dateString转换成指定格式的date
 */
+ (NSDate *)dateWithString:(NSString *)dateString formatString:(NSString *)dateFormatterString;

/**
 将年月日转换成NSDate类型

 */
+ (NSDate *)dateWithYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day;

#pragma mark - 将其他类型转换成NSDate

/**
 将date转换成指定格式的String

 
 */
- (NSString *)formattedDateWithFormatString:(NSString *)dateFormatterString;

/**
 将NSDate类型转换成String类型

 */
- (NSString *)stringFromDate;

/**
 将任何时区的时间都转换成北京时间
 
 @param GMTDate 当地时间
 
 @return 对应的北京时间
 */
+ (NSString *)anyDateToChinaDate:(NSDate *)GMTDate;

#pragma mark - 获取时间差或者其他数据
/**
 得到某年某月有多少天
 */
+ (NSInteger)daysCountForYear:(NSInteger)year Month:(NSInteger)month;

/**
 获取开始计时到目前的毫秒数

 */
- (long long)timeStampSince1970;

/**
 获取从指定时间到目前时间的时间差

 @param date 指定时间
 */
+ (NSTimeInterval)apartTimeIntervalToNowFromDate:(NSDate *)date;
/**
 获取从指定时间到目前时间的时间差
 
 @param dateString 指定时间
 */
+ (NSTimeInterval)apartTimeIntervalToNowFromDateString:(NSString *)dateString;


/**
 指定时间与当前时间的天数间隔 YYYY-MM-DD
 */
+ (NSInteger)getDayIntervalFromDate:(NSDate *)date;


@end
