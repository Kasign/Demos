//
//  DownloadTaskManager.m
//  DownLoadTool
//
//  Created by qiuShan on 2017/11/21.
//  Copyright © 2017年 Fly. All rights reserved.
//

#import "DownloadTaskManager.h"
#import "DownloadToolManager.h"

@implementation DownloadTaskManager

+ (instancetype)sharedInstance{
    static DownloadTaskManager * _taskManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _taskManager = [[DownloadTaskManager alloc] init];
    });
    return _taskManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)addDownloadTask:(DownloadTask*)task
{
    
}

- (void)startDownloadTaskWithProgress:(void(^)(float progress))progress completeBlock:(void(^)(DownloadTask * task,BOOL success,NSError * error))completeBlock{
    
}

- (void)deleteDownloadTask:(DownloadTask*)task
{
    
}

- (void)pauseDownloadTask:(DownloadTask*)task
{
    
}

- (void)deleteAllTasks
{
    
}


@end
