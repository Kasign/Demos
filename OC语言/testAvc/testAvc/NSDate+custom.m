//
//  NSDate+custom.m
//  leci
//
//  Created by 熊文博 on 14-2-28.
//  Copyright (c) 2014年 Leci. All rights reserved.
//

#import "NSDate+custom.h"

@implementation NSDate (custom)

+ (NSDate *)chinaDate
{
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    return [[NSDate date] dateByAddingTimeInterval:-localTimeZone.secondsFromGMT+8*60*60];
}

+ (NSDate*)dateWithString:(NSString*)dateString formatString:(NSString*)dateFormatterString {
	if(!dateString)
        return nil;
	
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:dateFormatterString];
	NSDate *theDate = [formatter dateFromString:dateString];
	return theDate;
}

- (NSString *)formattedDateWithFormatString:(NSString *)dateFormatterString {
	if(!dateFormatterString)
        return nil;
	
    NSDateFormatter* formatter =  [[NSDateFormatter alloc] init];
	[formatter setDateFormat:dateFormatterString];
	[formatter setAMSymbol:@"am"];
	[formatter setPMSymbol:@"pm"];
	return [formatter stringFromDate:self];
}

- (BOOL)isPastDate
{
	NSDate* now = [NSDate date];
	if([[now earlierDate:self] isEqualToDate:self]) {
		return YES;
	} else {
		return NO;
	}
}

- (BOOL)isDateToday
{
	return [[[NSDate date] midnightDate] isEqual:[self midnightDate]];
}

- (BOOL)isDateYesterday
{
	return [[[NSDate dateWithTimeIntervalSinceNow:-86400] midnightDate] isEqual:[self midnightDate]];
}

- (NSDate*)midnightDate
{
	return [[NSCalendar currentCalendar] dateFromComponents:[[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self]];
}

+ (NSInteger)daysCountForYear:(NSInteger)year Month:(NSInteger)month
{
    NSInteger count = 0;
    switch(month)
    {
        case 1:count=31;break;
        case 2: {
            if(((year%4==0)&&(year%100!=0))||(year%400==0))
                count=29;
            else
                count=28;
        }break;
        case 3: count=31;break;
        case 4: count=30;break;
        case 5: count=31;break;
        case 6: count=30;break;
        case 7: count=31;break;
        case 8: count=31;break;
        case 9: count=30;break;
        case 10: count=31;break;
        case 11: count=30;break;
        case 12: count=31;break;
    }
    return count;
}

+ (NSDate *)dateWithYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:year];
    [comps setMonth:month];
    [comps setDay:day];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateFromComponents:comps];
}

- (long long)timeStampSince1970
{
    return (long long)([self timeIntervalSince1970]*1000);
}

- (NSString *)stringFromDate
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:self];
    
    return dateString;
}

+ (NSTimeInterval)apartTimeIntervalToNowFromDate:(NSDate *)date
{
    NSDate *createDate = date;
    NSTimeInterval createTime = [createDate timeIntervalSince1970];
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval apartTime = currentTime-createTime;
    return apartTime;
}

+ (NSTimeInterval)apartTimeIntervalToNowFromDateString:(NSString *)dateString
{
    NSDate *createDate = [NSDate dateWithString:dateString formatString:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval createTime = [createDate timeIntervalSince1970];
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval apartTime = currentTime-createTime;
    
    return apartTime;
}

+ (NSString *)anyDateToChinaDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSTimeZone *AsiaTimeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSTimeInterval AsiaInterval = [AsiaTimeZone secondsFromGMT];
    NSDate *GMTDate = [date dateByAddingTimeInterval:-AsiaInterval];
    
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSInteger interval = [timeZone secondsFromGMT];
    NSDate *localdate = [GMTDate dateByAddingTimeInterval:interval];
    NSString *localDateString = [formatter stringFromDate:localdate];
    return localDateString;
}

/**
 指定时间与当前时间的天数间隔 YYYY-MM-DD
 */
+ (NSInteger)getDayIntervalFromDate:(NSDate *)date
{
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate * startDate = [NSDate getCurrentDateYYYYMMDD];
    unsigned int unitFlags = NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:startDate toDate:date options:0];
    NSInteger days = [comps day];
    return days;
    
}

/**
 获取当前时间 年月日时分 yyyy-MM-dd
 */
+ (NSDate *)getCurrentDateYYYYMMDD
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSString *todayTime = [dateFormatter stringFromDate:today];
    return [self stringToDateYYYYMMDD:todayTime];
}

+ (NSDate *)stringToDateYYYYMMDD:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * date = [dateFormatter dateFromString:dateString];
    return date;
}

@end
