//
//  FlyHttpManager.m
//  ccc
//
//  Created by walg on 2017/5/23.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "FlyHttpManager.h"

@interface FlyHttpManager ()

@end

@implementation FlyHttpManager
+(instancetype)sharedInstance{
    static FlyHttpManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FlyHttpManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [AFHTTPSessionManager manager];
        AFHTTPRequestSerializer *requestSerislizer = [AFHTTPRequestSerializer serializer];
        [_manager setRequestSerializer:requestSerislizer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/plain",@"application/x-javascript",nil];
                
        _downLoadManager = [AFHTTPSessionManager manager];
        AFHTTPResponseSerializer *offlineResponseSerislizer = [AFHTTPResponseSerializer serializer];
        _downLoadManager.responseSerializer = offlineResponseSerislizer;
        
    }
    return self;
}

@end
