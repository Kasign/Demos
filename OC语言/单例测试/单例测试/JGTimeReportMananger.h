//
//  JGTimeReportMananger.h
//  JGEngine
//
//  Created by Walg on 2021/6/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define JGStartRecordClass [[JGTimeReportMananger sharedInstance] startRecordEvent:NSStringFromClass([self class])];

#define JGRecordNode [[JGTimeReportMananger sharedInstance] recordEvent:NSStringFromClass([self class]) nodeKey:NSStringFromSelector(_cmd)];

@interface JGTimeReportMananger : NSObject

+ (instancetype)sharedInstance;
- (void)startRecordEvent:(NSString *)eventStr;
- (void)recordEvent:(NSString *)eventStr nodeKey:(NSString *)nodeKey;
- (NSString *)logAllRecord;
- (void)clearAllRecord;

@end

NS_ASSUME_NONNULL_END
