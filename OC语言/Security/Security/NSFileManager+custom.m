//
//  PrefixHeader.pch
//  Security
//
//  Created by walg on 2017/1/4.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "NSFileManager+custom.h"

@implementation NSFileManager (custom)

+ (NSString *)docmentDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)cacheDiretory
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)tmpDiretory
{
    return NSTemporaryDirectory();
}

//单个文件的大小
- (long long)fileSizeAtPath:(NSString*)filePath{
    if ([self fileExistsAtPath:filePath]){
        return [[self attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float)folderSizeAtPath:(NSString*)folderPath{
    if (![self fileExistsAtPath:folderPath])
        return 0;
    NSEnumerator *childFilesEnumerator = [[self subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1000.0*1000.0);
}

- (void)folderSizeAtPath:(NSString*)folderPath Block:(void(^)(float size))block
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        float size = [self folderSizeAtPath:folderPath];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(size);
            }
        });
    });
}

@end
