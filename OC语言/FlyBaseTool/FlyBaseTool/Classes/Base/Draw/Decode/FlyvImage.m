//
//  FlyVImage.m
//  FlyImageDecode
//
//  Created by Walg on 2021/5/9.
//

#import "FlyvImage.h"
#import <Accelerate/Accelerate.h>

@implementation FlyvImage

// 为了方便，我们首先直接定义好ARGB8888的format结构体，后续需要多次使用
static vImage_CGImageFormat vImageFormatARGB8888 = (vImage_CGImageFormat) {
    .bitsPerComponent = 8, // 8位
    .bitsPerPixel = 32, // ARGB4通道，4*8
    .colorSpace = NULL, // 默认就是sRGB
    .bitmapInfo = kCGImageAlphaFirst | kCGBitmapByteOrder32Big, // 表示ARGB
    .version = 0, // 或许以后会有版本区分，现在都是0
    .decode = NULL, // 和`CGImageCreate`的decode参数一样，可以用来做色彩范围映射的，NULL就是[0, 1.0]
    .renderingIntent = kCGRenderingIntentDefault, // 和`CGImageCreate`的intent参数一样，当色彩空间超过后如何处理
};

// RGB888的format结构体
static vImage_CGImageFormat vImageFormatRGB888 = (vImage_CGImageFormat) {
    .bitsPerComponent = 8, // 8位
    .bitsPerPixel = 24, // RGB3通道，3*8
    .colorSpace = NULL,
    .bitmapInfo = kCGImageAlphaNone | kCGBitmapByteOrder32Big, // 表示RGB
    .version = 0,
    .decode = NULL,
    .renderingIntent = kCGRenderingIntentDefault,
};

// 字节对齐使用，vImage如果不是64字节对齐的，会有额外开销
static inline size_t vImageByteAlign(size_t size, size_t alignment) {
    return ((size + (alignment - 1)) / alignment) * alignment;
}

+ (UIImage *)decodeImageWithPath:(NSString *)path size:(CGSize)size {
    
    CGImageRef imageRef = [self imageRefWithPath:path];
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    float maxSize = fmax(imageSize.width, imageSize.height);
    size.width = size.width * imageSize.width / maxSize;
    size.height = size.height * imageSize.height / maxSize;
    
    //创建两个buffer
    vImage_Buffer a_buffer = {}, output_buffer = {};
    output_buffer.width = size.width * [UIScreen mainScreen].scale;
    output_buffer.height = size.height * [UIScreen mainScreen].scale;
    output_buffer.rowBytes = vImageByteAlign(output_buffer.width * 4, 64);
    output_buffer.data = malloc(output_buffer.rowBytes * output_buffer.height);
    
    vImage_Error a_ret;
    //将图片绘制到缓冲区
    a_ret = vImageBuffer_InitWithCGImage(&a_buffer, &vImageFormatARGB8888, NULL, imageRef, kvImageNoFlags);
    if (a_ret != kvImageNoError) return NULL;
    //将缓冲区数据重新写入到指定大小的缓冲区
    a_ret = vImageScale_ARGB8888(&a_buffer, &output_buffer, NULL, kvImageNoFlags);
    if (a_ret != kvImageNoError) return NULL;
    
    //生成CGImageRef
    CGImageRef outputImage = vImageCreateCGImageFromBuffer(&output_buffer, &vImageFormatARGB8888, NULL, NULL, kvImageNoFlags, &a_ret);
    
    if (a_ret != kvImageNoError) {
        return NULL;
    }
    //生成UIImage
    UIImage *resultImg = [UIImage imageWithCGImage:outputImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    //释放
    CGImageRelease(imageRef);
    CGImageRelease(outputImage);
    if (a_buffer.data) free(a_buffer.data);
    if (output_buffer.data) free(output_buffer.data);
    
    return resultImg;
}

/**
 
 func resizedImage(at url: URL, for size: CGSize) -> UIImage? {
     // Decode the source image
     guard let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
         let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil),
         let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any],
         let imageWidth = properties[kCGImagePropertyPixelWidth] as? vImagePixelCount,
         let imageHeight = properties[kCGImagePropertyPixelHeight] as? vImagePixelCount
     else {
         return nil
     }

     // Define the image format
     var format = vImage_CGImageFormat(bitsPerComponent: 8,
                                       bitsPerPixel: 32,
                                       colorSpace: nil,
                                       bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
                                       version: 0,
                                       decode: nil,
                                       renderingIntent: .defaultIntent)

     var error: vImage_Error

     // Create and initialize the source buffer
     var sourceBuffer = vImage_Buffer()
     defer { sourceBuffer.data.deallocate() }
     error = vImageBuffer_InitWithCGImage(&sourceBuffer,
                                          &format,
                                          nil,
                                          image,
                                          vImage_Flags(kvImageNoFlags))
     guard error == kvImageNoError else { return nil }

     // Create and initialize the destination buffer
     var destinationBuffer = vImage_Buffer()
     error = vImageBuffer_Init(&destinationBuffer,
                               vImagePixelCount(size.height),
                               vImagePixelCount(size.width),
                               format.bitsPerPixel,
                               vImage_Flags(kvImageNoFlags))
     guard error == kvImageNoError else { return nil }

     // Scale the image
     error = vImageScale_ARGB8888(&sourceBuffer,
                                  &destinationBuffer,
                                  nil,
                                  vImage_Flags(kvImageHighQualityResampling))
     guard error == kvImageNoError else { return nil }

     // Create a CGImage from the destination buffer
     guard let resizedImage =
         vImageCreateCGImageFromBuffer(&destinationBuffer,
                                       &format,
                                       nil,
                                       nil,
                                       vImage_Flags(kvImageNoAllocate),
                                       &error)?.takeRetainedValue(),
         error == kvImageNoError
     else {
         return nil
     }

     return UIImage(cgImage: resizedImage)
 }
 
 */

@end
