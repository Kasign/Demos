//
//  ViewController.m
//  JPGChangeToWord
//
//  Created by qiuShan on 2018/2/3.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>

@interface ViewController ()
@property (nonatomic, strong) AFHTTPSessionManager  *  sessionManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fileManager];
}

- (AFHTTPSessionManager *)sessionManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        //设置请求的超时时间
        _sessionManager.requestSerializer.timeoutInterval = 150.f;
        
        //设置服务器返回结果的类型:JSON (AFJSONResponseSerializer,AFHTTPResponseSerializer)
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    });
    
    return _sessionManager;
}

- (void)fileManager
{
    NSString * path =@"/Users/Qiushan/Desktop/PDF图书待转换/图灵程序设计丛书 算法 第4版10.jpg";
    NSData * imageData = [NSData dataWithContentsOfFile:path];
    UIImage * image = [UIImage imageWithData:imageData];

    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:@"WU_FILE_0" forKey:@"id"];
    [params setObject:@(imageData.length) forKey:@"size"];
    [params setObject:path.lastPathComponent forKey:@"name"];
    [params setObject:@"2018/2/3 下午4:24:23" forKey:@"lastModifiedDate"];
    
    NSData *imageJpegData = UIImageJPEGRepresentation(image, 0.6);
    NSString *dataStr = [imageJpegData base64EncodedStringWithOptions:0];
    
    [params setObject:dataStr forKey:@"file"];
    [params setObject:@"image/jpeg" forKey:@"type"];
    
    [self upLoadImageWithParams:params];
}

//id    WU_FILE_0
//name    图灵程序设计丛书 算法 第4版24.jpg
//type    image/jpeg
//lastModifiedDate    2018/2/3 下午4:24:23
//size    88604
//file    图灵程序设计丛书 算法 第4版24.jpg

- (void)upLoadImageWithParams:(NSDictionary *)params
{
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://ocr.wdku.net/Upload"]];
    [self setRequestHeaderWithRequest:request];
    [self setRequestBodyWithRequest:request params:params];
    [request setHTTPMethod:@"POST"];
    
   NSURLSessionDataTask * uplodTask = [self.sessionManager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"current:%lldl",uploadProgress.completedUnitCount);
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"current:%lldl",downloadProgress.completedUnitCount);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"完成  %@",error);
    }];
    
    [uplodTask resume];
}

- (void)setRequestBodyWithRequest:(NSMutableURLRequest *)request params:(NSDictionary *)params
{
    [request setHTTPBody:[self dataWithDictionary:params]];
}

- (NSData *)dataWithDictionary:(NSDictionary *)dictionary
{
    NSData * data = [NSData data];
    NSString * dictionaryStr = [self stringWithDictionary:dictionary];
    if (dictionaryStr.length) {
        data = [dictionaryStr dataUsingEncoding:NSUTF8StringEncoding];
    }
    return data;
}

- (NSString *)stringWithDictionary:(NSDictionary *)dictionary
{
    NSString * result = @"?";
    
    for (NSString * key in dictionary.allKeys) {
        NSString * value = [dictionary valueForKey:key];
        if (value) {
            result = [result stringByAppendingFormat:@"%@=%@&",key,value];
        }
    }
    result = [result substringToIndex:result.length - 1];
    
    return result;
}

- (void)setRequestHeaderWithRequest:(NSMutableURLRequest *)request
{
    request.allHTTPHeaderFields = [self headerDictionary];
}

- (NSDictionary *)headerDictionary
{
    return @{@"refer":@"http://ocr.wdku.net/",
             @"User-Agent" :@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/604.4.7 (KHTML, like Gecko) Version/11.0.2 Safari/604.4.7",
             @"Connection" :@"keep-alive",
             @"Accept-Language":@"zh-cn",
             @"Accept":@"*/*",
             @"DNT":@"1"
             };
}

//Accept-Language    zh-cn
//Accept-Encoding    gzip, deflate
//Content-Type    multipart/form-data; boundary=----WebKitFormBoundaryUKK23dAkFQDHpype
//Origin    http://ocr.wdku.net
//User-Agent    Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/604.4.7 (KHTML, like Gecko) Version/11.0.2 Safari/604.4.7
//Connection    keep-alive
//Referer    http://ocr.wdku.net/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
