//
//  NSFileManager+custom.h
//  leci
//
//  Created by 熊文博 on 14-2-11.
//  Copyright (c) 2014年 Leci. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (custom)

+ (NSString *)docmentDirectory;

+ (NSString *)cacheDiretory;

+ (NSString *)tmpDiretory;

- (long long)fileSizeAtPath:(NSString*)filePath;

- (float)folderSizeAtPath:(NSString*)folderPath;

- (void)folderSizeAtPath:(NSString*)folderPath Block:(void(^)(float size))block;

@end
