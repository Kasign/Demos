//
//  NSDate+compare.m
//  
//  Created by FLY on 2017/10/20.
//  Copyright © 2017年 FLY. All rights reserved.
//

#import "NSDate+compare.h"

@implementation NSDate (compare)

#pragma mark - base
+ (NSDateFormatter *)dateFormatterWithType:(NSString*)type{
    
    NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:type];
    return formatter;
}

- (NSInteger)compareWithDate:(NSDate*)date formatter:(NSDateFormatter*)formatter{
    
    NSString *nowStr  = [formatter stringFromDate:self];
    NSString *timeStr = [formatter stringFromDate:date];
    
    NSInteger nowInt  = [nowStr  integerValue];
    NSInteger timInt  = [timeStr integerValue];
    
    return nowInt - timInt;
}

+ (NSInteger)compareWithDateStr:(NSString*)dateStr formatterType:(NSString*)type{
    
    NSDateFormatter  *fullFormatter = [NSDate dateFormatterWithType:kDateFormatterTypeFull];
    
    NSDate  *now = [NSDate date];
    
    NSDateFormatter  *formatter = [NSDate dateFormatterWithType:type];
    
    NSDate  *date = [fullFormatter dateFromString:dateStr];
    
    return [now compareWithDate:date formatter:formatter];
}

+ (NSInteger)compareWithDate:(NSDate*)date formatterType:(NSString*)type{
    
    NSDateFormatter  *formatter = [NSDate dateFormatterWithType:type];
    
    NSDate  *now = [NSDate date];
    
    return [now compareWithDate:date formatter:formatter];
}

#pragma mark - date
+ (NSString*)useNowDateCompareWithDate:(NSDate*)date{
    
    NSInteger years    = [NSDate yearsFromNowWithDate:date];
    NSInteger months   = [NSDate monthsFromNowWithDate:date];
    NSInteger days     = [NSDate daysFromNowWithDate:date];
    NSInteger hours    = [NSDate hoursFromNowWithDate:date];
    NSInteger minutes  = [NSDate minutesFromNowWithDate:date];
    NSInteger senconds = [NSDate secondsFromNowWithDate:date];
    
    if (years > 0) {
        return [NSString stringWithFormat:@"%ld年",years];
    }
    if (months > 0){
        return [NSString stringWithFormat:@"%ld月",months];
    }
    if (days > 0){
        return [NSString stringWithFormat:@"%ld天",days];
    }
    if (hours > 0){
        return [NSString stringWithFormat:@"%ld小时",hours];
    }
    if (minutes > 0){
        return [NSString stringWithFormat:@"%ld分",minutes];
    }
    if (senconds > 0) {
        return [NSString stringWithFormat:@"%ld秒",senconds];
    }
    
    
   
    
    return nil;
}


+ (NSInteger)yearsFromNowWithDate:(NSDate*)date{
    return [NSDate compareWithDate:date formatterType:kDateFormatterTypeYear];
}

+ (NSInteger)monthsFromNowWithDate:(NSDate*)date{
    return [NSDate compareWithDate:date formatterType:kDateFormatterTypeMonth];
}

+ (NSInteger)daysFromNowWithDate:(NSDate*)date{
    return [NSDate compareWithDate:date formatterType:kDateFormatterTypeDay];
}

+ (NSInteger)hoursFromNowWithDate:(NSDate*)date{
    return [NSDate compareWithDate:date formatterType:kDateFormatterTypeHour];
}

+ (NSInteger)minutesFromNowWithDate:(NSDate*)date{
    return [NSDate compareWithDate:date formatterType:kDateFormatterTypeMonth];
}


+ (NSInteger)secondsFromNowWithDate:(NSDate*)date{
    return [NSDate compareWithDate:date formatterType:kDateFormatterTypeSecond];
}

#pragma mark- string
+ (NSString*)useNowDateCompareWithDateStr:(NSString*)dateStr{
    
    NSDateFormatter  *formatter = [NSDate dateFormatterWithType:kDateFormatterTypeFull];
    
    NSDate  *date = [formatter dateFromString:dateStr];
    
    return [NSDate useNowDateCompareWithDate:date];
    
}

+ (NSInteger)yearsFromNowWithDateStr:(NSString*)dateStr{
    return [NSDate compareWithDateStr:dateStr formatterType:kDateFormatterTypeYear];
}

+ (NSInteger)monthsFromNowWithDateStr:(NSString*)dateStr{
    return [NSDate compareWithDateStr:dateStr formatterType:kDateFormatterTypeMonth];
}

+ (NSInteger)daysFromNowWithDateStr:(NSString*)dateStr{
    return [NSDate compareWithDateStr:dateStr formatterType:kDateFormatterTypeDay];
}

+ (NSInteger)hoursFromNowWithDateStr:(NSString*)dateStr{
    return [NSDate compareWithDateStr:dateStr formatterType:kDateFormatterTypeHour];
}

+ (NSInteger)minutesFromNowWithDateStr:(NSString*)dateStr{
    return [NSDate compareWithDateStr:dateStr formatterType:kDateFormatterTypeMinute];
}

+ (NSInteger)secondsFromNowWithDateStr:(NSString*)dateStr{
    return [NSDate compareWithDateStr:dateStr formatterType:kDateFormatterTypeSecond];
}

#pragma mark - conver

+ (NSString*)stringWithDate:(NSDate*)date formatterType:(NSString*)type{
    
    NSDateFormatter  *formatter = [NSDate dateFormatterWithType:type];
    
    return [formatter stringFromDate:date];
}

+ (NSString*)stringWithDateString:(NSString*)dateStr formatterType:(NSString*)type{
    
    NSDateFormatter  *fullFormatter = [NSDate dateFormatterWithType:kDateFormatterTypeFull];
    
    NSDate *targetDate = [fullFormatter dateFromString:dateStr];
    
    NSDateFormatter  *formatter = [NSDate dateFormatterWithType:type];
    
    return [formatter stringFromDate:targetDate];
}

+ (NSInteger)getDaysFromDate:(NSDate*)date{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDate  *startDate = [NSDate dateWithTimeIntervalSinceNow:8*60*60];
    
    NSDateComponents *comps = [calendar components:NSCalendarUnitDay fromDate:startDate toDate:date options:0];
    
    NSInteger days = [comps day];
    
    return days;
    
}
+ (NSInteger)getDaysFromDateStr:(NSString*)dateStr{
    
    NSDateFormatter  *formmatter = [NSDate dateFormatterWithType:kDateFormatterTypeFull];
    
    NSDate  *endDate = [formmatter dateFromString:dateStr];
    
    return [NSDate getDaysFromDate:endDate];
    
}
@end
