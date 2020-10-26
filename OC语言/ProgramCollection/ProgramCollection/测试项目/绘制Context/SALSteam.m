//
//  SALSteam.m
//  Unity-iPhone
//
//  Created by Qiushan on 2020/6/28.
//

#import "SALSteam.h"

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isSteam     = NO;
        _needFree    = NO;
        _needResetVisibleRect = NO;
        _cropArea    = CGRectMake(0, 0, 1, 1);
        _visibleArea = CGRectMake(0, 0, 1, 1);
    }
    return self;
}

- (void)setImageInfo:(SalImageInfo *)imageInfo {
    
    if ([imageInfo isKindOfClass:[SalImageInfo class]]) {
        if (_imageInfo != imageInfo) {
            _needFree          = YES;
            _imageInfo         = imageInfo;
            _positionMax       = imageInfo.imageStruct.pixelNum;
            _bytesPerPixel     = imageInfo.imageStruct.bytesPerPixel;
            _currentInfoStruct = imageInfo.imageStruct;
            _needResetVisibleRect = YES;
            if (_providerRef == NULL) {
                _providerRef = SALProviderRefWithBufferSequential(self);
            }
        }
        _isSteam = YES;
    }
}

- (void)setCropArea:(CGRect)cropArea {
    
    if (!CGRectEqualToRect(_cropArea, cropArea)) {
        _cropArea = cropArea;
        
        _needFree = YES;
        if (!CGRectEqualToRect(_cropArea, CGRectMake(0, 0, 1, 1)) && CGRectGetMaxX(_cropArea) <= 1 && CGRectGetMaxY(_cropArea) <= 1) {
            _needCrop = YES;
            _cropRect = CGRectMake(cropArea.origin.x * _imageInfo.imageStruct.imageRefWidth, cropArea.origin.y * _imageInfo.imageStruct.imageRefHeight, cropArea.size.width * _imageInfo.imageStruct.imageRefWidth, cropArea.size.height * _imageInfo.imageStruct.imageRefHeight);
            _cropRect = GetDirctRect(_cropRect);
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
            _visibleRect = GetDirctRect(_visibleRect);
        } else {
            _visibleRect = CGRectZero;
            _needVisible = NO;
        }
        _needResetVisibleRect = NO;
    }
    return _visibleRect;
}

- (size_t)bytesWithCropAndVisible:(size_t)bytes buffer:(void *)buffer didSet:(BOOL *)didSet isVisible:(BOOL *)isVisible {
    
    BOOL shouldSet = NO;
    
    if (_needCrop || _needVisible) {
        
        NSUInteger oriWidth = _imageInfo.imageStruct.imageRefWidth;
        NSUInteger bytesPerPixel = _bytesPerPixel;
        
        if (_needCrop) {
            if (_position == 0) {
                _position = _cropRect.origin.y * oriWidth + _cropRect.origin.x;
            }
        }
        
        //算出当前坐标
        NSUInteger cy = _position / oriWidth;
        NSUInteger cx = _position % oriWidth;
        
        //将_position 移动到每行的开头处
        if (_needCrop) {
            if (!CGRectContainsPoint(_cropRect, CGPointMake(cx, cy))) {
                if (cx < _cropRect.origin.x) {
                    _position = _position + _cropRect.origin.x - cx;
                } else if (cx > CGRectGetMaxX(_cropRect)) {
                    _position = _position + oriWidth - cx + _cropRect.origin.x;
                }
                cy = _position / oriWidth;
                cx = _position % oriWidth;
            }
            
            if (CGRectContainsPoint(_cropRect, CGPointMake(cx, cy))) {
                NSUInteger maxX = cy * oriWidth + CGRectGetMaxX(_cropRect);
                bytes = (maxX - _position) * bytesPerPixel;
            }
        } else {
            NSUInteger maxX = (cy + 1) * oriWidth;
            bytes = (maxX - _position) * bytesPerPixel;
        }
        
        //基于crop之后的visible坐标
        if (_needVisible) {
            CGRect currentShowRect = self.visibleRect;
            if (cy >= currentShowRect.origin.y && cy <= currentShowRect.origin.y + currentShowRect.size.height) {
                
                NSUInteger x = 0;
                NSUInteger maxWidth     = _currentInfoStruct.imageRefWidth;
                uint8_t * currentBuffer = buffer;
                size_t  setBytes        = 0;
                
                while (1) {
                    if (x < currentShowRect.origin.x) {//左
                        currentBuffer = buffer + x * bytesPerPixel;
                        setBytes = (currentShowRect.origin.x - x) * bytesPerPixel;
                        memset(currentBuffer, 0x0, setBytes);
                        x = currentShowRect.origin.x;
                    } else if (x >= CGRectGetMaxX(currentShowRect)) {//右
                        currentBuffer = buffer + x * bytesPerPixel;
                        setBytes = (maxWidth - x) * bytesPerPixel;
                        memset(currentBuffer, 0x0, setBytes);
                        x = maxWidth;
                    } else {//中
                        currentBuffer = buffer + x * bytesPerPixel;
                        
                        SALPixel_8888 * cpyBuffer = (_imageInfo.imageBuffer) + _position + x;
                        size_t pixNum = MIN(currentShowRect.size.width, _positionMax - _position - x);
//                        if (pixNum != currentShowRect.size.width) {
//                            NSLog(@"出错了");
//                        }
                        setBytes = pixNum * bytesPerPixel;
                        memcpy(currentBuffer, cpyBuffer, setBytes);
                        x = CGRectGetMaxX(currentShowRect);
                    }
                    if (x >= maxWidth) {
                        break;
                    }
                }
            } else {
                memset(buffer, 0x0, bytes);
            }
        } else {
            memcpy(buffer, (_imageInfo.imageBuffer) + _position, bytes);
        }
        
        shouldSet = YES;
        //移动position到下一行开头
        _position = _position + oriWidth;
    }
    if (didSet != NULL) {
        *didSet = shouldSet;
    }
    return bytes;
}

- (size_t)getBytes:(void *)buffer bytes:(size_t)bytes {
    
    bytes = MIN(bytes, (_positionMax - _position) * _bytesPerPixel);
    
    if (bytes > 0) {
        
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
