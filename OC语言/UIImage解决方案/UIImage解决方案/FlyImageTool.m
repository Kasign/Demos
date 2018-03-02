//
//  FlyImageTool.m
//  UIImage解决方案
//
//  Created by qiuShan on 2018/3/2.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "FlyImageTool.h"
#import <UIKit/UIKit.h>


@implementation FlyImageTool

- (UIImage *)scaleImage:(UIImage *)image newSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//但处理大分辨率图片时，往往容易出现OOM，原因是-[UIImage drawInRect:]在绘制时，先解码图片，再生成原始分辨率大小的bitmap，这是很耗内存的。解决方法是使用更低层的ImageIO接口，避免中间bitmap产生：

- (UIImage *)scaledImageWithData:(NSData *)data withSieze:(CGSize)size scale:(CGFloat)scale orientation:(UIImageOrientation)orientation
{
    CGFloat maxPixelSize = MAX(size.width, size.height);
    CGImageSourceRef sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)data, nil);
    NSDictionary * options = @{(__bridge id)kCGImageSourceCreateThumbnailFromImageAlways:(__bridge id)kCFBooleanTrue,
                               (__bridge id)kCGImageSourceThumbnailMaxPixelSize:[NSNumber numberWithFloat:maxPixelSize]};
    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(sourceRef, 0, (__bridge CFDictionaryRef)options);
    UIImage * resultImage = [UIImage imageWithCGImage:imageRef scale:scale orientation:orientation];
    CGImageRelease(imageRef);
    CFRelease(sourceRef);
    return resultImage;
}

@end
