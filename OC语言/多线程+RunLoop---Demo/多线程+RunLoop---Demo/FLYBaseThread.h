//
//  FLYBaseThread.h
//  多线程+RunLoop---Demo
//
//  Created by Qiushan on 2020/9/10.
//  Copyright © 2020 FLY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYBaseThread : NSObject

- (void)onThread:(id)object;
- (void)addAction:(dispatch_block_t)action;

@end

NS_ASSUME_NONNULL_END
