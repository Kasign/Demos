//
//  UserFileManager.m
//  DownLoadTool
//
//  Created by qiuShan on 2017/11/6.
//  Copyright © 2017年 秋山. All rights reserved.
//

#import "UserFileManager.h"

@implementation UserFileManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _manager = [NSFileManager defaultManager];
    }
    return self;
}

- (BOOL)isDirWithPath:(NSString*)path{
    
    BOOL is = [_manager fileExistsAtPath:path];

    return is;
}

- (BOOL)creatDirectoryWithPath:(NSString*)path{
    NSError * error;
    
    BOOL success = [_manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (error && !success) {
        NSLog(@"%@ \n error: %@",NSStringFromSelector(_cmd),error.description);
    }
    
    return success;
}

- (BOOL)creatFileWithFilePath:(NSString*)path fileData:(NSData*)data{
    
    [path stringByExpandingTildeInPath];
    
    BOOL isDir = NO;
    
    BOOL isExist = [_manager fileExistsAtPath:path isDirectory:&isDir];
    
    
    BOOL success = [_manager createFileAtPath:path contents:data attributes:nil];
    
    return success;
    
}



@end
