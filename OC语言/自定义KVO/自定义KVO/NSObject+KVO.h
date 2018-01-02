//
//  NSObject+KVO.h
//  自定义KVO
//
//  Created by qiuShan on 2017/12/28.
//  Copyright © 2017年 Fly. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *const kFYKVOClassPrefix = @"FYKVOClassPrefix_";
NSString *const kFYKVOAssociatedObservers = @"FYKVOAssociatedObservers";
/** 监听回调用block */
typedef void(^FYObservingBlock)(id observedObject,
                                NSString *observedKey,
                                id oldValue, id newValue);

@interface NSObject (KVO)

/** 添加观察者 */
- (void)FY_addObserver:(NSObject *)observer
                forKey:(NSString *)key
             withBlock:(FYObservingBlock)block;
/** 移除观察者 */
- (void)FY_removeObserver:(NSObject *)observer
                   forKey:(NSString *)key;

@end
