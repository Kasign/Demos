//
//  NSObject+FlyKVO.h
//  算法+链表
//
//  Created by mx-QS on 2019/9/25.
//  Copyright © 2019 Fly. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (FlyKVO)

- (void)fly_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;

@end

NS_ASSUME_NONNULL_END
