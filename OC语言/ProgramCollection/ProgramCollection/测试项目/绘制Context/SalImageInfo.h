//
//  SalImageInfo.h
//  Unity-iPhone
//
//  Created by Qiushan on 2020/6/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//ABGR kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast
typedef uint8_t    SALPixel_8888[4];      /* ARGB interleaved (8 bit/channel) pixel value. uint8_t[4] = { alpha, red, green, blue } */

#pragma mark - SALEdgeInsets
//九宫格 (0 ~ 1)
typedef struct __attribute__((objc_boxable)) SALEdgeInsets {
    float top, left, bottom, right;
} SALEdgeInsets;

UIKIT_STATIC_INLINE SALEdgeInsets SALEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
    SALEdgeInsets insets = {top, left, bottom, right};
    return insets;
}

UIKIT_STATIC_INLINE BOOL SALEdgeInsetsEqualToEdgeInsets(SALEdgeInsets insets1, SALEdgeInsets insets2) {
    return insets1.left == insets2.left && insets1.top == insets2.top && insets1.right == insets2.right && insets1.bottom == insets2.bottom;
}

#pragma mark - SALImageInfoStruct
typedef struct SALImageInfoStruct {
    
    size_t imageRefScale;        ///图片的缩放比
    size_t imageRefWidth;        ///宽 绘制时的宽，获取显示时的width需要除scale
    size_t imageRefHeight;       ///高 绘制时的宽，获取显示时的height需要除scale
    size_t bitsPerComponent;     ///Returns the number of bits allocated for a single color component of a bitmap image. 颜色中每个分量（包括alpha）值占用比特位数(bits)，一般为占用8位  （eg:RGBA 每个占用8bits，总共 4 * 8 = 32）
    size_t bitsPerPixel;         ///Returns the number of bits allocated for a single pixel in a bitmap image. 每个像素点占用比特位数(bits)，一般为32位，4个字节(1字节 = 8位)
    size_t bytesPerRow;          ///Returns the number of bytes allocated for a single row of a bitmap image. 每行字节数
    size_t componentsPerPixel;   ///bitsPerPixel / bitsPerComponent 每个像素点中颜色值分量数，一般为4个RGBA(顺序不确定)
    size_t bytesPerPixel;        ///bitsPerPixel/8  每个像素点占用字节数，一般为4 (bitsPerComponent = 8的情况下)
    size_t pixelPerRow;          ///每行总像素点 (准确算法：8 * bytesPerRow / bitsPerPixel 如果 bitsPerComponent = 8，可转换为bytesPerRow / componentsPerPixel)
    size_t pixelNum;             ///总像素点，每个像素点占位数bitsPerPixel，一般为32位
} SALImageInfoStruct;

typedef NS_ENUM(NSUInteger, SALDrawContentType) {
    SALDrawContentType_IMAGE  = 0,
    SALDrawContentType_PATH   = 1,
    SALDrawContentType_TEXT   = 2,
    SALDrawContentType_MIX    = 3, //混合
};

#pragma mark - "C"
extern SALImageInfoStruct SALImageStructMake(CGSize showSize, size_t scale);
extern SALImageInfoStruct StructInitWithImgRef(CGImageRef imgRef, size_t scale);
extern UIImage * SALImageWithImageRef(CGImageRef imageRef, CGFloat scale, UIImageOrientation orientation);
const static CGBitmapInfo SALBitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast;//CGImageGetBitmapInfo(oriImgRef)
extern CGColorSpaceRef SALGetColorSpace(void);

#pragma mark - SalImageInfo
@interface SalImageInfo : NSObject <NSCopying, NSCoding>

@property (nonatomic) SALImageInfoStruct           imageStruct;
@property (nonatomic) SALPixel_8888            *imageBuffer;
@property (nonatomic) CGContextRef                 contextRef;
@property (nonatomic) SALDrawContentType           drawType;

+ (instancetype)instanceWithSize:(CGSize)size scale:(float)scale;

- (CGSize)drawSize;
- (CGSize)showSize;

- (UIImage *)getCurrentImage:(BOOL)useBuffer;
- (CGImageRef)getCurrentImageRef:(BOOL)useBuffer;

/// 这里因为可以转移持有，所以有时候不需要释放，只置空即可
/// @param needFree 是否需要free
/// @param now 是否立即执行
- (void)clearBufferAndFree:(BOOL)needFree now:(BOOL)now;
- (void)clearContextAndFree:(BOOL)needFree now:(BOOL)now;
- (void)clearBufferImageRefAndFree:(BOOL)needFree now:(BOOL)now;
- (void)clearContextImageRefAndFree:(BOOL)needFree now:(BOOL)now;
- (void)clearContextImage:(BOOL)now;
- (void)clearBufferImage:(BOOL)now;

@end

NS_ASSUME_NONNULL_END
