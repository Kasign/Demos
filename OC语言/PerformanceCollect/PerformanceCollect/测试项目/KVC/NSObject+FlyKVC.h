//
//  NSObject+FlyKVC.h
//  算法+链表
//
//  Created by Walg on 2020/3/8.
//  Copyright © 2020 Fly. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (FlyKVC)

- (void)fly_setValue:(id)value forKey:(id)key;
- (id)fly_valueForKey:(id)key;

@end

NS_ASSUME_NONNULL_END
