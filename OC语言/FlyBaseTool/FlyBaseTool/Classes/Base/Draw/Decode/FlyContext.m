//
//  FlyContext.m
//  FlyImageDecode
//
//  Created by Walg on 2021/5/9.
//

#import "FlyContext.h"
typedef uint8_t    SAL_Pixel_8888[4];

typedef struct {
    
    size_t imageRefScale;        ///图片的缩放比
    size_t imageRefWidth;        ///宽 绘制时的宽，获取显示时的width需要除scale
    size_t imageRefHeight;       ///高 绘制时的高，获取显示时的height需要除scale
    size_t bitsPerComponent;     ///Returns the number of bits allocated for a single color component of a bitmap image. 颜色中每个分量（包括alpha）值占用比特位数(bits)，一般为占用8位  （eg:RGBA 每个占用8bits，总共 4 * 8 = 32）
    size_t bitsPerPixel;         ///Returns the number of bits allocated for a single pixel in a bitmap image. 每个像素点占用比特位数(bits)，一般为32位，4个字节(1字节 = 8位)
    size_t bytesPerRow;          ///Returns the number of bytes allocated for a single row of a bitmap image. 每行字节数
    size_t componentsPerPixel;   ///bitsPerPixel / bitsPerComponent 每个像素点中颜色值分量数，一般为4个RGBA(顺序不确定)
    size_t bytesPerPixel;        ///bitsPerPixel/8  每个像素点占用字节数，一般为4 (bitsPerComponent = 8的情况下)
    size_t pixelPerRow;          ///每行总像素点 (准确算法：8 * bytesPerRow / bitsPerPixel 如果 bitsPerComponent = 8，可转换为bytesPerRow / componentsPerPixel)
    size_t pixelNum;             ///总像素点，每个像素点占位数bitsPerPixel，一般为32位
} SAL_ImageInfoStruct;

@implementation FlyContext

+ (CGColorSpaceRef)colorSpaceGetDeviceRGB {
#if SD_MAC
    CGColorSpaceRef screenColorSpace = NSScreen.mainScreen.colorSpace.CGColorSpace;
    if (screenColorSpace) {
        return screenColorSpace;
    }
#endif
    static CGColorSpaceRef colorSpace;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#if SD_UIKIT
        if (@available(iOS 9.0, tvOS 9.0, *)) {
            colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceSRGB);
        } else {
            colorSpace = CGColorSpaceCreateDeviceRGB();
        }
#else
        colorSpace = CGColorSpaceCreateDeviceRGB();
#endif
    });
    return colorSpace;
}

+ (UIImage *)decodeImageWithPath:(NSString *)path size:(CGSize)size {
    
    CGImageRef imageRef = [self imageRefWithPath:path];
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    float maxSize = fmax(imageSize.width, imageSize.height);
    size.width = size.width * imageSize.width / maxSize;
    size.height = size.height * imageSize.height / maxSize;
    int scale = [UIScreen mainScreen].scale;
    //BGRA
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedFirst;
    //创建上下文
    CGContextRef contextRef = CGBitmapContextCreate(nil, size.width * scale, size.height * scale, 8, 0, [self colorSpaceGetDeviceRGB], bitmapInfo);
    //绘制图片到当前上下文
    CGContextDrawImage(contextRef, CGRectMake(0, 0, size.width * scale, size.height * scale), imageRef);
    //根据当前上下文生成图片
    CGImageRef newImageRef = CGBitmapContextCreateImage(contextRef);
    UIImage *decodedImage = [[UIImage alloc] initWithCGImage:newImageRef scale:scale orientation:UIImageOrientationUp];
    CGContextRelease(contextRef);
    CGImageRelease(imageRef);
    CGImageRelease(newImageRef);

    return decodedImage;
}

#pragma mark 由imageRef转变成Image
UIImage * SAL_ImageWithImageRef(CGImageRef imageRef, CGFloat scale, UIImageOrientation orientation) {
    
    UIImage * targetImage = nil;
    if (imageRef != NULL) {
        targetImage = [UIImage imageWithCGImage:imageRef scale:scale orientation:orientation];
    }
    return targetImage;
}

#pragma mark 生成ImageRef 方式一 CGBitmapContextCreateImage
CGImageRef SAL_ImageRefWithContext(CGContextRef context) {
    
    CGImageRef targetRef = CGBitmapContextCreateImage(context);
    return targetRef;
}

#pragma mark 生成ImageRef 方式二 CGDataProviderCreateWithData
CGImageRef SAL_ImageRefWithBufferData(SAL_Pixel_8888 * currentBuffer, SAL_ImageInfoStruct drawStruct, CGBitmapInfo bitmapInfo, CGColorSpaceRef colorSpace) {
    
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, currentBuffer, drawStruct.bytesPerPixel * drawStruct.pixelNum, SAL_ProviderReleaseData);
    
    CGImageRef imageRef = CGImageCreate(drawStruct.imageRefWidth, drawStruct.imageRefHeight, drawStruct.bitsPerComponent, drawStruct.bitsPerPixel, drawStruct.bytesPerRow, colorSpace, bitmapInfo, dataProvider, NULL, NO, kCGRenderingIntentDefault);//kCGRenderingIntentDefault
    
    return imageRef;
}

void SAL_ProviderReleaseData(void * info, const void * data, size_t size) {
    
    if (data != NULL) {
        free((void*)data);
    }
    if (info != NULL) {
        free(info);
    }
}

#pragma mark 生成ImageRef 方式三 CGDataProviderCreateDirect
CGImageRef SAL_ImageRefWithBufferDirect(SAL_Pixel_8888 * currentBuffer, SAL_ImageInfoStruct drawStruct, CGBitmapInfo bitmapInfo, CGColorSpaceRef colorSpace) {
    
    CGDataProviderDirectCallbacks providerCallbacks = {0, SAL_GetBytePointer, SAL_ReleaseBytePointer, SAL_GetBytesAtPosition, SAL_ProviderReleaseInfoCallback};
    
    CGDataProviderRef dataProvider = CGDataProviderCreateDirect(currentBuffer, drawStruct.bytesPerPixel * drawStruct.pixelNum, &providerCallbacks);
    
    CGImageRef imageRef = CGImageCreate(drawStruct.imageRefWidth, drawStruct.imageRefHeight, drawStruct.bitsPerComponent, drawStruct.bitsPerPixel, drawStruct.bytesPerRow, colorSpace, bitmapInfo, dataProvider, NULL, NO, kCGRenderingIntentDefault);//kCGRenderingIntentDefault
    
    CGDataProviderRelease(dataProvider);
    
    return imageRef;
}

const void * SAL_GetBytePointer(void * info) {
    
    NSLog(@"SAL_GetBytePointer %p", info);
    // this is currently only called once
    return info; // info is a pointer to the buffer
}

void SAL_ReleaseBytePointer(void * info, const void * pointer) {
    // don't care, just using the one static buffer at the moment
    NSLog(@"SAL_ReleaseBytePointer %p %p", info, pointer);
}

size_t SAL_GetBytesAtPosition(void * info, void * buffer, off_t position, size_t count) {
    
    NSLog(@"SAL_GetBytesAtPosition %p %lld %zu", info, position, count);
    // I don't think this ever gets called
//    memcpy(buffer, ((char*)info) + position, count);
    return count;
}

void SAL_ProviderReleaseInfoCallback(void * __nullable info) {
    
    NSLog(@"SAL_ProviderReleaseInfoCallback %p", info);
}

#pragma mark 生成ImageRef 方式四 CGDataProviderCreateSequential
//size_t SAL_ProviderGetBytesCallback(void * __nullable info, void * buffer, size_t count) {
//
//    return [(__bridge SAL_Steam *)info getBytes:buffer bytes:count];
//}
//
//off_t SAL_ProviderSkipForwardCallback(void * __nullable info, off_t count) {
//
//    return [(__bridge SAL_Steam *)info skipForwardBytes:count];
//}
//
//void SAL_ProviderRewindCallback(void * __nullable info) {
//
//    return [(__bridge SAL_Steam *)info rewind];
//}
//
//CGImageRef SAL_ProviderRefWithBufferSequential(SAL_Steam * stream, SAL_ImageInfoStruct drawStruct) {
//
//    CGDataProviderSequentialCallbacks providerCallbacks = {0, SAL_ProviderGetBytesCallback, SAL_ProviderSkipForwardCallback, SAL_ProviderRewindCallback, NULL};
//
//    CGDataProviderRef providerRef = CGDataProviderCreateSequential((__bridge void * _Nullable)(stream), &providerCallbacks);
//    return CGImageCreate(drawStruct.imageRefWidth, drawStruct.imageRefHeight, drawStruct.bitsPerComponent, drawStruct.bitsPerPixel, drawStruct.bytesPerRow, SAL_GetColorSpace(), SAL_BitmapInfo, providerRef, NULL, NO, kCGRenderingIntentDefault);
//}

@end
