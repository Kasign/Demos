//
//  FLYCustomUtil.m
//  AFNetworking
//
//  Created by Walg on 2025/9/18.
//

#import "FLYCustomUtil.h"

static NSDateFormatter *__LITIME_df = nil;
static dispatch_once_t __LITIME_once;

static inline NSDateFormatter *FLYTimeFormatter(void) {
    dispatch_once(&__LITIME_once, ^{
        __LITIME_df = [[NSDateFormatter alloc] init];
        __LITIME_df.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        __LITIME_df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8 * 3600]; /* GMT+8 */
        __LITIME_df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    });
    return __LITIME_df;
}

NSString *FLYExactTime(void) {
    
    NSDate *nowDate = [NSDate date];
    NSTimeInterval t = [nowDate timeIntervalSince1970];
    double intPart;
    double frac = modf(t, &intPart);
    long frac4 = (long)floor(frac * 1000000.0);
    NSString *nowDateStr = [FLYTimeFormatter() stringFromDate:nowDate];
    NSString *__LITIME_dateStr = [NSString stringWithFormat:@"%@.%ld", nowDateStr, frac4];
    return __LITIME_dateStr;
}

@implementation FLYCustomUtil

@end
