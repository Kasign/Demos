//
//  SalImageTool.h
//  MXSALEnigine
//
//  Created by Qiushan on 2019/11/13.
//  Copyright © 2019 Fly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "SalImageInfo.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SALDrawOrientation) {
    SALDrawOrientation_NORMAL     = 0,
    SALDrawOrientation_HORIZONTAL = 1,
    SALDrawOrientation_VERTICAL   = 2,
    SALDrawOrientation_ALL        = 3,
};

extern CGImageRef SALCropImageRef(CGImageRef imageRef, CGSize oriSize, CGRect cropRect, BOOL * needRelease);

extern UIColor * SALGetColor(SALPixel_8888 * imageBuffer, SALImageInfoStruct imageStruct, CGPoint point, CGSize currentSize);

/// 获取带有偏移量的像素点色值信息
/// @param imageBuffer 像素点buffer
/// @param imageStruct 图像参数
/// @param cropArea 裁剪区域 （0~1）
/// @param visibleArea 可见区域 （0~1）
/// @param point 点击的点
/// @param currentSize 点击的点对应的size
extern UIColor * SALGetColorWithOff(SALPixel_8888 * imageBuffer, SALImageInfoStruct imageStruct, CGRect cropArea, CGRect visibleArea, CGPoint point, CGSize currentSize);

///更改图片的颜色，alpha > 0 的像素
extern void SALChangeBufferAlphaColor(SALPixel_8888 * imageBuffer, size_t pixelNum, UIColor * color);

extern void SALChangeBufferAlphaColorWithComponents(SALPixel_8888 * imageBuffer, size_t pixelNum, const CGFloat * colorComponents);

/// 九宫格拆分
/// @param currentBuffer 当前的buffer
/// @param currentStruct 当前的image信息
/// @param insets {top, left,  bottom, right}  (0 ~ 1.0)
extern NSArray * SALDivideBufferWithInsets(SALPixel_8888 * currentBuffer, SALImageInfoStruct currentStruct, SALEdgeInsets insets);

/// 裁剪buffer
/// @param currentBuffer 当前的buffer
/// @param targetBuffer 目标buffer，为空值
/// @param currentStruct 当前buffer对应的结构信息
/// @param cropRect 裁剪的rect，值的范围（0 ~ 1.0）
extern void SALCropBuffer(SALPixel_8888 * currentBuffer, SALPixel_8888 * targetBuffer, SALImageInfoStruct currentStruct, CGRect cropRect);

/// visibleRect drawRect内的区域
/// @param imageBuffer 当前buffer
/// @param drawStruct image数据信息
/// @param visibleRect 可见区域，与scale相乘之后的数据
extern void SALImageBufferSetVisibleRect(SALPixel_8888 * imageBuffer, SALImageInfoStruct drawStruct, CGRect visibleRect);

/// 改变visibleArea内的区域为透明
/// @param imageBuffer buffer
/// @param drawStruct buffer对应的结构体数据
/// @param visibleArea （0 ~ 1.0）
extern void SALImageBufferSetVisibleArea(SALPixel_8888 * imageBuffer, SALImageInfoStruct drawStruct, CGRect visibleArea);

extern CGColorSpaceRef SALGetColorSpace(void);

extern void SALFreeStack(void);

/// 对Rect进行等比运算
/// @param rect 原始Rect
/// @param scale 比例大小
extern CGRect SALRectWithSacle(CGRect rect, CGFloat scale);


@interface SalDetailDrawTask : NSObject

@property (nonatomic, assign) SALDrawOrientation  drawOrientation;
@property (nonatomic, assign) CGRect              drawRect;  //绘制区域，相对于SalDrawTask 中drawSize

- (BOOL)isEffective;

@end

/// 要绘制的Image任务信息
@interface SalImageTask : SalDetailDrawTask

@property (nonatomic, strong) UIImage         *   drawImage;
@property (nonatomic, strong) SalImageInfo    *   drawImageInfo;
@property (nonatomic, assign) CGRect              cropRect;  //当前图片需要截取，改变图片大小,以ImageRefSize为基准
@property (nonatomic, assign) BOOL                needCrop;
@property (nonatomic) CGImageRef                  drawImageRef;

+ (SalImageTask *)imageTaskWithImageRef:(CGImageRef)imageRef drawRect:(CGRect)drawRect;
+ (SalImageTask *)imageTaskWithImage:(UIImage *)image drawRect:(CGRect)drawRect;
+ (SalImageTask *)imageTaskWithImageInfo:(SalImageInfo *)imageInfo drawRect:(CGRect)drawRect;
+ (SalImageTask *)imageTaskWithObject:(id)imageObject drawRect:(CGRect)drawRect;

@end

/// 要绘制的Path任务信息
@interface SalPathTask : SalDetailDrawTask

@property (nonatomic) CGPathRef                   pathRef;
@property (nonatomic, strong) UIColor        *    fillColor;
@property (nonatomic, strong) UIColor        *    strokColor;

+ (SalPathTask *)imageTaskWithPathRef:(CGPathRef)pathRef drawRect:(CGRect)drawRect;

@end

/// 要绘制的Path任务信息
@interface SalTextTask : SalDetailDrawTask

@property (nonatomic, strong) NSAttributedString   *   attributedStr;

+ (SalTextTask *)textTaskWithAttributedStr:(NSAttributedString *)attributedStr drawRect:(CGRect)drawRect;

@end

@interface SalDrawTask : NSObject

@property (nonatomic, assign) CGSize              drawSize;
@property (nonatomic, strong) UIColor         *   backColor;
@property (nonatomic, strong) UIColor         *   alphaColor;//改变透明区域颜色
@property (nonatomic, strong) NSArray<SalDetailDrawTask *> * drawTaskList;
@property (nonatomic, assign) CGBlendMode         blendMode;
@property (nonatomic, assign) size_t              drawScale;
@property (nonatomic, assign) CGRect              visibleRect;//可见区域，其他区域变透明，不改变图片大小
@property (nonatomic, assign) BOOL                usePublicHeap;//是否用公共堆内存
@property (nonatomic, assign) SALDrawContentType  drawType;

+ (SalDrawTask *)drawTaskWithSize:(CGSize)drawSize backColor:(UIColor * __nullable)backColor alphaColor:(UIColor * __nullable)alphaColor drawTaskList:(NSArray *)iamgeTasks;

@end

@interface SalDrawTool : NSObject

+ (SalImageInfo *)decodeWithImage:(UIImage *)image;
+ (SalImageInfo *)decodeWithImageRef:(CGImageRef)imageRef scale:(CGFloat)scale;
+ (SalImageInfo *)decodeImageInfoWithTask:(SalDrawTask *)drawTask;
+ (SalImageInfo *)decodeWithPathRef:(CGPathRef)pathRef;

@end

NS_ASSUME_NONNULL_END
