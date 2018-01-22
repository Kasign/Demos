//
//  PrefixHeader.pch
//  Security
//
//  Created by walg on 2017/1/4.
//  Copyright © 2017年 walg. All rights reserved.
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
