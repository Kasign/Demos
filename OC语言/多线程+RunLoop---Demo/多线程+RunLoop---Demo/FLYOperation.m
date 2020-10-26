//
//  FLYOperation.m
//  多线程+RunLoop---Demo
//
//  Created by Qiushan on 2020/9/10.
//  Copyright © 2020 FLY. All rights reserved.
//

#import "FLYOperation.h"

@implementation FLYOperation

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self operationQueue];
    }
    return self;
}

- (NSOperationQueue *)operationQueue {
    
    if (_operationQueue == nil) {
        _operationQueue = [[NSOperationQueue alloc] init];
        
        // 方法一 ：用NSInvocationOperation
        
        NSInvocationOperation * invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(onThread:) object:[NSNumber numberWithInteger:0]];
        [_operationQueue addOperation:invocationOperation];
        
        
        // 方法二 ：用NSBlockOperation
//        NSBlockOperation * blockOperation = [NSBlockOperation blockOperationWithBlock:^{
//
//        }];
//        [_operationQueue addOperation:blockOperation];
    }
    return _operationQueue;
}

@end
