//
//  FlyServerManager.m
//  12306自动抢票
//
//  Created by qiuShan on 2018/1/23.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "FlyServerManager.h"
#import <AFNetworking.h>

#define FLY_TIMEOUT   30.f

@interface FlyServerManager ()
@property (nonatomic, strong) AFHTTPSessionManager  *  httpManager;
@end

@implementation FlyServerManager

+ (instancetype)sharedInstanced
{
    static FlyServerManager * serverManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serverManager = [[FlyServerManager alloc] init];
    });
    return serverManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _httpManager = [[AFHTTPSessionManager alloc] init];
        _httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        //设置请求的超时时间
        _httpManager.requestSerializer.timeoutInterval = FLY_TIMEOUT;
        _httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _httpManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        //        _httpManager.securityPolicy.validatesDomainName      = NO;
        //        _httpManager.securityPolicy.allowInvalidCertificates = YES;
        
        _httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
        
    }
    return self;
}

- (void)postDataWithUrlStr:(NSString *)urlStr parameter:(NSString *)parameterStr block:(void(^)(NSDictionary * dataResponse,NSError * error))block
{
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [request setHTTPMethod:@"POST"];
    
    if (parameterStr.length) {
        NSData * parameterData = [parameterStr dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:parameterData];
    }
    
    [self setRequestHeaderWithRequest:request];
    
    NSURLSessionDataTask * dataTask = [_httpManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            if (block) {
                block(responseObject,nil);
            }
        } else {
            if (block) {
                block(nil,error);
            }
        }
    }];
    
    [dataTask resume];
}


- (void)getDataWithUrlStr:(NSString *)urlStr block:(void(^)(NSDictionary * dataResponse,NSError * error))block
{
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [request setHTTPMethod:@"GET"];
    
    [self setRequestHeaderWithRequest:request];
    
    NSURLSessionDataTask * dataTask = [_httpManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            if (block) {
                block(responseObject,nil);
            }
        } else {
            if (block) {
                block(nil,error);
            }
        }
    }];
    
    [dataTask resume];
}

- (void)setRequestBodyWithRequest:(NSMutableURLRequest *)request params:(NSDictionary *)params
{
    [request setHTTPBody:[self dataWithDictionary:params]];
}

- (void)setRequestHeaderWithRequest:(NSMutableURLRequest *)request
{
    request.allHTTPHeaderFields = [self headerDictionary];
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

- (NSDictionary *)headerDictionary
{
    return @{@"refer":@"https://kyfw.12306.cn/otn/leftTicket/init",
             @"User-Agent" :@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Safari/604.1.38",
             @"Connection" :@"keep-alive",
             @"DNT":@"1",
             @"Accept-Language":@"zh-cn",
             @"If-Modified-Since":@"0",
             @"X-Requested-With":@"XMLHttpRequest",
             @"Accept":@"*/*"
             };
}


//
//          Accept: */*
//          X-Requested-With: XMLHttpRequest
//          If-Modified-Since: 0
//          Accept-Language: zh-cn
//          Accept-Encoding: br, gzip, deflate
//          Cache-Control: no-cache
//          Pragma: no-cache
//          User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/604.4.7 (KHTML, like Gecko) Version/11.0.2 Safari/604.4.7
//          Referer: https://kyfw.12306.cn/otn/leftTicket/init
//          DNT: 1
//          Connection: keep-alive

//https://kyfw.12306.cn/otn/leftTicket/queryZ?leftTicketDTO.train_date=2018-02-11&leftTicketDTO.from_station=BJP&leftTicketDTO.to_station=CCT&purpose_codes=ADULT


@end
