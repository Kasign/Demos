//
//  SALSteam.m
//  Unity-iPhone
//
//  Created by Qiushan on 2020/6/28.
//

#import "SALSteam.h"
#import "SalRectManager.h"

@interface SALSteam ()

@property (nonatomic) CGImageRef                    imageRef;
@property (nonatomic) CGDataProviderRef             providerRef;
@property (nonatomic, strong) UIImage           *   image;

@property (nonatomic, assign) NSUInteger            positionMax;   //这里是像素点最大的位置，基于原始的rect
@property (nonatomic, assign) NSUInteger            position;      //这里是像素点的位置，基于原始的rect
@property (nonatomic, assign) NSUInteger            bytesPerPixel; //这里是像素点的位置，基于原始的rect

@property (nonatomic, assign) BOOL                  needCrop;
@property (nonatomic, assign) BOOL                  needVisible;
@property (nonatomic, assign) BOOL                  needFree;
@property (nonatomic, assign) BOOL                  needResetVisibleRect;
@property (nonatomic, assign) CGRect                cropRect;
@property (nonatomic, assign) CGRect                visibleRect;
@property (nonatomic, assign) SALImageInfoStruct    currentInfoStruct;


- (size_t)getBytes:(void *)buffer bytes:(size_t)bytes;
- (off_t)skipForwardBytes:(off_t)count;
- (void)rewind;

@end

size_t SALProviderGetBytesCallback(void * __nullable info, void * buffer, size_t count) {
    
    return [(__bridge SALSteam *)info getBytes:buffer bytes:count];
}

off_t SALProviderSkipForwardCallback(void * __nullable info, off_t count) {
    
    return [(__bridge SALSteam *)info skipForwardBytes:count];
}

void SALProviderRewindCallback(void * __nullable info) {
    
    return [(__bridge SALSteam *)info rewind];
}

CGDataProviderRef SALProviderRefWithBufferSequential(SALSteam * stream) {
    
    CGDataProviderSequentialCallbacks providerCallbacks = {0, SALProviderGetBytesCallback, SALProviderSkipForwardCallback, SALProviderRewindCallback, NULL};
    
    return CGDataProviderCreateSequential((__bridge void * _Nullable)(stream), &providerCallbacks);
}



@implementation SALSteam

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _needFree    = NO;
        _needResetVisibleRect = NO;
        _cropArea    = CGRectMake(0, 0, 1, 1);
        _visibleArea = CGRectMake(0, 0, 1, 1);
    }
    return self;
}

- (void)setImageInfo:(SalImageInfo *)imageInfo {
    
    _imageInfo = imageInfo;
    if ([imageInfo isKindOfClass:[SalImageInfo class]]) {
        _needFree          = YES;
        _positionMax       = imageInfo.imageStruct.pixelNum;
        _bytesPerPixel     = imageInfo.imageStruct.bytesPerPixel;
        _currentInfoStruct = imageInfo.imageStruct;
        _needResetVisibleRect = YES;
        if (_providerRef == NULL) {
            _providerRef = SALProviderRefWithBufferSequential(self);
        }
    }
}

- (void)setCropArea:(CGRect)cropArea {
    
    if (!CGRectEqualToRect(_cropArea, cropArea)) {
        _cropArea = cropArea;
        _needFree = YES;
        if (!CGRectEqualToRect(_cropArea, CGRectMake(0, 0, 1, 1)) && CGRectGetMaxX(_cropArea) <= 1 && CGRectGetMaxY(_cropArea) <= 1) {
            _needCrop = YES;
            _cropRect = CGRectMake(cropArea.origin.x * _imageInfo.imageStruct.imageRefWidth, cropArea.origin.y * _imageInfo.imageStruct.imageRefHeight, cropArea.size.width * _imageInfo.imageStruct.imageRefWidth, cropArea.size.height * _imageInfo.imageStruct.imageRefHeight);
            _cropRect = [SalRectManager getDirctRect:_cropRect];
            _currentInfoStruct = SALImageStructMake(_cropRect.size, _currentInfoStruct.imageRefScale);
            _needResetVisibleRect = YES;
        } else {
            _needCrop = NO;
            _cropRect = CGRectZero;
            _currentInfoStruct = _imageInfo.imageStruct;
        }
    }
}

- (void)setVisibleArea:(CGRect)visibleArea {
    
    if (!CGRectEqualToRect(_visibleArea, visibleArea)) {
        _visibleArea = visibleArea;
        if (!CGRectEqualToRect(_visibleArea, CGRectMake(0, 0, 1, 1)) && CGRectGetMaxX(_visibleArea) <= 1 && CGRectGetMaxY(_visibleArea) <= 1) {
            _needResetVisibleRect = YES;
            _needVisible = YES;
        } else {
            _visibleRect = CGRectZero;
            _needVisible = NO;
        }
    }
}

- (CGRect)visibleRect {
    
    if (_needResetVisibleRect) {
        if (!CGRectEqualToRect(_visibleArea, CGRectMake(0, 0, 1, 1)) && CGRectGetMaxX(_visibleArea) <= 1 && CGRectGetMaxY(_visibleArea) <= 1) {
            CGFloat rectX = _visibleArea.origin.x * _currentInfoStruct.imageRefWidth;
            CGFloat rectY = _visibleArea.origin.y * _currentInfoStruct.imageRefHeight;
            CGFloat rectW = _visibleArea.size.width * _currentInfoStruct.imageRefWidth;
            CGFloat rectH = _visibleArea.size.height * _currentInfoStruct.imageRefHeight;
            _visibleRect = CGRectMake(rectX, rectY, rectW, rectH);
            _visibleRect = [SalRectManager getDirctRect:_visibleRect];
        } else {
            _visibleRect = CGRectZero;
            _needVisible = NO;
        }
        _needResetVisibleRect = NO;
    }
    return _visibleRect;
}

#pragma mark - buffer
///这里只操作一行数据
- (size_t)bytesWithCropAndVisible:(size_t)bytes buffer:(void *)buffer didSet:(BOOL *)didSet isVisible:(BOOL *)isVisible {
    
    BOOL shouldSet = NO;
    
    if (_needCrop || _needVisible) {
        
        NSUInteger oriWidth      = _imageInfo.imageStruct.imageRefWidth;
        NSUInteger bytesPerPixel = _bytesPerPixel;
        
        if (_needCrop) {
            if (_position == 0) {
                _position = _cropRect.origin.y * oriWidth + _cropRect.origin.x;
            }
        }
        
        //算出当前坐标，基于原图size
        NSUInteger cP = _position;
        NSUInteger cY = cP / oriWidth;
        NSUInteger cX = cP % oriWidth;
        
        //将_position 移动到每行的开头处
        if (_needCrop) {
            
            NSUInteger nP = cP;
            NSUInteger nY = cY; //下一个位置y
            NSUInteger nX = cX; //下一个位置x
            
            //如果当前位置不在crop内，在crop外或者crop边界点
            if (!CGRectContainsPoint(_cropRect, CGPointMake(nX, nY))) {
                //如果当前位置在crop左侧，移动到crop左侧起始位置
                //如果当前位置在crop右侧，移动到下一行crop左侧起始位置
                if (nX < _cropRect.origin.x) {
                    nP = nP + _cropRect.origin.x - nX;
                } else if (nX >= CGRectGetMaxX(_cropRect)) {
                    nP = nP + oriWidth - nX + _cropRect.origin.x;
                }
                nY = nP / oriWidth;
                nX = nP % oriWidth;
            }
            //如果当前位置在crop内部，则重新计算需要处理的数据量，当前位置到crop右侧
            if (CGRectContainsPoint(_cropRect, CGPointMake(nX, nY))) {
                NSUInteger maxX = nY * oriWidth + CGRectGetMaxX(_cropRect);
                bytes = (maxX - nP) * bytesPerPixel;
            } else {
                //保证都是完整像素点
                bytes = (bytes/bytesPerPixel) * bytesPerPixel;
            }
            
            cP = nP;
            cX = nX;
            cY = nY;
        } else {
            //不需要裁剪，则处理一行数据
            NSUInteger maxX = (cY + 1) * oriWidth;
            bytes = MIN((MIN((maxX - cP), oriWidth)) * bytesPerPixel, bytes);
        }
        
        _position = cP;
        /**
         经过以上处理，如果有crop，开始的点在crop之外或者边界点，都移到左侧起始点，内部的位置不动
         如果没有crop，则bytes等于一行剩余的数据，postion不动
         */
        
        //基于crop之后的visible坐标
        if (_needVisible) {
            CGRect currentShowRect = self.visibleRect;
            if (cY >= currentShowRect.origin.y && cY <= currentShowRect.origin.y + currentShowRect.size.height) {
                
                NSUInteger startX   = cX - _cropRect.origin.x;
                NSUInteger pX       = startX;
                NSUInteger maxWidth = _currentInfoStruct.imageRefWidth;
                uint8_t *  pBuffer  = buffer;
                size_t     setBytes = 0;
                
                while (1) {
                    if (pX < currentShowRect.origin.x) {//左
                        pBuffer = buffer + (pX - startX) * bytesPerPixel;
                        setBytes = (currentShowRect.origin.x - pX) * bytesPerPixel;
                        memset(pBuffer, 0x0, setBytes);
                        pX = currentShowRect.origin.x;
                    } else if (pX >= CGRectGetMaxX(currentShowRect)) {//右
                        if (maxWidth > pX) {
                            pBuffer = buffer + (pX - startX) * bytesPerPixel;
                            setBytes = (maxWidth - pX) * bytesPerPixel;
                            memset(pBuffer, 0x0, setBytes);
                        }
                        pX = maxWidth;
                    } else {//中
                        if (CGRectGetMaxX(currentShowRect) > pX) {
                            pBuffer = buffer + (pX - startX) * bytesPerPixel;
                            SALPixel_8888 * cpyBuffer = (_imageInfo.imageBuffer) + _position + (pX - startX);
                            size_t pixNum = CGRectGetMaxX(currentShowRect) - pX;
                            setBytes = pixNum * bytesPerPixel;
                            memcpy(pBuffer, cpyBuffer, setBytes);
                        }
                        pX = CGRectGetMaxX(currentShowRect);
                    }
                    if (pX >= maxWidth) {
                        break;
                    }
                }
                bytes = (pX - startX) * bytesPerPixel;
            } else {
                memset(buffer, 0x0, bytes);
            }
        } else {
            memcpy(buffer, (_imageInfo.imageBuffer) + _position, bytes);
        }
        
        shouldSet = YES;
        //移动position
        _position = _position + bytes/bytesPerPixel;
    }
    if (didSet != NULL) {
        *didSet = shouldSet;
    }
    return bytes;
}

- (size_t)getBytes:(void *)buffer bytes:(size_t)bytes {
    
    if (_position < _positionMax && bytes > 0 && buffer != NULL) {
        bytes = MIN(bytes, (_positionMax - _position) * _bytesPerPixel);
        BOOL didSet    = NO; //是否已经操作过内存
        BOOL isVisible = YES;//是否可见
        if (_needCrop || _needVisible) {
            bytes = [self bytesWithCropAndVisible:bytes buffer:buffer didSet:&didSet isVisible:&isVisible];
        }
        if (!didSet && bytes > 0) {
            if (isVisible) {
                memcpy(buffer, (_imageInfo.imageBuffer) + _position, bytes);
            } else {
                memset(buffer, 0x00, bytes);
            }
            _position = _position + bytes/_bytesPerPixel;
        }
    } else {
        bytes = 0;
    }
    return bytes;
}

- (off_t)skipForwardBytes:(off_t)bytes {
    
    bytes = MIN(bytes, (_positionMax - _position) * _bytesPerPixel);
    _position = _position + bytes/_bytesPerPixel;
    return bytes;
}

- (void)rewind {
    
    _position = 0;
}

#pragma mark - image
- (UIImage *)currentImage {
    
    if (_needFree) {
        [self freeImageRef];
        _needFree = NO;
    }
    
    if (_image == nil) {
        SALImageInfoStruct drawStruct = _currentInfoStruct;
        if (_imageRef == NULL) {
            _imageRef = CGImageCreate(drawStruct.imageRefWidth, drawStruct.imageRefHeight, drawStruct.bitsPerComponent, drawStruct.bitsPerPixel, drawStruct.bytesPerRow, SALGetColorSpace(), SALBitmapInfo, _providerRef, NULL, NO, kCGRenderingIntentDefault);//kCGRenderingIntentDefault
        }
        if (_imageRef != NULL) {
            _image = SALImageWithImageRef(_imageRef, drawStruct.imageRefScale, UIImageOrientationUp);
        }
    }
    return _image;
}

- (BOOL)isSteam {
    
    return _imageInfo != nil;
}

- (void)freeImageRef {
    
    _image = nil;
    if (_imageRef != NULL) {
        CGImageRelease(_imageRef);
    }
    _imageRef = NULL;
}

- (void)dealloc {
    
    _image = nil;
    if (_imageRef != NULL) {
        CGImageRelease(_imageRef);
        _imageRef = NULL;
    }
    if (_providerRef != NULL) {
        CGDataProviderRelease(_providerRef);
        _providerRef = NULL;
    }
}

@end
