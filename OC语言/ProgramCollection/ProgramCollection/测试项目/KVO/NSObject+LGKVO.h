//
//  NSObject+LGKVO.h
//  003---自定义KVO
//
//  Created by cooci on 2019/1/5.
//  Copyright © 2019 cooci. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LGKVOBlock)(id observer,NSString *keyPath,id oldValue,id newValue);

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, LGKeyValueObservingOptions) {

    LGKeyValueObservingOptionNew = 0x01,
    LGKeyValueObservingOptionOld = 0x02,
};

@interface LGKVOInfo : NSObject
@property (nonatomic, weak) NSObject    *observer;
@property (nonatomic, copy) NSString    *keyPath;
@property (nonatomic, assign) LGKeyValueObservingOptions options;

- (instancetype)initWitObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(LGKeyValueObservingOptions)options;
@end


@interface NSObject (LGKVO)

- (void)lg_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(LGKeyValueObservingOptions)options context:(nullable void *)context;

- (void)lg_observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context;

- (void)lg_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
