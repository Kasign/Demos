//
//  SalImageTool.m
//  MXSALEnigine
//
//  Created by Qiushan on 2019/11/13.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "SalDrawTool.h"

#pragma mark - ↓↓--C FUN--↓↓
/*
 kCGBitmapByteOrder32Little 生成的信息位置为: 倒序
 kCGBitmapByteOrder32Big 生成的信息位置为: 顺序
 
 kCGImageAlphaPremultipliedLast >>>> R G B A
 kCGImageAlphaPremultipliedFirst >>>> A R G B
 
 //顺序  +   argb = ARGB
 kCGImageByteOrder32Big | kCGImageAlphaPremultipliedFirst
 const int RED   = 1;
 const int GREEN = 2;
 const int BLUE  = 3;
 const int ALPHA = 0;
 
 //顺序  +   rgba = RGBA
 kCGImageByteOrder32Big | kCGImageAlphaPremultipliedLast
 const int RED   = 0;
 const int GREEN = 1;
 const int BLUE  = 2;
 const int ALPHA = 3;
 
 //倒序   +  rgba = ABGR
 kCGImageByteOrder32Little | kCGImageAlphaPremultipliedLast
 const int RED   = 3;
 const int GREEN = 2;
 const int BLUE  = 1;
 const int ALPHA = 0;
 
 //倒序 + argb    = BGRA;
 //kCGImageByteOrder32Little | kCGImageAlphaPremultipliedFirst
 const int RED   = 2;
 const int GREEN = 1;
 const int BLUE  = 0;
 const int ALPHA = 3;
 
 */

/*
 <1>alloca是向栈申请内存,因此无需释放.
 <2>malloc分配的内存是位于堆中的,并且没有初始化内存的内容,因此基本上malloc之后,调用函数memset来初始化这部分的内存空间.
 <3>calloc则将初始化这部分的内存,设置为0.
 <4>realloc则对malloc申请的内存进行大小的调整.
 */

#pragma mark - 函数声明 --->>>修改函数参数的时候，一定要修改函数声明中的参数

//坐标转换
CGFloat ConverNum(CGFloat num);
CGSize  GetDirctSize(CGSize size);
CGPoint GetDirctPoint(CGPoint point);
CGRect  GetDirctRect(CGRect rect);

CGRect SALRectWithSacle(CGRect rect, CGFloat scale);
void SALChangeBufferColor(uint8_t *pixBuffer, const CGFloat *colorComponents, BOOL needSmooth);
///visibleRect drawRect内的区域
void SALImageBufferSetVisibleRect(SALPixel_8888 *imageBuffer, SALImageInfoStruct drawStruct, CGRect visibleRect);
SALImageInfoStruct StructInitWithImgRef(CGImageRef imgRef, size_t scale);
CGImageRef SALCropImageRef(CGImageRef imageRef, CGSize oriSize, CGRect cropRect, BOOL *needRelease);
///更改图片的颜色，alpha > 0 的像素
void SALChangeBufferAlphaColor(SALPixel_8888 *imageBuffer, size_t pixelNum, UIColor *color);
void SALChangeBufferAlphaColorWithComponents(SALPixel_8888 *imageBuffer, size_t pixelNum, const CGFloat *colorComponents);
void SALCropBuffer(SALPixel_8888 *currentBuffer, SALPixel_8888 *targetBuffer, SALImageInfoStruct currentStruct, CGRect cropRect);
void DrawImageWithScaleCTM(CGContextRef context, SALDrawOrientation orientation, void(^callback)(void));
SalImageInfo *SALGetImageInfoWithTask(SalDrawTask *drawTask);
void DrawPathWithTask(CGContextRef context, SALImageInfoStruct drawStruct, SalPathTask *pathTask, size_t drawScale);
void DrawWithDrawTask(CGContextRef context, SALPixel_8888 *imageBuffer, SALImageInfoStruct drawStruct, SalDrawTask *drawTask);
void DrawCalculateAndCrop(CGContextRef context, SALPixel_8888 *imageBuffer, SALImageInfoStruct drawStruct, SalDrawTask *drawTask);
void DrawImageWithTask(CGContextRef context, SALImageInfoStruct drawStruct, SalImageTask *imageTask, size_t drawScale);
void SALDrawChangeAllColor(SALPixel_8888 *currentBuffer, size_t pixelNum, UIColor *color);
void DrawTextWithTask(CGContextRef context, SALImageInfoStruct drawStruct, SalTextTask *textTask, size_t drawScale);
void DrawDetailTask(CGContextRef context, SALImageInfoStruct drawStruct, SalDetailDrawTask *detailTask, size_t drawScale);
#pragma mark 函数声明 -
#pragma mark - BEGIN DRAW
static CGColorSpaceRef colorSpace  = NULL;
static SALPixel_8888 *rgbImageBuf = NULL;
static size_t size = 0;

CGFloat ConverNum(CGFloat num) {
    
    num = (int)(num + 0.5);
    return num;
}

CGSize GetDirctSize(CGSize size) {
    
    size.width  = ConverNum(size.width);
    size.height = ConverNum(size.height);
    return size;
}

CGPoint GetDirctPoint(CGPoint point) {
    
    point.x = ConverNum(point.x);
    point.y = ConverNum(point.y);
    return point;
}

CGRect GetDirctRect(CGRect rect) {
    
    rect.origin = GetDirctPoint(rect.origin);
    rect.size   = GetDirctSize(rect.size);
    return rect;
}

#pragma mark 由DrawTask绘制成SalImageInfo
SalImageInfo *SALGetImageInfoWithTask(SalDrawTask *drawTask) {
    
    SalImageInfo *imageObject = nil;
    if ([drawTask isKindOfClass:[SalDrawTask class]] && !CGSizeEqualToSize(drawTask.drawSize, CGSizeZero)) {
        
        SALImageInfoStruct drawStruct = SALImageStructMake(drawTask.drawSize, drawTask.drawScale);
        
        SALPixel_8888 *imageBuffer = NULL;
        if (drawTask.usePublicHeap) {
            if (rgbImageBuf == NULL) {
                size = MAX(drawStruct.pixelNum, 4 *1000 *1000);
                rgbImageBuf = (SALPixel_8888 *)calloc(drawStruct.bytesPerPixel, size);
            }
            if (drawStruct.pixelNum > size) {
                size = drawStruct.pixelNum;
                free(rgbImageBuf);
                rgbImageBuf = (SALPixel_8888 *)calloc(drawStruct.bytesPerPixel, size);
            }
            imageBuffer = rgbImageBuf;
        } else {
            imageBuffer = (SALPixel_8888 *)calloc(drawStruct.bytesPerPixel, drawStruct.pixelNum);
        }

        CGContextRef contextRef = CGBitmapContextCreate(imageBuffer, drawStruct.imageRefWidth, drawStruct.imageRefHeight, drawStruct.bitsPerComponent, drawStruct.bytesPerRow, SALGetColorSpace(), SALBitmapInfo);
        
        CGContextSetInterpolationQuality(contextRef, kCGInterpolationDefault);
        
        //开始绘制任务
        DrawWithDrawTask(contextRef, imageBuffer, drawStruct, drawTask);
        
        //对象
        imageObject = [SalImageInfo new];
        imageObject.contextRef  = contextRef;
        imageObject.imageBuffer = imageBuffer;
        imageObject.imageStruct = drawStruct;
    }
    return imageObject;
}

#pragma mark 开始绘制当前DrawTask
void DrawWithDrawTask(CGContextRef context, SALPixel_8888 *imageBuffer, SALImageInfoStruct drawStruct, SalDrawTask *drawTask) {
    
    if ([drawTask isKindOfClass:[SalDrawTask class]]) {
        
        if (drawTask.backColor != nil) {
            SALDrawChangeAllColor(imageBuffer, drawStruct.pixelNum, drawTask.backColor);
        } else {
            if (drawTask.usePublicHeap) {
                CGContextClearRect(context, CGRectMake(0, 0, drawStruct.imageRefWidth, drawStruct.imageRefHeight));
            }
        }
        
        if (drawTask.drawTaskList.count > 0) {
            CGContextSetBlendMode(context, drawTask.blendMode);
            if (drawTask.visibleRect.size.width > 0 && drawTask.visibleRect.size.height > 0) {
                
                for (SalDetailDrawTask *detailTask in drawTask.drawTaskList) {
                    if ([detailTask isEffective]) {
                        DrawDetailTask(context, drawStruct, detailTask, drawTask.drawScale);
                    }
                }
            }
            
            if (drawTask.alphaColor && (drawTask.backColor == nil || [drawTask.backColor isEqual:[UIColor clearColor]])) {
                SALChangeBufferAlphaColor(imageBuffer, drawStruct.pixelNum, drawTask.alphaColor);
            }
            
            DrawCalculateAndCrop(context, imageBuffer, drawStruct, drawTask);
        }
    }
}

#pragma mark 绘制DrawTask的list内的每个任务
/// 绘制DrawTask的list内的每个任务，此处区分image、text和path
/// @param context 当前上下文
/// @param detailTask 不同类型的子任务
/// @param drawScale 缩放比
void DrawDetailTask(CGContextRef context, SALImageInfoStruct drawStruct, SalDetailDrawTask *detailTask, size_t drawScale) {
    
    if ([detailTask isKindOfClass:[SalImageTask class]]) {
        DrawImageWithTask(context, drawStruct, (SalImageTask *)detailTask, drawScale);
    } else if ([detailTask isKindOfClass:[SalTextTask class]]) {
        DrawTextWithTask(context, drawStruct, (SalTextTask *)detailTask, drawScale);
    } else if ([detailTask isKindOfClass:[SalPathTask class]]) {
        DrawPathWithTask(context, drawStruct, (SalPathTask *)detailTask, drawScale);
    }
}

#pragma mark 绘制当前ImageTask
/// 绘制image到当前上下文
/// @param context 上下文
/// @param imageTask 绘制任务
void DrawImageWithTask(CGContextRef context, SALImageInfoStruct drawStruct, SalImageTask *imageTask, size_t drawScale) {
    
    if (imageTask) {
        CGImageRef sourceImageRef = imageTask.drawImageRef;
        
        if (sourceImageRef == NULL) {
            return;
        }
        
        BOOL needRelease = NO;
        size_t imageRefHeight = CGImageGetHeight(sourceImageRef);
        size_t imageRefWidth  = CGImageGetWidth(sourceImageRef);
        CGSize imageRefSize   = CGSizeMake(imageRefWidth, imageRefHeight);
        
        if (imageTask.needCrop && !CGRectEqualToRect(imageTask.cropRect, CGRectMake(0, 0, imageRefWidth, imageRefHeight))) {
            sourceImageRef = SALCropImageRef(sourceImageRef, imageRefSize, imageTask.cropRect, &needRelease);
        }
        
        CGRect imageRect = imageTask.drawRect;
        if (drawScale != 1) {
            imageRect = SALRectWithSacle(imageRect, drawScale);
        }
        
        imageRect.origin.y = drawStruct.imageRefHeight - imageRect.origin.y - imageRect.size.height;
        
        DrawImageWithScaleCTM(context, imageTask.drawOrientation, ^{
            CGContextDrawImage(context, imageRect, sourceImageRef);
        });
        
        if (needRelease) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                CGImageRelease(sourceImageRef);
            });
        }
    }
}

#pragma mark 绘制当前TextTask
//CoreText 绘制文字
void DrawTextWithTask(CGContextRef context, SALImageInfoStruct drawStruct, SalTextTask *textTask, size_t drawScale) {
    
    /*
     CGContextSetCharacterSpacing(context, 30);// 间距
     CGContextSetTextPosition(context, 200, 200);// 位置
     CGContextSetTextMatrix(context, CGAffineTransformMake(1, 1, 1, 1, 1, 1));// 2d变化
     
     CGContextSetTextDrawingMode(context, kCGTextFillStroke);// 绘制设置
     CGFontRef fontRef = nil;
     CGContextSetFont(context, fontRef);// 字体
     CGContextSetFontSize(context, 20);// 大小
     
     //     CGPoint points[] = {CGPointMake(100, 100)};
     //     CGContextShowGlyphsAtPositions(context, glyphs, points, 2);// 符号
     
     // 获取
     //     CGPoint point =  CGContextGetTextPosition(context);
     //     CGAffineTransform affine = CGContextGetTextMatrix(context);
     
     // 字体平滑
     CGContextSetShouldSmoothFonts(context, YES);
     CGContextSetAllowsFontSmoothing(context, YES);
     
     CGContextSetShouldSubpixelPositionFonts(context, YES);
     CGContextSetAllowsFontSubpixelPositioning(context, YES);
     
     CGContextSetShouldSubpixelQuantizeFonts(context, YES);
     CGContextSetAllowsFontSubpixelQuantization(context, YES);
     
     // 抗锯齿
     CGContextSetShouldAntialias(context, YES);
     CGContextSetAllowsAntialiasing(context, YES);
     */
 
    NSAttributedString *attributedStr = textTask.attributedStr;
    
    // 创建绘制区域
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGRect textRect = textTask.drawRect;
    if (drawScale != 1) {
        textRect = SALRectWithSacle(textRect, drawScale);
    }
    textRect.origin.y = drawStruct.imageRefHeight - textRect.origin.y - textRect.size.height;
    CGPathAddRect(path, NULL, textRect);
 
    //排版
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedStr);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attributedStr length]), path, NULL);
    
//    CGSize constraints = CGSizeMake(textRect.size.width, CGFLOAT_MAX);
//    CFRange rangeToSize = CFRangeMake(0, (CFIndex)[attributedStr length]);
//    CFArrayRef lines = CTFrameGetLines(frame);
//
//    if (CFArrayGetCount(lines) > 0) {
//        NSInteger lastVisibleLineIndex = CFArrayGetCount(lines) - 1;
//        CTLineRef lastVisibleLine = CFArrayGetValueAtIndex(lines, lastVisibleLineIndex);
//        CFRange rangeToLayout = CTLineGetStringRange(lastVisibleLine);
//        rangeToSize = CFRangeMake(0, rangeToLayout.location + rangeToLayout.length);
//    }
//    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, rangeToSize, NULL, constraints, NULL);
//
//    NSLog(@"%@ suggest: %f %f true: %f %f", attributedStr.string, suggestedSize.width, suggestedSize.height, textRect.size.width, textRect.size.height);
    
    //整个区域绘制
    DrawImageWithScaleCTM(context, textTask.drawOrientation, ^{
        CTFrameDraw(frame, context);
    });
    
    //释放
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
}

#pragma mark 绘制当前PathTask
void DrawPathWithTask(CGContextRef context, SALImageInfoStruct drawStruct, SalPathTask *pathTask, size_t drawScale) {
    
    CGContextAddPath(context, pathTask.pathRef);
    if (pathTask.fillColor) {
        CGContextSetFillColor(context, CGColorGetComponents(pathTask.fillColor.CGColor));
    }
    if (pathTask.strokColor) {
        CGContextSetStrokeColor(context, CGColorGetComponents(pathTask.fillColor.CGColor));
    }
    CGContextDrawPath(context, kCGPathFillStroke);
}

#pragma mark 方向绘制
void DrawImageWithScaleCTM(CGContextRef context, SALDrawOrientation orientation, void(^callback)(void)) {
    
    if (callback) {
        
        if (orientation == SALDrawOrientation_VERTICAL) {
            CGContextTranslateCTM(context, 0, CGBitmapContextGetHeight(context));
            CGContextScaleCTM(context, 1.0, -1.0);
        } else if (orientation == SALDrawOrientation_HORIZONTAL) {
            CGContextTranslateCTM(context, CGBitmapContextGetWidth(context), 0);
            CGContextScaleCTM(context, -1.0, 1.0);
        } else if (orientation == SALDrawOrientation_ALL) {
            CGContextTranslateCTM(context, CGBitmapContextGetWidth(context), CGBitmapContextGetHeight(context));
            CGContextScaleCTM(context, -1.0, -1.0);
        }
        
        callback();
        
        if (orientation == SALDrawOrientation_VERTICAL) {
            CGContextTranslateCTM(context, 0, CGBitmapContextGetHeight(context));
            CGContextScaleCTM(context, 1.0, -1.0);
        } else if (orientation == SALDrawOrientation_HORIZONTAL) {
            CGContextTranslateCTM(context, CGBitmapContextGetWidth(context), 0);
            CGContextScaleCTM(context, -1.0, 1.0);
        } else if (orientation == SALDrawOrientation_ALL) {
            CGContextTranslateCTM(context, CGBitmapContextGetWidth(context), CGBitmapContextGetHeight(context));
            CGContextScaleCTM(context, -1.0, -1.0);
        }
    }
}

#pragma mark 保留原大小，把不显示的区域透明化
void DrawCalculateAndCrop(CGContextRef context, SALPixel_8888 *imageBuffer, SALImageInfoStruct drawStruct, SalDrawTask *drawTask) {
    
    if (!CGRectEqualToRect(drawTask.visibleRect, CGRectMake(0, 0, drawTask.drawSize.width, drawTask.drawSize.height)) && drawTask.visibleRect.size.width > 0 && drawTask.visibleRect.size.height > 0) {
        
        CGRect visibleRect = drawTask.visibleRect;
        if (drawTask.drawScale != 1) {
            visibleRect = SALRectWithSacle(visibleRect, drawTask.drawScale);
        }
        SALImageBufferSetVisibleRect(imageBuffer, drawStruct, visibleRect);
    }
}

#pragma mark 裁剪CGImageRef ，使用后需要释放
CGImageRef SALCropImageRef(CGImageRef imageRef, CGSize oriSize, CGRect cropRect, BOOL *needRelease) {

    //转换int消除精度问题
    cropRect = GetDirctRect(cropRect);
    
    CGImageRef imagePartRef = NULL;
    if (imageRef && CGRectContainsRect(CGRectMake(0, 0, oriSize.width, oriSize.height), cropRect) && !CGRectEqualToRect(CGRectMake(0, 0, oriSize.width, oriSize.height), cropRect)) {
        
        CGFloat imageRefWidth  = CGImageGetWidth(imageRef);
        CGFloat imageRefHeight = CGImageGetHeight(imageRef);
        
        CGFloat imageScale = MAX(imageRefWidth / oriSize.width, imageRefHeight / oriSize.height);

        //缩放cropRect以处理大于屏幕显示尺寸的图像
        if (imageScale != 1) {
            cropRect = SALRectWithSacle(cropRect, imageScale);
        }
        
        imagePartRef = CGImageCreateWithImageInRect(imageRef, cropRect);
        imageRef = NULL;
        if (needRelease) {
            *needRelease = YES;
        }
    }
    return imagePartRef;
}

void SALFreeStack(void) {
    
    if (rgbImageBuf != NULL) {
        free(rgbImageBuf);
        rgbImageBuf = NULL;
    }
    if (colorSpace != NULL) {
        CGColorSpaceRelease(colorSpace);
        colorSpace  = NULL;
    }
}

#pragma mark FINISH DRAW -

CGColorSpaceRef SALGetColorSpace(void) {
    
    if (colorSpace == NULL) {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    return colorSpace;
}

UIColor *SALGetColor(SALPixel_8888 *imageBuffer, SALImageInfoStruct imageStruct, CGPoint point, CGSize currentSize) {
    
    return SALGetColorWithOff(imageBuffer, imageStruct, CGRectMake(0, 0, 1, 1), CGRectMake(0, 0, 1, 1), point, currentSize);
}

UIColor *SALGetColorWithOff(SALPixel_8888 *imageBuffer, SALImageInfoStruct imageStruct, CGRect cropArea, CGRect visibleArea, CGPoint point, CGSize currentSize) {
    
    if (point.x > currentSize.width || point.y > currentSize.height || imageBuffer == NULL) {
        return nil;
    }
    
    size_t imageRefWidth  = imageStruct.imageRefWidth;
    size_t imageRefHeight = imageStruct.imageRefHeight;
    
    CGRect currentRect = CGRectMake(0, 0, imageRefWidth, imageRefHeight);
    if (!CGRectEqualToRect(cropArea, CGRectMake(0, 0, 1, 1))) {
        currentRect = CGRectMake(cropArea.origin.x *imageRefWidth, cropArea.origin.y *imageRefHeight, cropArea.size.width *imageRefWidth, cropArea.size.height *imageRefHeight);
        currentRect = GetDirctRect(currentRect);
    }
    
    size_t currentWidth  = currentRect.size.width;
    size_t currentHeight = currentRect.size.height;
    
    size_t x = point.x;
    size_t y = point.y;
    
    if (!CGSizeEqualToSize(CGSizeMake(currentWidth, currentHeight), currentSize)) {
        x = point.x *currentWidth / currentSize.width;
        y = point.y *currentHeight / currentSize.height;
    }
    
    x = x + currentRect.origin.x;
    y = y + currentRect.origin.y;
    
    CGFloat alpha = 0.f;
    CGFloat red   = 0.f;
    CGFloat green = 0.f;
    CGFloat blue  = 0.f;
    
    if (!CGRectEqualToRect(visibleArea, CGRectMake(0, 0, 1, 1))) {
        
        CGRect visibleRect = CGRectMake(visibleArea.origin.x *currentWidth, visibleArea.origin.y *currentHeight, visibleArea.size.width *currentWidth, visibleArea.size.height *currentHeight);
        visibleRect = GetDirctRect(visibleRect);
        
        if (!CGRectContainsPoint(visibleRect, CGPointMake(x, y))) {
            return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        }
    }
    
    //这里的imageBuffer存的是数组，每个数组占4个字节，所以这里位移应该是 x + y *单行字节数/4
    SALPixel_8888 *currentPtr = imageBuffer + x + y *imageRefWidth;
    
    uint8_t *uint8Ptr = (uint8_t *)currentPtr;
    alpha = (float)uint8Ptr[0]/255.f;
    red   = (float)uint8Ptr[1]/255.f;
    green = (float)uint8Ptr[2]/255.f;
    blue  = (float)uint8Ptr[3]/255.f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


#pragma mark 改变像素点的颜色

/// 改变像素点的颜色
/// @param pixBuffer 像素点信息{ alpha, blue, green, red }
/// @param colorComponents 颜色分量值{ red, green, blue, alpha }
/// @param needSmooth 是否需要光滑，抗锯齿
void SALChangeBufferColor(uint8_t *pixBuffer, const CGFloat *colorComponents, BOOL needSmooth) {
    
    float oriA  = pixBuffer[0];
    float alpha = colorComponents[3];
    if (needSmooth) {
        alpha = alpha *oriA/255.f;
    }
    pixBuffer[3] = colorComponents[0] *255.f *alpha; //red   0~255
    pixBuffer[2] = colorComponents[1] *255.f *alpha; //green 0~255
    pixBuffer[1] = colorComponents[2] *255.f *alpha; //blue  0~255
    if (!needSmooth) {
        pixBuffer[0] = alpha *255.f; //alpha  0~255
    }
}

//改变矩形内的颜色，未改变image的size，如果要改变size，还要拼接数据
void SALDrawChangeColorInRect(SALPixel_8888 *currentBuffer, SALImageInfoStruct drawStruct, CGRect rect, UIColor *color) {
    
    size_t pixelNum = drawStruct.pixelNum;
    
    rect = GetDirctRect(rect);
    
    size_t cropX = (int)rect.origin.x;
    size_t cropY = (int)rect.origin.y;
    size_t cropW = (int)rect.size.width;
    size_t cropH = (int)rect.size.height;
    
    if (currentBuffer && pixelNum > 0 && color && cropX >= 0 && cropY >= 0 && cropW > 0 && cropH > 0 && (cropX + cropW) *(cropY + cropH) <= pixelNum) {
        
        SALPixel_8888 *pCurPtr = currentBuffer;
        const CGFloat *colorComponents = nil;
        if ([color isKindOfClass:[UIColor class]]) {
            colorComponents = CGColorGetComponents(color.CGColor);
            
            size_t x = 0, y = 0;
            pCurPtr  = pCurPtr + cropY *drawStruct.imageRefWidth + cropX;
            for (; y < cropH; y++) {//行数
                
                for (x = 0; x < cropW; x++, pCurPtr++) {
                    @autoreleasepool {
                        uint8_t *ptr = (uint8_t *)pCurPtr;
                        SALChangeBufferColor(ptr, colorComponents, NO);
                    }
                }
                pCurPtr = pCurPtr + drawStruct.imageRefWidth - cropW;//切换到下一行
            }
        }
        pCurPtr = NULL;
    }
}

void SALImageBufferSetVisibleArea(SALPixel_8888 *imageBuffer, SALImageInfoStruct drawStruct, CGRect visibleArea) {
    
    if (CGRectGetMaxX(visibleArea) > 1 || CGRectGetMaxY(visibleArea) > 1 || imageBuffer == NULL) {
        return;
    }
    
    size_t width  = drawStruct.imageRefWidth;
    size_t height = drawStruct.imageRefHeight;
    
    CGRect visibleRect = CGRectMake(visibleArea.origin.x *width, visibleArea.origin.y *height, visibleArea.size.width *width, visibleArea.size.height *height);
    
    SALImageBufferSetVisibleRect(imageBuffer, drawStruct, visibleRect);
}

///visibleRect drawRect内的区域
void SALImageBufferSetVisibleRect(SALPixel_8888 *imageBuffer, SALImageInfoStruct drawStruct, CGRect visibleRect) {
    
    CGRect drawRect = CGRectMake(0, 0, drawStruct.imageRefWidth, drawStruct.imageRefHeight);
    CGFloat maxY = CGRectGetMaxY(drawRect);
    CGFloat maxX = CGRectGetMaxX(drawRect);
    
    if (imageBuffer == NULL || !CGRectContainsRect(drawRect, visibleRect) || maxX <= 0 || maxY <= 0) {
        return;
    }
    
    if (CGRectEqualToRect(visibleRect, CGRectZero)) {
        SALDrawChangeColorInRect(imageBuffer, drawStruct, drawRect, [UIColor colorWithRed:0 green:0 blue:0 alpha:0]);
        return;
    }
    
    CGRect cropRect[6] = {};
    CGFloat x = 0, y = 0, w = 0, h = 0;
    int index = -1;
    
    while (1) {
        while (w == 0 || h == 0) {
            if (x <= visibleRect.origin.x) {//在可视区域左侧
                if (y < visibleRect.origin.y) {//在可视区域上侧
                    w = CGRectGetMaxX(drawRect) - x;//到最右侧
                    h = visibleRect.origin.y - y;//可视区域上沿
                    //                        SALLog(@"可视区域左上侧 %f %f %f %f", x, y, w, h);
                } else if (y >= CGRectGetMaxY(visibleRect)) {//在可视区域下侧
                    w = CGRectGetMaxX(drawRect) - x;
                    h = CGRectGetMaxY(drawRect) - y;
                    //                        SALLog(@"可视区域左下侧 %f %f %f %f", x, y, w, h);
                } else {//同一行
                    if (x == visibleRect.origin.x) {//x 与可视区域相交
                        w = CGRectGetMaxX(visibleRect) - x;
                    } else {
                        w = visibleRect.origin.x - x;
                    }
                    h = CGRectGetMaxY(visibleRect) - y;
                    //                        SALLog(@"可视区域左同侧 %f %f %f %f", x, y, w, h);
                }
            } else if (x >= CGRectGetMaxX(visibleRect)) {//在可视区域右侧
                
                if (y < visibleRect.origin.y) {//在可视区域上侧
                    //                        SALLog(@"可视区域右上侧 %f %f %f %f", x, y, w, h);
                } else if (y >= CGRectGetMaxY(visibleRect)) {//在可视区域下侧
                    //                        SALLog(@"可视区域右下侧 %f %f %f %f", x, y, w, h);
                } else {//同一行
                    w = CGRectGetMaxX(drawRect) - x;
                    h = CGRectGetMaxY(visibleRect) - y;
                    //                        SALLog(@"可视区域右同侧 %f %f %f %f", x, y, w, h);
                }
            }
        }
        if (w > 0 && h > 0) {
            CGRect rect = CGRectMake(x, y, w, h);
            if (!CGRectEqualToRect(rect, visibleRect)) {
                index ++;
                cropRect[index] = rect;
            }
        }
        
        if (y + h >= maxY && x + w >= maxX) {
            break;
        }
        
        x = x + w;
        if (x == drawRect.size.width) {
            y = y + h;
            x = 0;
            h = 0;
        }
        w = 0;
    }
    
    CGRect clearRect = CGRectZero;
    for (; index >= 0; index--) {
        clearRect = cropRect[index];
        SALDrawChangeColorInRect(imageBuffer, drawStruct, clearRect, [UIColor colorWithRed:0 green:0 blue:0 alpha:0]);
    }
}


#pragma mark 改变透明度不为0的色值
/// 改变alpha >  0的颜色
/// @param imageBuffer 像素数据
/// @param pixelNum 总像素点
/// @param color 目标颜色值
void SALChangeBufferAlphaColor(SALPixel_8888 *imageBuffer, size_t pixelNum, UIColor *color) {
    
    if (imageBuffer != NULL && pixelNum > 0 && [color isKindOfClass:[UIColor class]]) {
        const CGFloat *colorComponents = CGColorGetComponents(color.CGColor);
        SALChangeBufferAlphaColorWithComponents(imageBuffer, pixelNum, colorComponents);
    }
}

void SALChangeBufferAlphaColorWithComponents(SALPixel_8888 *imageBuffer, size_t pixelNum, const CGFloat *colorComponents) {
    
    if (imageBuffer && pixelNum > 0 && colorComponents != NULL) {
        SALPixel_8888 *pCurPtr = imageBuffer;
        for (size_t i = 0; i < pixelNum; i++, pCurPtr++) {
            @autoreleasepool {
                uint8_t *ptr = (uint8_t *)pCurPtr;
                if (ptr[0] > 0) {
                    SALChangeBufferColor(ptr, colorComponents, YES);
                }
            }
        }
        pCurPtr = NULL;
    }
}

#pragma mark 改变所有颜色值
/// 改变所有颜色值
/// @param currentBuffer 像素数据
/// @param pixelNum 总像素点
/// @param color 目标颜色值
void SALDrawChangeAllColor(SALPixel_8888 *currentBuffer, size_t pixelNum, UIColor *color) {
    
    if (currentBuffer && pixelNum > 0 && color) {
        SALPixel_8888 *pCurPtr = currentBuffer;
        const CGFloat *colorComponents = nil;
        if ([color isKindOfClass:[UIColor class]]) {
            colorComponents = CGColorGetComponents(color.CGColor);
            for (size_t i = 0; i < pixelNum; i++, pCurPtr++) {
                @autoreleasepool {
                    uint8_t *ptr = (uint8_t *)pCurPtr;
                    SALChangeBufferColor(ptr, colorComponents, NO);
                }
            }
        }
        pCurPtr = NULL;
    }
}

NSArray *SALDivideBufferWithInsets(SALPixel_8888 *currentBuffer, SALImageInfoStruct currentStruct, SALEdgeInsets insets) {
    
    if (currentBuffer == NULL || SALEdgeInsetsEqualToEdgeInsets(insets, SALEdgeInsetsMake(0, 0, 0, 0))) {
        return nil;
    }
    
    NSMutableArray *divideArray = [NSMutableArray arrayWithCapacity:9];
    float width  = 1;
    float height = 1;
    float left   = insets.left   *width;
    float right  = insets.right  *width;
    float top    = insets.top    *height;
    float bottom = insets.bottom *height;
    
    float x = 0, y = 0, w = left, h = top;
    
    while (1) {
        
        CGRect cropRect = CGRectMake(x, y, w, h);
        
        CGSize infoSize = CGSizeMake(w *currentStruct.imageRefWidth, h *currentStruct.imageRefHeight);
        
        infoSize = GetDirctSize(infoSize);
        
        SalImageInfo *imageInfo = [SalImageInfo instanceWithSize:infoSize scale:currentStruct.imageRefScale];
        
        if (imageInfo) {
            SALCropBuffer(currentBuffer, imageInfo.imageBuffer, currentStruct, cropRect);
            [divideArray addObject:imageInfo];
        } else {
            [divideArray removeAllObjects];
            break;
        }
        
        if (x + w >= width && y + h >= height) {
            break;
        }
        
        if (x == 0 && w == left) {
            x = left;
            w = width - left - right;
        } else if (x + w == width) {
            
            x = 0;
            w = left;
            y = y + h;
            if (y == top) {
                h = height - top - bottom;
            } else if (y == height - bottom) {
                h = bottom;
            }
        } else {
            x = width - right;
            w = right;
        }
    }
    
    return divideArray;
}

/// 裁剪buffer
/// @param currentBuffer 被裁剪的buffer
/// @param targetBuffer 目标buffer
/// @param currentStruct 被裁减buffer信息
/// @param cropRect 裁剪范围（0 ~ 1）
void SALCropBuffer(SALPixel_8888 *currentBuffer, SALPixel_8888 *targetBuffer, SALImageInfoStruct currentStruct, CGRect cropRect) {
    
    if (targetBuffer != NULL && currentBuffer != NULL && cropRect.size.height > 0 && cropRect.size.width > 0 && cropRect.size.width <= 1 && cropRect.size.height <= 1) {
        
        CGRect cropDrawRect = CGRectMake(cropRect.origin.x *currentStruct.imageRefWidth, cropRect.origin.y *currentStruct.imageRefHeight, cropRect.size.width *currentStruct.imageRefWidth, cropRect.size.height *currentStruct.imageRefHeight);
        
        cropDrawRect = GetDirctRect(cropDrawRect);
        
        if (CGRectGetMaxX(cropDrawRect) > currentStruct.imageRefWidth/currentStruct.imageRefScale || CGRectGetMaxY(cropDrawRect) > currentStruct.imageRefHeight/currentStruct.imageRefScale) {
            return;
        }
        
        size_t x = 0, y = 0;
        while (x <= cropDrawRect.size.width - 1 && y <= cropDrawRect.size.height - 1) {
            
            @autoreleasepool {
                
                size_t targetOff  = x + y *cropDrawRect.size.width;
                size_t currentOff = cropDrawRect.origin.x + x + (y + cropDrawRect.origin.y) *currentStruct.imageRefWidth;
                
                SALPixel_8888 *currentPix = currentBuffer + currentOff;
                SALPixel_8888 *targetPix  = targetBuffer  + targetOff;
                
                uint8_t *targetPixArr  = (uint8_t *)targetPix;
                uint8_t *currentPixArr = (uint8_t *)currentPix;
                
                targetPixArr[0] = currentPixArr[0];
                targetPixArr[1] = currentPixArr[1];
                targetPixArr[2] = currentPixArr[2];
                targetPixArr[3] = currentPixArr[3];
                
                x ++;
                if (x == cropDrawRect.size.width) {
                    x = 0;
                    y ++;
                }
            }
        }
    }
}
#pragma mark - Basic Tool
CGRect SALRectWithSacle(CGRect rect, CGFloat scale) {
    
    if (scale != 1) {
        rect.origin.x    = rect.origin.x *scale;
        rect.origin.y    = rect.origin.y *scale;
        rect.size.width  = rect.size.width  *scale;
        rect.size.height = rect.size.height *scale;
    }
    return rect;
}

#pragma mark - ↑↑--C FUN--↑↑ -

#pragma mark - SalDetailDrawTask
@implementation SalDetailDrawTask

- (BOOL)isEffective {
    
    if (CGRectGetMaxX(_drawRect) > 0 &&
        CGRectGetMaxY(_drawRect) > 0 &&
        _drawRect.size.width  > 0 &&
        _drawRect.size.height > 0) {
        return YES;
    }
    return NO;
}

@end

#pragma mark - SalImageTask
@implementation SalImageTask

+ (SalImageTask *)imageTaskWithObject:(id)imageObject drawRect:(CGRect)drawRect {
    
    if ([imageObject isKindOfClass:[UIImage class]]) {
        return [self imageTaskWithImage:imageObject drawRect:drawRect];
    } else if ([imageObject isKindOfClass:[SalImageInfo class]]) {
        return [self imageTaskWithImageInfo:imageObject drawRect:drawRect];
    }
    return nil;
}

+ (SalImageTask *)imageTaskWithImage:(UIImage *)image drawRect:(CGRect)drawRect {
    
    SalImageTask *imageTask = [SalImageTask new];
    imageTask.needCrop       = NO;
    imageTask.drawImage      = image;
    imageTask.drawRect       = drawRect;
    return imageTask;
}

+ (SalImageTask *)imageTaskWithImageRef:(CGImageRef)imageRef drawRect:(CGRect)drawRect {
    
    SalImageTask *imageTask = [SalImageTask new];
    imageTask.needCrop       = NO;
    imageTask.drawImageRef   = imageRef;
    imageTask.drawRect       = drawRect;
    return imageTask;
}

+ (SalImageTask *)imageTaskWithImageInfo:(SalImageInfo *)imageInfo drawRect:(CGRect)drawRect {
    
    SalImageTask *imageTask = [SalImageTask new];
    imageTask.needCrop       = NO;
    imageTask.drawImageInfo  = imageInfo;
    imageTask.drawRect       = drawRect;
    return imageTask;
}

- (void)setCropRect:(CGRect)cropRect {
    
    _cropRect = GetDirctRect(cropRect);
}

- (CGImageRef)drawImageRef {
    
    if (_drawImageRef == NULL && _drawImage) {
        _drawImageRef = _drawImage.CGImage;
    }
    if (_drawImageRef == NULL && _drawImageInfo) {
        _drawImageRef = [_drawImageInfo getCurrentImageRef:YES];
    }
    if (_drawImageRef == NULL && _drawImageInfo) {
        _drawImageRef = [_drawImageInfo getCurrentImageRef:NO];
    }
    
    return _drawImageRef;
}

@end

#pragma mark - SalTextTask
@implementation SalTextTask

+ (SalTextTask *)textTaskWithAttributedStr:(NSAttributedString *)attributedStr drawRect:(CGRect)drawRect {
    
    SalTextTask *task = [[SalTextTask alloc] init];
    task.drawRect      = drawRect;
    task.attributedStr = attributedStr;
    return task;
}

@end

#pragma mark - SalPathTask
@implementation SalPathTask

+ (SalPathTask *)imageTaskWithPathRef:(CGPathRef)pathRef drawRect:(CGRect)drawRect {
    
    SalPathTask *pathTask = [[SalPathTask alloc] init];
    pathTask.drawRect = drawRect;
    pathTask.pathRef  = pathRef;
    return pathTask;
}

@end

#pragma mark - SalDrawTask
@implementation SalDrawTask

+ (SalDrawTask *)drawTaskWithSize:(CGSize)drawSize backColor:(UIColor *)backColor alphaColor:(UIColor *)alphaColor drawTaskList:(NSArray *)drawTaskList {
    
    SalDrawTask *drawTask = [SalDrawTask new];
    drawTask.usePublicHeap = NO;
    drawTask.drawScale     = [UIScreen mainScreen].scale;
    drawTask.drawSize      = drawSize;
    drawTask.backColor     = backColor;
    drawTask.drawTaskList  = drawTaskList;
    drawTask.alphaColor    = alphaColor;
    return drawTask;
}

/*
 kCGBlendModeCopy 覆盖掉背景色
 kCGBlendModeOverlay & kCGBlendModeDestinationAtop = kCGBlendModeNormal; //保留背景色
 */
- (CGBlendMode)blendMode {
    
    return kCGBlendModeNormal;
}

- (void)setDrawSize:(CGSize)drawSize {
    
    drawSize     = GetDirctSize(drawSize);
    _drawSize    = drawSize;
    _visibleRect = CGRectMake(0, 0, drawSize.width, drawSize.height);
}

- (void)setVisibleRect:(CGRect)visibleRect {
    
    _visibleRect = GetDirctRect(visibleRect);
}

@end

#pragma mark - SalImageTool
@implementation SalDrawTool

+ (SalImageInfo *)decodeImageInfoWithTask:(SalDrawTask *)drawTask {
    
    return SALGetImageInfoWithTask(drawTask);
}

+ (SalImageInfo *)decodeWithPathRef:(CGPathRef)pathRef {
    
    SalImageInfo *imageInfo = nil;
    if (pathRef != NULL) {
        
    }
    return imageInfo;
}

+ (SalImageInfo *)decodeWithImage:(UIImage *)image {
    
    SalImageInfo *imageInfo = nil;
    if ([image isKindOfClass:[UIImage class]]) {
        CGRect drawRect = CGRectMake(0, 0, image.size.width, image.size.height);
        SalImageTask *imageTask = [SalImageTask imageTaskWithImage:image drawRect:drawRect];
        SalDrawTask  *drawTask  = [SalDrawTask drawTaskWithSize:drawRect.size backColor:nil alphaColor:nil drawTaskList:@[imageTask]];
        drawTask.drawScale = image.scale;
        drawTask.drawType  = SALDrawContentType_IMAGE;
        imageInfo = SALGetImageInfoWithTask(drawTask);
    }
    return imageInfo;
}

+ (SalImageInfo *)decodeWithImageRef:(CGImageRef)imageRef scale:(CGFloat)scale {
    
    SalImageInfo *imageInfo = nil;
       if (imageRef != NULL && scale > 0) {
           size_t width  = CGImageGetWidth(imageRef);
           size_t height = CGImageGetHeight(imageRef);
           
           width  = width/scale;
           height = height/scale;
           
           CGRect drawRect = CGRectMake(0, 0, width, height);
           SalImageTask *imageTask = [SalImageTask imageTaskWithImageRef:imageRef drawRect:drawRect];
           
           SalDrawTask  *drawTask  = [SalDrawTask drawTaskWithSize:drawRect.size backColor:nil alphaColor:nil drawTaskList:@[imageTask]];
           drawTask.drawScale = scale;
           drawTask.drawType  = SALDrawContentType_IMAGE;
           imageInfo = SALGetImageInfoWithTask(drawTask);
       }
       return imageInfo;
}

@end
