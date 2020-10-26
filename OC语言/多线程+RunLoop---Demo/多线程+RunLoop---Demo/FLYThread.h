//
//  FLYThread.h
//  多线程+RunLoop---Demo
//
//  Created by Qiushan on 2020/9/10.
//  Copyright © 2020 FLY. All rights reserved.
//

#import "FLYBaseThread.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLYThread : FLYBaseThread

@property (nonatomic, strong) NSThread  *  thread;

@end

NS_ASSUME_NONNULL_END
