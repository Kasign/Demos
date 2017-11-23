//
//  DownloadToolManager.h
//  DownLoadTool
//
//  Created by qiuShan on 2017/11/21.
//  Copyright © 2017年 Fly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadTask : NSObject

- (instancetype)initWithUrlStr:(NSString*)urlStr targetPath:(NSString*)path;

- (instancetype)initWithDownloadDic:(NSDictionary * )dic;

@property (nonatomic, strong , readonly) NSDictionary<NSString*,NSString*>  *  downDic;

@property (nonatomic, copy, readonly) NSString  *  targetPath;

@property (nonatomic, copy, readonly) NSString  *  downloadUrl;



@end

@interface DownloadToolManager : NSObject

- (instancetype)initWithTask:(DownloadTask *)task;

- (void)startDownloadTaskWithProgress:(void(^)(float progress))progress completeBlock:(void(^)(BOOL success,NSError * error))completeBlock;

- (void)pauseDownload;

- (void)stopDownload;

@end
