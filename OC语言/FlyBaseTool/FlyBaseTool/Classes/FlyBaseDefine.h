//
//  FlyBaseDefine.h
//  Pods
//
//  Created by Walg on 2024/3/6.
//

#ifndef FlyBaseDefine_h
#define FlyBaseDefine_h

#import "FLYCustomUtil.h"

#ifndef FlyStringFormat
#define FlyStringFormat(format, ...) [NSString stringWithFormat:(format), ##__VA_ARGS__]
#endif


#ifndef FLYNSLog
#if DEBUG
#define FLYNSLog(format, ...) NSLog((format), ##__VA_ARGS__)
#else
#define FLYNSLog(format, ...)
#endif
#endif


//#ifndef LINSLog
//#if DEBUG
//#define LINSLog(...) NSLog(__VA_ARGS__)
//#else
//#define LINSLog(...)
//#endif
//#endif


#ifndef FLYClearLog
#if DEBUG
#define FLYClearLog(format, ...) printf("%s\n", [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])
#else
#define FLYClearLog(format, ...)
#endif
#endif


#ifndef FLYTIMELog
#if DEBUG
#define FLYTIMELog(format, ...) printf("%s  %s\n", [FLYExactTime() UTF8String], [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])
#else
#define FLYTIMELog(format, ...)
#endif
#endif


#endif /* FlyBaseDefine_h */
