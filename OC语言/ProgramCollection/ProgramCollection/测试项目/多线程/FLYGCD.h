//
//  FLYGCD.h
//  多线程+RunLoop---Demo
//
//  Created by Qiushan on 2020/9/10.
//  Copyright © 2020 FLY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FLYThreadType) {
    FLYThreadType_SERIAL     = 0,
    FLYThreadType_CONCURRENT = 1,
};

@interface FLYGCD : NSObject

@property (nonatomic, strong, readonly) dispatch_queue_t queue;
@property (nonatomic, strong, readonly) NSRunLoop      * runLoop;
@property (nonatomic, strong, readonly) NSThread       * thread;

+ (instancetype)threadWithType:(FLYThreadType)threadType;

///异步添加任务
- (void)asyncAddTask:(void(^)(void))task;
///同步添加任务
- (void)syncAddTask:(void(^)(void))task;

/**
 创建新线程并开启runLoop循环
 开启之后，再添加新任务，在runLoop循环按顺序执行
 */
- (void)startRunLoop:(NSString *)threadName;
- (void)stopRunLoop;

@end

NS_ASSUME_NONNULL_END
