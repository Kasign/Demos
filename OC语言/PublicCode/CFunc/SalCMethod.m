//
//  SalCMethod.m
//  Unity-iPhone
//
//  Created by Qiushan on 2021/2/24.
//

#import "SalCMethod.h"
#import "SalStorageStream.h"

/// 判断是否是路径
BOOL SALIsEffectivePath(NSString * path) {
    
    BOOL result = NO;
    if ([path isKindOfClass:[NSString class]] && path.length > 0) {
        NSString * rootPath = [@"~/" stringByExpandingTildeInPath];
        if ([path containsString:rootPath] || [path hasPrefix:@"~/"]) {
            result = YES;
        }
    }
    return result;
}

NSData * SALStreamDataFromFile(NSString * path, SalSaveDataType dataType, NSInteger bytes) {
    
    NSData * resultData = nil;
    if (SALIsEffectivePath(path) && (dataType == SalSaveDataType_DATA || dataType == SalSaveDataType_AUDIO || dataType == SalSaveDataType_UNKNOWN)) {
        path = [path stringByExpandingTildeInPath];
        resultData = [SalStorageStream readDataFromPath:path dataLength:bytes];
        //以后试试能不能改成异步读取
//        if (bytes > 100 * 1024 && 0) {
////            NSLog(@"+++++++++++++++++++++++++++");
////            static dispatch_semaphore_t semaphore;
////            if (semaphore == nil) {
////                semaphore = dispatch_semaphore_create(0);
////            }
////            __block SalInputStream * inputSteam;
////            inputSteam = [SalStorageStream asyReadDataFromPath:path dataLength:bytes runLoop:[SalStorageInstance shareInstance].threadObj.runLoop completion:^(NSData * _Nullable targetData, NSInteger length, NSError * _Nullable error) {
////
////                resultData = targetData;
////                NSLog(@"------>>>>>>%ld %ld %@", targetData.length, length, error);
////                inputSteam = nil;
////                dispatch_semaphore_signal(semaphore);
////            }];
////            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
////            NSLog(@"-->>%@", inputSteam);
////            NSLog(@"读取到的数据：%ld", resultData.length);
//        } else {
//            resultData = [SalStorageStream readDataFromPath:path dataLength:bytes];
//        }
    }
    if (!resultData) {
        NSLog(@"读取失败 %@", path);
    }
    return resultData;
}

BOOL SALWriteDataToFile(NSData * saveData, NSString * path) {
    
    BOOL result = NO;
    if ([saveData isKindOfClass:[NSData class]] && [path isKindOfClass:[NSString class]] && path.length > 0) {
        path = [path stringByExpandingTildeInPath];
        NSInteger writeLength = [SalStorageStream writeDataToPath:path data:saveData];
        if (writeLength == saveData.length) {
            result = YES;
        }
    }
    if (!result) {
        NSLog(@"写入失败 %@ %@", [saveData class], path);
    }
    
    return result;
}

BOOL SALWriteObjectToFile(id saveData, NSString * path) {
    
    NSData * targetData = saveData;
    if ([saveData isKindOfClass:[UIImage class]]) {
        targetData = UIImagePNGRepresentation(saveData);
    }
    return SALWriteDataToFile(targetData, path);
}

id SALReadDataFromFile(NSString * path, SalSaveDataType dataType, NSInteger fileSize) {
    
    id targetData = nil;
    if (SALIsEffectivePath(path)) {
        path = [path stringByExpandingTildeInPath];
        if (dataType == SalSaveDataType_IMAGE) {
            targetData = [UIImage imageWithContentsOfFile:path];
        } else if (dataType == SalSaveDataType_DATA || dataType == SalSaveDataType_AUDIO || dataType == SalSaveDataType_UNKNOWN) {
            if (fileSize > 0) {
                targetData = SALStreamDataFromFile(path, dataType, fileSize);
            } else {
                targetData = [NSData dataWithContentsOfFile:path];
            }
        } else if (dataType == SalSaveDataType_STRING) {
            targetData = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        }
    }
    if (!targetData) {
        NSLog(@"读取失败 %@", path);
    }
    return targetData;
}

BOOL SALRemoveItem(NSString * filePath) {
    
    BOOL result = NO;
    if ([filePath isKindOfClass:[NSString class]] && filePath.length > 0) {
        filePath = [filePath stringByExpandingTildeInPath];
        NSError * error = nil;
        result = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    }
    
    return result;
}

BOOL SALMoveItemToTargetPath(NSString * targetPath, NSString * fromPath) {
    
    BOOL result = NO;
    
    if ([targetPath isKindOfClass:[NSString class]] && [fromPath isKindOfClass:[NSString class]] && targetPath.length > 0 && fromPath.length > 0) {
        
        fromPath   = [fromPath   stringByExpandingTildeInPath];
        targetPath = [targetPath stringByExpandingTildeInPath];
        
        if ([targetPath isEqualToString:fromPath]) {
            result = YES;
        } else {
            //删除目标路径的文件
            if ([[NSFileManager defaultManager] fileExistsAtPath:targetPath]) {
                NSError * removeError = nil;
                if (![[NSFileManager defaultManager] removeItemAtPath:targetPath error:&removeError]) {
                    NSLog(@"1、目标目录存在文件，移除失败\nPath:%@\nError:%@", targetPath, removeError);
                }
            }
            //如果原路径没有文件，返回NO
            if (![[NSFileManager defaultManager] fileExistsAtPath:fromPath]) {
                NSLog(@"2、移动失败，目标文件不存在\nPath:%@\n", fromPath);
                return NO;
            }
            
            NSError * error = nil;
            result = [[NSFileManager defaultManager] moveItemAtPath:fromPath toPath:targetPath error:&error];
            //最后处理
            if (!result) {
                NSLog(@"3-移动文件失败：\n%@", error);
                NSData * fromData = [NSData dataWithContentsOfFile:fromPath];
                if (fromData) {
                    result = [fromData writeToFile:targetPath atomically:YES];
                    if (!result) {
                        NSLog(@"5-文件存在但是写入失败");
                    }
                } else {
                    NSLog(@"4-移动文件失败：\n文件不存在 ：%@", fromPath);
                }
            }
        }
    }
    return result;
}

SalSaveDataType SALDataTypeWithFileName(NSString * fileName) {
    
    SalSaveDataType type = SalSaveDataType_NONE;
    if ([fileName isKindOfClass:[NSString class]]) {
        NSString * pathExtension = fileName.pathExtension;
        pathExtension = pathExtension.lowercaseString;
        if ([pathExtension isEqualToString:@"js"] || [pathExtension isEqualToString:@"txt"]) {
            type = SalSaveDataType_STRING;
        } else if ([pathExtension isEqualToString:@"mp3"]) {
            type = SalSaveDataType_AUDIO;
        } else if ([pathExtension isEqualToString:@"png"] || [pathExtension isEqualToString:@"jpeg"] || [pathExtension isEqualToString:@"jpg"] || [pathExtension isEqualToString:@"gif"]) {
            type = SalSaveDataType_IMAGE;
        } else {
            type = SalSaveDataType_UNKNOWN;
        }
    }
    return type;
}

SalSaveDataType SALDataTypeWithData(id data) {
    
    SalSaveDataType type = SalSaveDataType_NONE;
    if ([data isKindOfClass:[NSDictionary class]]) {
        type = SalSaveDataType_DICTIONARY;
    } else if ([data isKindOfClass:[NSString class]]) {
        type = SalSaveDataType_STRING;
    } else if ([data isKindOfClass:[NSArray class]]) {
        type = SalSaveDataType_ARRAY;
    } else if ([data isKindOfClass:[UIImage class]]) {
        type = SalSaveDataType_IMAGE;
    } else if ([data isKindOfClass:[NSNumber class]]) {
        type = SalSaveDataType_NUMBER;
    } else if ([data isKindOfClass:[NSData class]]) {
        type = SalSaveDataType_DATA;
    } else if ([data isKindOfClass:[NSObject class]]) {
        type = SalSaveDataType_POINTER;
    }
    return type;
}

NSString * SALRandomName() {
    
    NSInteger time = [[NSDate dateWithTimeIntervalSinceNow:8 * 60 * 60] timeIntervalSince1970];
    NSInteger randomNum = arc4random()%10000;
    return [@"a_" stringByAppendingFormat:@"%ld%ld", (long)time, (long)randomNum];
}

NSString * SALConverPath(id currentPath) {
    
    NSString * pathStr = currentPath;
    if ([currentPath isKindOfClass:[NSURL class]]) {
        NSURL * pathUrl = currentPath;
        if ([pathUrl isFileURL]) {
            pathStr = [pathUrl path];
        }
    }
    if ([pathStr isKindOfClass:[NSString class]] && pathStr.length > 0) {
        if ([pathStr hasPrefix:@"file://"]) {
            pathStr = [pathStr substringFromIndex:7];
        } else if ([pathStr hasPrefix:@"~/"]) {
            pathStr = [pathStr stringByExpandingTildeInPath];
        }
    } else {
        pathStr = nil;
    }
    return pathStr;
}

NSString * SALMD5Key(NSString * key) {
    
    return key;
}

BOOL isEffectiveNum(float num) {
    
    if (num == NAN || num == - NAN || num == INFINITY || num == -INFINITY) {
        return NO;
    }
    return YES;
}

CGRect SALManagerRectWithSacle(CGRect rect, CGFloat scale) {
    
    if (scale != 1) {
        rect.origin.x    = rect.origin.x * scale;
        rect.origin.y    = rect.origin.y * scale;
        rect.size.width  = rect.size.width  * scale;
        rect.size.height = rect.size.height * scale;
    }
    return rect;
}

//是否Hor相交
BOOL SALIsIntersectHorizontal(CGRect rect1, CGRect rect2) {
    
    BOOL result   = NO;
    CGFloat minX1 = CGRectGetMinX(rect1);
    CGFloat maxX1 = CGRectGetMaxX(rect1);
    
    CGFloat minX2 = CGRectGetMinX(rect2);
    CGFloat maxX2 = CGRectGetMaxX(rect2);
    
    if (maxX1 > minX2 && minX1 < maxX2 && maxX1 >= minX1 && maxX2 >= minX2) {
        result = YES;
    }
    return result;
}

BOOL SALIsIntersectVertical(CGRect rect1, CGRect rect2) {
    
    BOOL result   = NO;
    CGFloat minY1 = CGRectGetMinY(rect1);
    CGFloat maxY1 = CGRectGetMaxY(rect1);
    
    CGFloat minY2 = CGRectGetMinY(rect2);
    CGFloat maxY2 = CGRectGetMaxY(rect2);
    
    if (maxY1 > minY2 && minY1 < maxY2 && maxY1 >= minY1 && maxY2 >= minY2) {
        result = YES;
    }
    return result;
}

BOOL SALIsIntersectWithRects(CGRect rect1, CGRect rect2) {
    
    BOOL result = NO;
    if (SALIsIntersectHorizontal(rect1, rect2) && SALIsIntersectVertical(rect1, rect2)) {
        result = YES;
    }
    return result;
}

CGFloat ConverNum(CGFloat num) {
    
    num = (int)(num + 0.4999999);
    return num;
}

CGSize SalDirctSize(CGSize size) {
    
    size.width  = ConverNum(size.width);
    size.height = ConverNum(size.height);
    return size;
}

CGPoint SalDirctPoint(CGPoint point) {
    
    point.x = ConverNum(point.x);
    point.y = ConverNum(point.y);;
    return point;
}

CGRect SalDirctRect(CGRect rect) {
    
    rect.size   = SalDirctSize(rect.size);
    rect.origin = SalDirctPoint(rect.origin);
    return rect;
}

BOOL isEffectiveRect(CGRect rect) {

    BOOL result = NO;
    if (isEffectiveNum(rect.origin.x) && isEffectiveNum(rect.origin.y) && isEffectiveNum(rect.size.width) && isEffectiveNum(rect.size.height)) {
        result = YES;
    }
    return  result;
}

