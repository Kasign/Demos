//
//  FLYImageChangeInstance.m
//  图像修改器
//
//  Created by Qiushan on 2020/1/16.
//  Copyright © 2020 FLY. All rights reserved.
//

#import "FLYImageChangeInstance.h"

@interface FLYImageChangeInstance ()

@property (nonatomic) CGContextRef  context;
@property (nonatomic) uint32_t *rgbImageBuf;
@property (nonatomic) CGColorSpaceRef colorSpace;
@property (nonatomic) size_t pixelPerRow;
@property (nonatomic) size_t bitsPerComponent;
@property (nonatomic) size_t bitsPerPixel;
@property (nonatomic) size_t bytesPerRow;
@property (nonatomic) size_t componentsPerPixel;
@property (nonatomic) size_t pixelTotalNum;//总像素点

@property (nonatomic) CGFloat imageScale;
@property (nonatomic) CGSize  imageSize;
@property (nonatomic) CGSize  imageRealSize;

@property (nonatomic, assign) BOOL isEffictive;

@end

@implementation FLYImageChangeInstance

- (void)setCurrentImage:(UIImage *)image {
    
    if (_context) {
        CGContextRelease(_context);
    }
    if (_colorSpace) {
        CGColorSpaceRelease(_colorSpace);
    }
    if (_rgbImageBuf) {
        free(_rgbImageBuf);
    }
    _isEffictive = NO;
    if (![image isKindOfClass:[UIImage class]]) {
        return;
    }
    
    CGImageRef oriImgRef = image.CGImage;
    size_t imageWidth  = CGImageGetWidth(oriImgRef);
    size_t imageHeight = CGImageGetHeight(oriImgRef);
    
    _colorSpace = CGColorSpaceCreateDeviceRGB();
    _bitsPerComponent = CGImageGetBitsPerComponent(oriImgRef);
    _bitsPerPixel = CGImageGetBitsPerPixel(oriImgRef);
    _bytesPerRow  = CGImageGetBytesPerRow(oriImgRef);
    _componentsPerPixel = _bitsPerPixel/_bitsPerComponent;
    _pixelPerRow   = _bytesPerRow/_componentsPerPixel;
    _pixelTotalNum = _pixelPerRow *imageHeight;
    
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast;
    
    _rgbImageBuf = (uint32_t *)malloc(_bytesPerRow *imageHeight);
    
    _context = CGBitmapContextCreate(_rgbImageBuf, imageWidth, imageHeight, _bitsPerComponent, _bytesPerRow, _colorSpace, bitmapInfo);
    
    CGContextSetBlendMode(_context, kCGBlendModeCopy);
    CGContextDrawImage(_context, CGRectMake(0, 0, imageWidth, imageHeight), oriImgRef);
    
    _imageScale = image.scale;
    _imageSize  = image.size;
    _imageRealSize = CGSizeMake(imageWidth, imageHeight);
    _isEffictive = YES;
}

#pragma mark - Change Color
///Change Color
- (void)changeImageColorAtPixel:(CGPoint)position currentSize:(CGSize)currentSize color:(UIColor *)color {
    
    if (_isEffictive && [color isKindOfClass:[UIColor class]] && currentSize.width >= position.x && position.x >= 0 && currentSize.height >= position.y && position.y >= 0 && _radius >= 0) {
        
        size_t pixelPerRow = _pixelPerRow;
        uint32_t *pCurPtr = _rgbImageBuf;
        
        const CGFloat *colorComponents = CGColorGetComponents(color.CGColor);
        size_t offset = [self offsetWithPoint:position currentSize:currentSize];
        
        int offsetX = -_radius;
        int offsetY = -_radius;
        
        uint8_t *ptr = 0;
        while (offsetX >= -_radius && offsetX <= _radius && offsetY >= -_radius && offsetY <= _radius) {
            
            ptr = (uint8_t *)(pCurPtr + offset + offsetX + offsetY *pixelPerRow);
            [self changeColorValueWithPointer:ptr colorPointer:colorComponents];
            offsetX ++;
            if (offsetX > _radius) {
                offsetX = -_radius;
                offsetY ++;
            }
        }
    }
}

- (void)changeImageAlphaAtPixel:(CGPoint)position currentSize:(CGSize)currentSize alpha:(CGFloat)alpha {
    
    if (_isEffictive && alpha >= 0 && alpha <= 1.f && currentSize.width >= position.x && position.x >= 0 && currentSize.height >= position.y && position.y >= 0 && _radius >= 0 && alpha >= 0 && alpha <= 1.f) {
        
        size_t pixelPerRow = _pixelPerRow;
        size_t offset = [self offsetWithPoint:position currentSize:currentSize];
        
        int offsetX = -_radius;
        int offsetY = -_radius;
        
        uint32_t *pCurPtr = _rgbImageBuf;
        uint8_t *ptr = 0;
        while (offsetX >= -_radius && offsetX <= _radius && offsetY >= -_radius && offsetY <= _radius) {
            
            ptr = (uint8_t *)(pCurPtr + offset + offsetX + offsetY *pixelPerRow);
            [self changeAlphaValueWithPointer:ptr alphaValue:alpha];
            offsetX ++;
            if (offsetX > _radius) {
                offsetX = -_radius;
                offsetY ++;
            }
        }
    }
}

#pragma mark - Change Direction
- (void)changeImageDirection:(int)direction {
    
    if (_isEffictive) {
        
        uint32_t *pCurPtr = _rgbImageBuf;
        size_t pixelPerRow = _pixelPerRow;
        size_t imageHeight = _imageRealSize.height;
        for (int i = 0; i < _pixelTotalNum; i ++) {
            
            int rowNum  = i /pixelPerRow;
            int lineNum = i % pixelPerRow;
            
            if (direction == 1) {//横向
                if (lineNum > pixelPerRow *0.5) {
                    [self exchangeValuesWitnPointer:pCurPtr + i exchangePointer:pCurPtr + i - lineNum + pixelPerRow - lineNum];
                } else {
                    continue;
                }
            } else if (direction == 2) {//纵向
                if (rowNum < imageHeight *0.5) {
                    [self exchangeValuesWitnPointer:pCurPtr + i exchangePointer:(pCurPtr + i + pixelPerRow *(imageHeight - 2 *rowNum))];
                } else {
                    break;
                }
            }
        }
    }
}

#pragma mark - Get Color Inpixel
- (UIColor *)getColorAtPixel:(CGPoint)position currentSize:(CGSize)currentSize {
    
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, currentSize.width, currentSize.height), position) || !_isEffictive) {
        return nil;
    }
    
    uint32_t *pCurPtr = _rgbImageBuf;
    size_t offset = [self offsetWithPoint:position currentSize:currentSize];
    uint8_t *ptr = (uint8_t *)(pCurPtr + offset);
    
    CGFloat r = ptr[0] / 255.f;
    CGFloat g = ptr[1] / 255.f;
    CGFloat b = ptr[2] / 255.f;
    CGFloat a = ptr[3] / 255.f;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

#pragma mark --

- (size_t)offsetWithPoint:(CGPoint)position currentSize:(CGSize)currentSize {
    
    if (!CGSizeEqualToSize(_imageSize, currentSize)) {
        position.x = position.x *_imageSize.width / currentSize.width;
        position.y = position.y *_imageSize.height / currentSize.height;
    }
    size_t offset = position.x + (int)position.y *_pixelPerRow;
    return offset;
}

- (UIImage *)getCurrentImage {
    
    UIImage *targetImage = nil;
    if (_context) {
        CGImageRef imageRef = CGBitmapContextCreateImage(_context);
        if (imageRef != NULL) {
            targetImage = [UIImage imageWithCGImage:imageRef scale:_imageScale orientation:UIImageOrientationUp];
        }
        CGImageRelease(imageRef);
    }
    return targetImage;
}

- (void)changeColorValueWithPointer:(uint8_t *)oriPointer colorPointer:(const CGFloat *)colorComponents {
    
    float alpha   = colorComponents[3] *255.f;
    oriPointer[0] = colorComponents[0] *alpha; //red   0~255
    oriPointer[1] = colorComponents[1] *alpha; //green 0~255
    oriPointer[2] = colorComponents[2] *alpha; //blue  0~255
    oriPointer[3] = alpha;
}

- (void)changeAlphaValueWithPointer:(uint8_t *)oriPointer alphaValue:(CGFloat)colorAlpha {
    
    oriPointer[3] = colorAlpha *255.f;
}

- (void)exchangeValuesWitnPointer:(uint32_t *)pointer exchangePointer:(uint32_t *)exchangePointer {
    
    uint32_t pCurValue = *pointer;
    *pointer = *exchangePointer;
    *exchangePointer = pCurValue;
}

@end
