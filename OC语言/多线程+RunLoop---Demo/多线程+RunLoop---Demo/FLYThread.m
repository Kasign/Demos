//
//  FLYThread.m
//  多线程+RunLoop---Demo
//
//  Created by Qiushan on 2020/9/10.
//  Copyright © 2020 FLY. All rights reserved.
//

#import "FLYThread.h"


@interface FLYThread ()


@end

@implementation FLYThread

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self.thread start];
    }
    return self;
}

- (NSThread *)thread {
    
    if (_thread == nil) {
        _thread = [[NSThread alloc] initWithTarget:self selector:@selector(onThread:) object:self];
    }
    return _thread;
}

@end
