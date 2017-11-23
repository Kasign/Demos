//
//  FlyOfflineTool.m
//  DownLoadTool
//
//  Created by qiuShan on 2017/11/23.
//  Copyright © 2017年 Fly. All rights reserved.
//

#import "FlyOfflineTool.h"

@interface FlyOfflineTool ()<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession  *  offlineSession;

@property (nonatomic, strong) NSURLSessionDataTask  *  dataTask;

@property (nonatomic, strong) NSMutableDictionary  *  taskDic;


@property (nonatomic, strong) NSOutputStream  *  outStream;

@property (nonatomic, strong) NSFileHandle  *  fileHandle;

@end

@implementation FlyOfflineTool

+ (instancetype)sharedInstance{
    static FlyOfflineTool * _offlineTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _offlineTool = [[FlyOfflineTool alloc] init];
    });
    return _offlineTool;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _taskDic = [NSMutableDictionary dictionary];
        
        NSURLSessionConfiguration * sessionConfi = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSOperationQueue * operationQueue = [[NSOperationQueue alloc] init];
        
        _offlineSession = [NSURLSession sessionWithConfiguration:sessionConfi delegate:self delegateQueue:operationQueue];
        
    }
    return self;
}

- (void)startOfflineWithUrlStr:(NSString*)urlStr{
    
    NSString * offlineStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:offlineStr]];
    
    //设置请求的数据范围：为已下载好的数据到文件结束
    /*
     bytes=0-100
     bytes=500-1000
     bytes=-100 请求文件的前100个字节
     bytes=500- q 请求500之后的所有数据
     */
//    NSString *rangeStr = [NSString stringWithFormat:@"bytes=%zd-", self.curLength];
//    
//    [request setValue:rangeStr forHTTPHeaderField:@"Range"];
    
    NSURLSessionDataTask * dataTask = [_offlineSession dataTaskWithRequest:request];
    
    [dataTask resume];
    
    [_taskDic setObject:dataTask forKey:offlineStr];
}

- (void)pauseTask{
    [self.dataTask suspend];
}

- (void)resumeTask{
    [self.dataTask resume];
}

static NSString * fullPath(NSString * fileName){
    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [documentPath stringByAppendingPathComponent:fileName];
}


#pragma mark - NSURLSessionTaskDelegate
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
    NSLog(@"task->didCompleteWithError -- %@", [NSThread currentThread]);
    NSLog(@"didCompleteWithError:%@",error);
    
    [self.outStream close];
//    [self.fileHandle closeFile];
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    
    completionHandler(NSURLSessionResponseAllow);
    NSLog(@"dataTask->didReceiveResponse -- %@", [NSThread currentThread]);
    
    
    
    NSString * name = response.suggestedFilename;
    
    NSLog(@"%@",fullPath(name));
    
    self.outStream = [NSOutputStream outputStreamToFileAtPath:fullPath(name) append:YES];
    
    [self.outStream open];
    
//    if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath(name)]) {
//        [[NSFileManager defaultManager] createFileAtPath:fullPath(name) contents:[NSData data] attributes:nil];
//    }
//    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:fullPath(name)];
//    [self.fileHandle seekToEndOfFile];

}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask{
    
    NSLog(@"dataTask->didBecomeDownloadTask %@",[NSThread currentThread]);
    NSLog(@"didBecomeDownloadTask");
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeStreamTask:(NSURLSessionStreamTask *)streamTask{
    
    NSLog(@"dataTask->didBecomeStreamTask %@",[NSThread currentThread]);
    NSLog(@"didBecomeStreamTask");
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{
    
    NSLog(@"dataTask->didReceiveData %@",[NSThread currentThread]);
    NSLog(@"返回的data：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSLog(@"dataLength:%ld",data.length);
    
    [self.outStream write:data.bytes maxLength:data.length];
    
//    [self.fileHandle writeData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * _Nullable))completionHandler{
    
    NSLog(@"dataTask->willCacheResponse %@",[NSThread currentThread]);
    NSLog(@"willCacheResponse:%@",proposedResponse.debugDescription);
}



@end
