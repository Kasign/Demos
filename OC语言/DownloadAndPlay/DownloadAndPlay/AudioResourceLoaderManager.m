//
//  AudioResourceLoaderManager.m
//  Unity-iPhone
//
//  Created by qiuShan on 2018/1/11.
//

#import "AudioResourceLoaderManager.h"

@interface AudioResourceLoaderManager ()<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession  *  offlineSession;

@property (nonatomic, strong) NSURLSessionDataTask  *  dataTask;

@property (nonatomic, strong) NSMutableDictionary  *  taskDic;


@property (nonatomic, strong) NSOutputStream  *  outStream;

@property (nonatomic, strong) NSFileHandle  *  fileHandle;

@property (nonatomic, copy) NSString  *  fileName;

@end

@implementation AudioResourceLoaderManager

+ (instancetype)sharedInstance
{
    static AudioResourceLoaderManager * _offlineTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _offlineTool = [[AudioResourceLoaderManager alloc] init];
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

- (void)startOfflineWithUrlStr:(NSString*)urlStr
{
    NSString * offlineStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:offlineStr]];
    
    //设置请求的数据范围：为已下载好的数据到文件结束
    /*
     bytes=0-100
     bytes=500-1000
     bytes=-100 请求文件的前100个字节
     bytes=500- q 请求500之后的所有数据
     */
    NSString *rangeStr = [NSString stringWithFormat:@"bytes=0-"];
    
    [request setValue:rangeStr forHTTPHeaderField:@"Range"];
    
    NSURLSessionDataTask * dataTask = [_offlineSession dataTaskWithRequest:request];
    
    [dataTask resume];
    
    [_taskDic setObject:dataTask forKey:offlineStr];
}

- (void)pauseTask
{
    [self.dataTask suspend];
}

- (void)resumeTask
{
    [self.dataTask resume];
}

#pragma mark - NSURLSessionTaskDelegate
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"task->didCompleteWithError -- %@", [NSThread currentThread]);
    NSLog(@"didCompleteWithError:%@",error);
    
    if (self.outStream) {
        [self.outStream close];
    }
    
    if (self.fileHandle) {
        [self.fileHandle closeFile];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(resourceLoader:finishReciveDataWithPath:request:)]) {
        [_delegate resourceLoader:self finishReciveDataWithPath:fullPath(_fileName) request:task.currentRequest];
    }
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    completionHandler(NSURLSessionResponseAllow);
    NSLog(@"dataTask->didReceiveResponse -- %@", [NSThread currentThread]);
    
    NSString * name = response.suggestedFilename;
    
    NSLog(@"%@",fullPath(name));
    _fileName = name;
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath(@"")]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:fullPath(@"") withIntermediateDirectories:YES attributes:nil error:nil];
    }
    self.outStream = [NSOutputStream outputStreamToFileAtPath:fullPath(name) append:NO];
    [self.outStream open];
    
//    if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath(name)]) {
//        [[NSFileManager defaultManager] createFileAtPath:fullPath(name) contents:[NSData data] attributes:nil];
//    }

//    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:fullPath(name)];
//    [self.fileHandle seekToEndOfFile];
    
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    NSLog(@"dataTask->didBecomeDownloadTask %@",[NSThread currentThread]);
    NSLog(@"didBecomeDownloadTask");
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeStreamTask:(NSURLSessionStreamTask *)streamTask
{
    NSLog(@"dataTask->didBecomeStreamTask %@",[NSThread currentThread]);
    NSLog(@"didBecomeStreamTask");
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    NSLog(@"dataTask->didReceiveData %@",[NSThread currentThread]);
    NSLog(@"返回的data：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSLog(@"dataLength:%ld",data.length);
    
    if (self.outStream) {
        [self.outStream write:data.bytes maxLength:data.length];
    }
    if (self.fileHandle) {
        [self.fileHandle writeData:data];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(resourceLoader:shouldStartPlayWithPath:request:)]) {
        if (_fileName.length) {
            [_delegate resourceLoader:self shouldStartPlayWithPath:fullPath(_fileName) request:dataTask.currentRequest];
        }
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * _Nullable))completionHandler{
    
    NSLog(@"dataTask->willCacheResponse %@",[NSThread currentThread]);
    NSLog(@"willCacheResponse:%@",proposedResponse.debugDescription);
}


@end
