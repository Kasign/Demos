//
//  DownloadTaskManager.h
//  DownLoadTool
//
//  Created by qiuShan on 2017/11/21.
//  Copyright © 2017年 Fly. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DownloadTask;

@interface DownloadTaskManager : NSObject

+ (instancetype)sharedInstance;

- (void)addDownloadTask:(DownloadTask*)task;

- (void)startDownloadTaskWithProgress:(void(^)(float progress))progress completeBlock:(void(^)(DownloadTask * task,BOOL success,NSError * error))completeBlock;

- (void)deleteDownloadTask:(DownloadTask*)task;

- (void)pauseDownloadTask:(DownloadTask*)task;

- (void)deleteAllTasks;

@end
