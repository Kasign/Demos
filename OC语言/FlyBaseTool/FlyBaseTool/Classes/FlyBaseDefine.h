//
//  FlyBaseDefine.h
//  Pods
//
//  Created by Walg on 2024/3/6.
//

#ifndef FlyBaseDefine_h
#define FlyBaseDefine_h

#ifndef FlyStringFormat
#define FlyStringFormat(format, ...) [NSString stringWithFormat:(format), ##__VA_ARGS__]
#endif


#ifndef FLYAccurateLog
#if DEBUG
#define FLYAccurateLog(format, ...) NSLog((format), ##__VA_ARGS__)
#else
#define FLYAccurateLog(format, ...)
#endif
#endif

#ifndef FLYLog
#if DEBUG
#define FLYLog(format, ...) printf("%s  %s\n", [[NSString stringWithFormat:@"%@", [NSDate dateWithTimeIntervalSinceNow:8.0 * 60 * 60]] UTF8String], [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])
#else
#define FLYLog(format, ...)
#endif
#endif

#ifndef FLYClearLog
#if DEBUG
#define FLYClearLog(format, ...) printf("%s\n", [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])
#else
#define FLYClearLog(format, ...)
#endif
#endif


#endif /* FlyBaseDefine_h */
