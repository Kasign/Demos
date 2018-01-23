//
//  FlyHttpClient.m
//  12306自动抢票
//
//  Created by qiuShan on 2018/1/23.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "FlyHttpClient.h"
#import "FlyRequestObject.h"
#import "FlyResponseObject.h"
#import "FlyServerManager.h"

@interface FlyHttpClient()

@property (nonatomic, copy) NSString  *  hostUrl;

@property (nonatomic, strong, readwrite) NSMutableDictionary  *  cacheDic;

@end


@implementation FlyHttpClient

+(instancetype)sharedInstance
{
    static FlyHttpClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[FlyHttpClient alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cacheDic = [NSMutableDictionary dictionary];
        _hostUrl = @"https://kyfw.12306.cn/";
    }
    return self;
}

- (void)getDataWithRequest:(FlyRequestObject*)request block:(void (^)(FlyResponseObject *, NSError *))block{
    
    [self getBasicDataWithRequest:request block:^(NSDictionary * _Nullable dataDict, NSError * _Nullable error) {
        if(!error&&dataDict){
            FlyResponseObject *object = [NSClassFromString([request responseObjectClass]) responseWithJsonObject:dataDict];
            if (block) {
                block(object,nil);
            }
        }else{
            if (block) {
                block(nil,error);
            }
        }
    }];
}

-(void)postDataWithRequest:(FlyRequestObject *)request block:(void (^)(FlyResponseObject *, NSError *))block{
    
    [self postBasicDataWithRequest:request block:^(NSDictionary * _Nullable dataDict, NSError * _Nullable error) {
        if(!error&&dataDict){
            FlyResponseObject *object = [NSClassFromString([request responseObjectClass]) responseWithJsonObject:dataDict];
            if (object) {
                [self.dataDic setObject:object forKey:request.api];
            }
            if (block) {
                block(object,nil);
            }
        }else{
            if (block) {
                block(nil,error);
            }
        }
    }];
}

- (void)getBasicDataWithRequest:(FlyRequestObject *)request block:(void(^)(NSDictionary * _Nullable dataDict,NSError * _Nullable error))block{
    
    NSString *  url = [NSString stringWithFormat:@"%@%@%@",_hostUrl,request.api,[self stringWithDic:[request dictionaryValue]]];
    
    NSLog(@"**********GET url:%@",url);
    
    [[FlyServerManager sharedInstanced] getDataWithUrlStr:url block:^(NSDictionary * dataResponse, NSError *error) {
        if (!error) {
            if (block) {
                block(dataResponse,nil);
            }
        }else{
            if (block) {
                block(nil,error);
            }
        }
    }];
}

- (void)postBasicDataWithRequest:(FlyRequestObject*)request block:(void(^)(NSDictionary * _Nullable dataDict,NSError * _Nullable error))block{
    
    NSString *  url = [NSString stringWithFormat:@"%@%@",_hostUrl,request.api];
    
    NSString * parameter = [self stringWithDic:[request dictionaryValue]];
    
    NSLog(@"**********POST url:%@ \n parameter:%@",url,parameter);
    
    [[FlyServerManager sharedInstanced] postDataWithUrlStr:url parameter:parameter block:^(NSDictionary * dataResponse, NSError *error) {
        if (!error) {
            if (block) {
                block(dataResponse,nil);
            }
        }else{
            if (block) {
                block(nil,error);
            }
        }
    }];
}


#pragma mark - 将字典转换成字符串
-(NSString *)stringWithDic:(NSDictionary*)dic
{
    if (![dic isKindOfClass:[NSDictionary class]] || dic.allKeys.count == 0 || dic.allValues.count==0) {
        return nil;
    }
    
    NSString * dicString = @"?";
    if ([_hostUrl containsString:@"?"]) {
        dicString = @"&";
    }
    
    for (int i=0; i < dic.allKeys.count; i++) {
        NSString * key = [dic.allKeys objectAtIndex:i];
        NSString * value = [dic objectForKey:key];
        NSString * str = [NSString stringWithFormat:@"%@=%@&",key,value];
        dicString = [dicString stringByAppendingString:str];
    }
    
    NSString *resultStr;
    
    if ([dicString hasSuffix:@"&"]) {
        resultStr = [dicString substringToIndex:dicString.length-1];
    }else{
        resultStr = dicString;
    }
    
    return resultStr;
}

@end
