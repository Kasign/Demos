//
//  FlyNativeDownloadManager.m
//  DownLoadTool
//
//  Created by qiuShan on 2017/11/22.
//  Copyright © 2017年 Fly. All rights reserved.
//

#import "FlyNativeDownloadManager.h"

@interface FlyNativeDownloadManager ()<NSURLSessionDownloadDelegate,NSURLSessionDataDelegate>

@property (nonatomic, strong) NSMutableDictionary  *  downloadTaskDic;

@end

@implementation FlyNativeDownloadManager

+ (instancetype)sharedInstance{
    static FlyNativeDownloadManager * _manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[FlyNativeDownloadManager alloc] init];
    });
    return _manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _downloadTaskDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)startDownload{
    //    [self getUrl];
    //    [self postUrl];
    //    [self postWithDelegate];
//    [self startDownloadWithDelegate];
    
    [self startDataTaskWithDelegate];
}

- (void)startDataTaskWithDelegate{
    
    NSString * downloadStr = @"http://120.25.226.186:32812/resources/videos/minion_01.mp4";
    
    NSURLSessionConfiguration * sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSOperationQueue * sessionQueue = [[NSOperationQueue alloc] init];
    
    NSURLSession * session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:sessionQueue];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:downloadStr]];
    
    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:request];
    
    [dataTask resume];
    
}

- (void)startDownloadWithDelegate{
    //    https://www.tunnelblick.net/release/Tunnelblick_3.7.4_build_4900.dmg
    //    http://img5.imgtn.bdimg.com/it/u=4146227749,2786900840&fm=27&gp=0.jpg
    //    http://120.25.226.186:32812/resources/videos/minion_01.mp4
    NSString * downloadStr = @"http://120.25.226.186:32812/resources/videos/minion_01.mp4";
    
    NSURLSessionConfiguration * sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSOperationQueue * sessionQueue = [[NSOperationQueue alloc] init];
    
    NSURLSession * session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:sessionQueue];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:downloadStr]];
    
    
    NSURLSessionDownloadTask * downloadTask = [session downloadTaskWithRequest:request];
    
    
    [_downloadTaskDic setObject:downloadTask forKey:downloadTask.originalRequest.URL.absoluteString];
    
    [downloadTask resume];
}


- (void)getUrl{
    //确定请求路径
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login?username=520&pwd=520&type=JSON"];
    //创建 NSURLSession 对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:
                                      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                          
                                          //解析服务器返回的数据
                                          NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                          //默认在子线程中解析数据
                                          NSLog(@"%@", [NSThread currentThread]);
                                      }];
    //发送请求（执行Task）
    [dataTask resume];
    
}

- (void)postUrl{
    //确定请求路径
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login"];
    //创建可变请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //修改请求方法
    request.HTTPMethod = @"POST";
    //设置请求体
    request.HTTPBody = [@"username=520&pwd=520&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
    //创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    //创建请求 Task
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:
                                      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                          
                                          //解析返回的数据
                                          NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                                      }];
    
    //发送请求
    [dataTask resume];
    
}

- (void)postWithDelegate{
    //确定请求路径
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login"];
    //创建可变请求对象
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:url];
    //设置请求方法
    requestM.HTTPMethod = @"POST";
    //设置请求体
    requestM.HTTPBody = [@"username=520&pwd=520&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
    //创建会话对象，设置代理
    /**
     第一个参数：配置信息
     第二个参数：设置代理
     第三个参数：队列，如果该参数传递nil 那么默认在子线程中执行
     */
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    //创建请求 Task
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:requestM];
    //发送请求
    [dataTask resume];
}

#pragma mark - NSURLSessionTaskDelegate
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
    NSLog(@"task->didCompleteWithError -- %@", [NSThread currentThread]);
    NSLog(@"didCompleteWithError:%@",error);
}

#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    
    NSLog(@"downloadTask->didFinishDownloadingToURL -- %@", [NSThread currentThread]);
    NSLog(@"location:%@",location.absoluteString);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    NSLog(@"downloadTask->didWriteData -- %@", [NSThread currentThread]);
    NSLog(@"bytesWritten:%lld totalBytesWritten:%lld totalBytesExpectedToWrite:%lld",bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
    
    NSLog(@"downloadTask->didResumeAtOffset %@",[NSThread currentThread]);
    NSLog(@"fileOffset:%lld expectedTotalBytes:%lld",fileOffset,expectedTotalBytes);
}


#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    
    NSLog(@"dataTask->didReceiveResponse -- %@", [NSThread currentThread]);
    completionHandler(NSURLSessionResponseAllow);
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
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * _Nullable))completionHandler{
    
    NSLog(@"dataTask->willCacheResponse %@",[NSThread currentThread]);
    NSLog(@"willCacheResponse:%@",proposedResponse.debugDescription);
}


@end
