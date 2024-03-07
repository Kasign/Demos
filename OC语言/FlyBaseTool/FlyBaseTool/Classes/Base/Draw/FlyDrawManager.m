//
//  FlyDrawManager.m
//  算法+链表
//
//  Created by Walg on 2019/10/25.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "FlyDrawManager.h"

@implementation FlyDrawManager

+ (UIImage *)imageBlackToTransparent:(UIImage *)image color:(UIColor *)color whiteToTransparent:(BOOL)transparent {
    
    // 分配内存
    int imageWidth = image.size.width;
    int imageHeight = image.size.height;
    size_t     bytesPerRow = imageWidth * 4;
    uint32_t *rgbImageBuf = (uint32_t*)malloc(bytesPerRow *imageHeight);
    
    // 创建context
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    //    CGContextTranslateCTM(context, 0, -imageHeight);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t *pCurPtr = rgbImageBuf;
    
    const CGFloat *colorComponents = nil;
    if ([color isKindOfClass:[UIColor class]]) {
        colorComponents = CGColorGetComponents(color.CGColor);
    }
    
    for (int i = 0; i < pixelNum; i++, pCurPtr++) {
        
        if (transparent) {
            if ((*pCurPtr & 0xFFFFFF00) == 0xffffff00) {// 将白色变成透明
                uint8_t *ptr = (uint8_t*)pCurPtr;
                ptr[0] = 0;
            }
        }
        if (color) {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t *ptr = (uint8_t *)pCurPtr;
            ptr[3] = colorComponents[0] * 255.f; //0~255
            ptr[2] = colorComponents[1] * 255.f;
            ptr[1] = colorComponents[2] * 255.f;
        }
        
        NSLog(@"----%d--------", i);
    }
    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage *resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    //    free(rgbImageBuf); //创建dataProvider时已提供释放函数，这里不用free
    return resultUIImage;
}

void ProviderReleaseData (void *info, const void *data, size_t size)
{
    free((void*)data);
}

@end
