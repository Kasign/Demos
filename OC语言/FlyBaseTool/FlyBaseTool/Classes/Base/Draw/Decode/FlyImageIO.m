//
//  FlyImageIO.m
//  FlyImageDecode
//
//  Created by Walg on 2021/5/9.
//

#import "FlyImageIO.h"

@implementation FlyImageIO

+ (UIImage *)decodeImageWithPath:(NSString *)path size:(CGSize)size {
    
    CGImageSourceRef imageSourceRef = [self imageceSourRefWithPath:path];
    
    int scale = [UIScreen mainScreen].scale;
    float maxV = MAX(size.width, size.height) * scale;
    
    CFDictionaryKeyCallBacks keycb = {
        0,
        kCFTypeDictionaryKeyCallBacks.retain,
        kCFTypeDictionaryKeyCallBacks.release,
        kCFTypeDictionaryKeyCallBacks.copyDescription,
        NULL,
        NULL
    };
    
    CFMutableDictionaryRef dicMRef = CFDictionaryCreateMutable(NULL, 0, &keycb, &kCFTypeDictionaryValueCallBacks);
    //如果没有缩略图是否创建一个
    CFDictionarySetValue(dicMRef, kCGImageSourceCreateThumbnailFromImageIfAbsent, kCFBooleanTrue);
    //是否应根据完整图像的方向和像素宽高比旋转和缩放缩略图
    CFDictionarySetValue(dicMRef, kCGImageSourceCreateThumbnailWithTransform, kCFBooleanTrue);
    //是否应该以已解码的形式缓存图像
    CFDictionarySetValue(dicMRef, kCGImageSourceShouldCache, kCFBooleanTrue);
    //指定图像解码和缓存是否应在图像创建时发生
    CFDictionarySetValue(dicMRef, kCGImageSourceShouldCacheImmediately, kCFBooleanTrue);
    //缩略图的最大宽度和高度(以像素为单位)
    CFNumberRef numRef = CFNumberCreate(NULL, kCFNumberFloat32Type, &maxV);
    CFDictionarySetValue(dicMRef, kCGImageSourceThumbnailMaxPixelSize, numRef);
    
    //生成imageRef
    CGImageRef newImageRef = CGImageSourceCreateThumbnailAtIndex(imageSourceRef, 0, dicMRef);
    //转换成image
    UIImage *decodedImage = [[UIImage alloc] initWithCGImage:newImageRef scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(newImageRef);
    CFRelease(dicMRef);
    CFRelease(numRef);
    CFRelease(imageSourceRef);
    
    return decodedImage;
}

@end
