//
//  DownloadToolManager.m
//  DownLoadTool
//
//  Created by qiuShan on 2017/11/21.
//  Copyright © 2017年 Fly. All rights reserved.
//

#import "DownloadToolManager.h"
#import <AFNetworking/AFNetworking.h>

@interface DownloadTask()

@property (nonatomic, copy, readwrite) NSString  *  targetPath;

@property (nonatomic, copy, readwrite) NSString  *  downloadUrl;

@property (nonatomic, strong, readwrite) NSDictionary<NSString*,NSString*>  *  downDic;

@end

@implementation DownloadTask

- (instancetype)initWithUrlStr:(NSString*)urlStr targetPath:(NSString*)path
{
    self = [super init];
    if (self) {
        self.downloadUrl = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        self.targetPath = path;
        
        [self.downDic setValue:self.downloadUrl forKey:self.targetPath];
    }
    return self;
}

- (instancetype)initWithDownloadDic:(NSDictionary * )dic
{
    self = [super init];
    if (self) {
        NSMutableDictionary * mutableDic = [NSMutableDictionary dictionary];
        for (NSString * urlStr in dic.allKeys) {
            
            NSString * path = [dic valueForKey:urlStr];
            
            NSString * key = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            
            [mutableDic setValue:path forKey:key];
        }
        self.downDic = [mutableDic copy];
    }
    return self;
}

@end

@interface DownloadToolManager ()

@property (nonatomic, strong) dispatch_queue_t  downloadQueue;
@property (nonatomic, strong) dispatch_queue_t  progressQueue;

@property (nonatomic, strong) AFHTTPSessionManager  *  downloadManager;

@property (nonatomic, strong) DownloadTask  *  task;

@property (nonatomic, strong) NSMutableDictionary<NSString*,NSURLSessionDownloadTask*> *  downloadTaskDic;

@property (nonatomic, strong) NSMutableDictionary   *  progressDic;
@property (nonatomic, assign) NSInteger    finishCount;

@property (nonatomic, assign) CGFloat      totalCount;
@property (nonatomic, assign) CGFloat      currentCount;

@property (nonatomic, copy) void (^progressBlock)(float progress);

@property (nonatomic, copy) void (^completeBlock)(BOOL success,NSError * error);

@end

@implementation DownloadToolManager

- (instancetype)initWithTask:(DownloadTask *)task
{
    self = [super init];
    if (self) {
        
        _downloadTaskDic = [NSMutableDictionary dictionary];
        _progressDic = [NSMutableDictionary dictionary];
        
        _downloadQueue = dispatch_queue_create("downloadQueue", DISPATCH_QUEUE_CONCURRENT);
        _progressQueue = dispatch_queue_create("progressQueue", DISPATCH_QUEUE_SERIAL);
        
        _task = task;
        
        _downloadManager = [self managerInstance];
        AFHTTPResponseSerializer * responseSerializer = [AFHTTPResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"", nil];
        _downloadManager.responseSerializer = responseSerializer;
        
    }
    return self;
}

- (AFHTTPSessionManager*)managerInstance{
    static AFHTTPSessionManager * _manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [AFHTTPSessionManager manager];
    });
    return _manager;
}

- (void)startDownloadTaskWithProgress:(void(^)(float progress))progressBolck completeBlock:(void(^)(BOOL success,NSError * error))completeBlock
{
    _progressBlock = progressBolck;
    _completeBlock = completeBlock;
    
    for (NSString * downUrl in _task.downDic.allKeys) {
        
        NSString * path = [_task.downDic valueForKey:downUrl];
        
        [self circleDownloadWithUrl:downUrl targetPath:path];
    }
}

- (void)circleDownloadWithUrl:(NSString*)urlStr targetPath:(NSString*)path{
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    dispatch_async(_downloadQueue, ^{
        __weak typeof(self) weakSelf = self;
        NSURLSessionDownloadTask * downloadTask = [_downloadManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            
            if (![weakSelf.progressDic.allKeys containsObject:urlStr]) {
                [weakSelf.progressDic setValue:@0 forKey:urlStr];
                [weakSelf resetTotalCount:downloadProgress.totalUnitCount];
            }
            
            [weakSelf refreshDownloadProgress:downloadProgress.completedUnitCount urlStr:urlStr];
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            
            return [NSURL URLWithString:path];
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakSelf.completeBlock) {
                        weakSelf.completeBlock(NO, error);
                    }
                });
            }else{
                weakSelf.finishCount++;
                [weakSelf performSelector:@selector(refreshDownloadState) withObject:nil afterDelay:0.02f];
            }
        }];
        
        [downloadTask resume];
        
        [_downloadTaskDic setObject:downloadTask forKey:urlStr];
    });
}



#pragma mark - reset state
- (void)refreshDownloadState{
    if (self.finishCount == self.task.downDic.allValues.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.completeBlock) {
                self.completeBlock(YES, nil);
            }
        });
    }
}

- (void)resetTotalCount:(CGFloat)newCount{
    self.totalCount += newCount;
}

- (void)refreshDownloadProgress:(CGFloat)progress urlStr:(NSString*)urlStr{
    
    __block typeof(self) weakSelf = self;
    dispatch_async(_progressQueue, ^{
        [weakSelf.progressDic setValue:@(progress) forKey:urlStr];
    });
    
    __block typeof(self) blockSelf = self;
    dispatch_async(_progressQueue, ^{
        blockSelf.currentCount = 0;
        for (NSNumber * num in blockSelf.progressDic.allValues) {
            blockSelf.currentCount += [num floatValue];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (blockSelf.progressBlock) {
                blockSelf.progressBlock(blockSelf.currentCount*1.0/blockSelf.totalCount);
            }
        });
        
    });
}

- (void)pauseDownload
{
    
}

- (void)stopDownload
{
    NSURLSessionDownloadTask * downloadTask = [_downloadTaskDic objectForKey:_task.downloadUrl];
    dispatch_async(_downloadQueue, ^{
        [downloadTask cancel];
    });
    
    for (NSString * key in _task.downDic.allKeys) {
        [_downloadTaskDic removeObjectForKey:key];
    }
    
}

@end
