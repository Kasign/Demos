//
//  SalImageInfo.m
//  Unity-iPhone
//
//  Created by Qiushan on 2020/6/28.
//

#import "SalImageInfo.h"

#pragma mark - SALImageInfoStruct
SALImageInfoStruct StructInitWithImgRef(CGImageRef imgRef, size_t scale) {
    
    SALImageInfoStruct drawStruct;
    drawStruct.imageRefScale       = scale;
    drawStruct.imageRefWidth       = CGImageGetWidth(imgRef);
    drawStruct.imageRefHeight      = CGImageGetHeight(imgRef);
    drawStruct.bitsPerComponent    = CGImageGetBitsPerComponent(imgRef);
    drawStruct.bitsPerPixel        = CGImageGetBitsPerPixel(imgRef);
    drawStruct.bytesPerRow         = CGImageGetBytesPerRow(imgRef);
    drawStruct.bytesPerPixel       = drawStruct.bitsPerPixel/8;
    drawStruct.componentsPerPixel  = drawStruct.bitsPerPixel/drawStruct.bitsPerComponent;
    drawStruct.pixelPerRow         = drawStruct.bytesPerRow/drawStruct.bytesPerPixel;
    drawStruct.pixelNum            = drawStruct.pixelPerRow * drawStruct.imageRefHeight;
    
    return drawStruct;
}

SALImageInfoStruct SALImageStructMake(CGSize showSize, size_t scale) {
    
    SALImageInfoStruct drawStruct;
    drawStruct.imageRefScale       = scale;
    drawStruct.imageRefWidth       = (size_t)(showSize.width  * scale);
    drawStruct.imageRefHeight      = (size_t)(showSize.height * scale);
    drawStruct.bitsPerComponent    = 8;
    drawStruct.bitsPerPixel        = 32;
    drawStruct.bytesPerRow         = drawStruct.imageRefWidth * drawStruct.bitsPerPixel/drawStruct.bitsPerComponent;
    drawStruct.bytesPerPixel       = drawStruct.bitsPerPixel/8;
    drawStruct.componentsPerPixel  = drawStruct.bitsPerPixel/drawStruct.bitsPerComponent;
    drawStruct.pixelPerRow         = drawStruct.bytesPerRow/drawStruct.bytesPerPixel;
    drawStruct.pixelNum            = drawStruct.pixelPerRow * drawStruct.imageRefHeight;
    return drawStruct;
}
#pragma mark SALImageInfoStruct -

#pragma mark 由imageRef转变成Image
UIImage * SALImageWithImageRef(CGImageRef imageRef, CGFloat scale, UIImageOrientation orientation) {
    
    UIImage * targetImage = nil;
    if (imageRef != NULL) {
        targetImage = [UIImage imageWithCGImage:imageRef scale:scale orientation:orientation];
    }
    return targetImage;
}

#pragma mark 生成ImageRef
CGImageRef SALImageRefWithContext(CGContextRef context) {
    
    CGImageRef targetRef = CGBitmapContextCreateImage(context);
    return targetRef;
}

#pragma mark SALProviderReleaseData
void SALProviderReleaseData(void * info, const void * data, size_t size) {
    
    if (data != NULL) {
        free((void*)data);
    }
    if (info != NULL) {
        free(info);
    }
}

CGImageRef SALImageRefWithBufferData(SALPixel_8888 * currentBuffer, SALImageInfoStruct drawStruct, CGBitmapInfo bitmapInfo, CGColorSpaceRef colorSpace) {
    
    //生成的imageRef 与buffer绑定，free时导致imageRef崩溃
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, currentBuffer, drawStruct.bytesPerPixel * drawStruct.pixelNum, SALProviderReleaseData);
    
    CGImageRef imageRef = CGImageCreate(drawStruct.imageRefWidth, drawStruct.imageRefHeight, drawStruct.bitsPerComponent, drawStruct.bitsPerPixel, drawStruct.bytesPerRow, colorSpace, bitmapInfo, dataProvider, NULL, NO, kCGRenderingIntentDefault);//kCGRenderingIntentDefault
    
    return imageRef;
}

#pragma mark - ImageRefWithBufferDirect
const void * SALGetBytePointer(void * info) {
    
    NSLog(@"SALGetBytePointer %p", info);
    // this is currently only called once
    return info; // info is a pointer to the buffer
}

void SALReleaseBytePointer(void * info, const void * pointer) {
    // don't care, just using the one static buffer at the moment
    NSLog(@"SALReleaseBytePointer %p %p", info, pointer);
}

size_t SALGetBytesAtPosition(void * info, void * buffer, off_t position, size_t count) {
    
    NSLog(@"SALGetBytesAtPosition %p %lld %zu", info, position, count);
    // I don't think this ever gets called
//    memcpy(buffer, ((char*)info) + position, count);
    return count;
}

void SALProviderReleaseInfoCallback(void * __nullable info) {
    
    NSLog(@"SALProviderReleaseInfoCallback %p", info);
}

CGImageRef SALImageRefWithBufferDirect(SALPixel_8888 * currentBuffer, SALImageInfoStruct drawStruct, CGBitmapInfo bitmapInfo, CGColorSpaceRef colorSpace) {
    
    //生成的imageRef 与buffer绑定，free时导致imageRef崩溃
    CGDataProviderDirectCallbacks providerCallbacks = {0, SALGetBytePointer, SALReleaseBytePointer, SALGetBytesAtPosition, SALProviderReleaseInfoCallback};
    
    CGDataProviderRef dataProvider = CGDataProviderCreateDirect(currentBuffer, drawStruct.bytesPerPixel * drawStruct.pixelNum, &providerCallbacks);
    
    CGImageRef imageRef = CGImageCreate(drawStruct.imageRefWidth, drawStruct.imageRefHeight, drawStruct.bitsPerComponent, drawStruct.bitsPerPixel, drawStruct.bytesPerRow, colorSpace, bitmapInfo, dataProvider, NULL, NO, kCGRenderingIntentDefault);//kCGRenderingIntentDefault
    
    CGDataProviderRelease(dataProvider);
    
    return imageRef;
}

#pragma mark -






@interface SalImageInfo ()

@property (nonatomic, assign) BOOL       needClearBufferImageRef;
@property (nonatomic, assign) BOOL       needFreeBufferImageRef;

@property (nonatomic, assign) BOOL       needClearBufferImage;
@property (nonatomic, assign) BOOL       needClearImage;

@property (nonatomic, assign) BOOL       needClearImageRef;
@property (nonatomic, assign) BOOL       needFreeImageRef;

@property (nonatomic, assign) BOOL       needClearBuffer;
@property (nonatomic, assign) BOOL       needFreeBuffer;

@property (nonatomic, assign) BOOL       needClearContextRef;
@property (nonatomic, assign) BOOL       needFreeContextRef;

@property (nonatomic, readwrite) UIImage     *   image;
@property (nonatomic, readwrite) CGImageRef      imageRef;

@property (nonatomic, readwrite) UIImage     *   bufferImage;
@property (nonatomic, readwrite) CGImageRef      bufferImageRef;

@end

@implementation SalImageInfo

- (void)encodeWithCoder:(NSCoder *)coder {
    
    NSUInteger length = _imageStruct.pixelNum * _imageStruct.bytesPerPixel;
    NSData * bufferData = [NSData dataWithBytes:_imageBuffer length:length];
    NSData * structData = [NSData dataWithBytes:&_imageStruct length:sizeof(SALImageInfoStruct)];
    
    [coder encodeObject:bufferData forKey:@"imageBuffer"];
    [coder encodeObject:structData forKey:@"imageStruct"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    
    NSData * bufferData = [coder decodeObjectOfClass:[NSData class] forKey:@"imageBuffer"];
    NSData * structData = [coder decodeObjectOfClass:[NSData class] forKey:@"imageStruct"];
    SALImageInfoStruct imageInfoStruct = {0};
    SALPixel_8888 * buffer = NULL;
    
    if (structData) {
        [structData getBytes:&imageInfoStruct length:sizeof(SALImageInfoStruct)];
    }
    if (bufferData && imageInfoStruct.imageRefScale > 0 && imageInfoStruct.imageRefScale < 15) {
        NSUInteger length = imageInfoStruct.pixelNum * imageInfoStruct.bytesPerPixel;
        buffer = calloc(imageInfoStruct.bytesPerPixel, imageInfoStruct.pixelNum);
        [bufferData getBytes:buffer length:length];
    } else {
        return nil;
    }
    self = [super init];
    if (self) {
        _imageStruct = imageInfoStruct;
        _imageBuffer = buffer;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    
    SalImageInfo * imageInfo = [SalImageInfo new];
    imageInfo.imageStruct    = self.imageStruct;
    imageInfo.imageBuffer    = calloc(imageInfo.imageStruct.bytesPerPixel, imageInfo.imageStruct.pixelNum);
    memcpy(imageInfo.imageBuffer, self.imageBuffer, imageInfo.imageStruct.pixelNum * imageInfo.imageStruct.bytesPerPixel);
    
    return imageInfo;
}

+ (instancetype)instanceWithSize:(CGSize)size scale:(float)scale {
    
    if (size.width > 0 && size.height > 0 && scale > 0) {
        SALImageInfoStruct imageStruct = SALImageStructMake(size, scale);
        if (imageStruct.pixelNum > 0) {
            SalImageInfo * imageInfo = [SalImageInfo new];
            imageInfo.imageStruct    = imageStruct;
            imageInfo.imageBuffer    = calloc(imageInfo.imageStruct.bytesPerPixel, imageInfo.imageStruct.pixelNum);
            return imageInfo;
        }
    }
    return nil;
}

#pragma mark - SET METHOD
- (void)setContextRef:(CGContextRef)contextRef {
    
    [self clearContextIfNeed];
    _contextRef = contextRef;
}

- (void)setImageBuffer:(SALPixel_8888 *)imageBuffer {
    
    [self clearBufferIfNeed];
    _imageBuffer = imageBuffer;
}

#pragma mark - GET METHOD
- (CGImageRef)imageRef {
    
    [self clearImageRefIfNeed];
    [self clearContextIfNeed];
    if (_imageRef == NULL && _contextRef != NULL) {
        _imageRef = SALImageRefWithContext(_contextRef);
    }
    return _imageRef;
}

- (UIImage *)image {
    
    [self clearImageIfNeed];
    if (_image == nil) {
        _image = SALImageWithImageRef(self.imageRef, _imageStruct.imageRefScale, UIImageOrientationUp);
    }
    return _image;
}

- (CGImageRef)bufferImageRef {
    
    [self clearBufferImageRefIfNeed];
    [self clearBufferIfNeed];
    if (_bufferImageRef == NULL && _imageBuffer != NULL) {
        _bufferImageRef = SALImageRefWithBufferData(_imageBuffer, _imageStruct, SALBitmapInfo, SALGetColorSpace());
//        _bufferImageRef = SALImageRefWithBufferDirect(_imageBuffer, _imageStruct, SALBitmapInfo, SALGetColorSpace());
//        _bufferImageRef = SALImageRefWithBufferSequential(_imageBuffer, _imageStruct, SALBitmapInfo, SALGetColorSpace());
    }
    return _bufferImageRef;
}

- (UIImage *)bufferImage {
    
    [self clearBufferImageIfNeed];
    if (_bufferImage == nil) {
        _bufferImage = SALImageWithImageRef(self.bufferImageRef, _imageStruct.imageRefScale, UIImageOrientationUp);
    }
    return _bufferImage;
}

#pragma mark - SIZE
- (CGSize)drawSize {

    return CGSizeMake(_imageStruct.imageRefWidth, _imageStruct.imageRefHeight);
}

- (CGSize)showSize {
    
    return CGSizeMake(_imageStruct.imageRefWidth/_imageStruct.imageRefScale, _imageStruct.imageRefHeight/_imageStruct.imageRefScale);
}

#pragma mark - GET Image
- (UIImage *)getImage:(BOOL)useBuffer {
    
    return self.image;
}

- (UIImage *)getCurrentImage:(BOOL)useBuffer {
 
    if (useBuffer) {
        return self.bufferImage;
    }
    return self.image;
}

- (CGImageRef)getCurrentImageRef:(BOOL)useBuffer {
    
    if (useBuffer) {
        return self.bufferImageRef;
    }
    return self.imageRef;
}

#pragma mark - Need Clear Free
- (void)clearBufferAndFree:(BOOL)needFree now:(BOOL)now {
    
    _needClearBuffer = YES;
    _needFreeBuffer  = needFree;
    if (now) {
        [self clearBufferIfNeed];
    }
}

- (void)clearContextAndFree:(BOOL)needFree now:(BOOL)now {
    
    _needClearContextRef = YES;
    _needFreeContextRef  = needFree;
    if (now) {
        [self clearContextIfNeed];
    }
}

- (void)clearBufferImageRefAndFree:(BOOL)needFree now:(BOOL)now {
    
    _needClearBufferImageRef = YES;
    _needFreeBufferImageRef  = needFree;
    if (now) {
        [self clearBufferImageRefIfNeed];
    }
}

- (void)clearContextImageRefAndFree:(BOOL)needFree now:(BOOL)now {
    
    _needClearImageRef = YES;
    _needFreeImageRef  = needFree;
    if (now) {
        [self clearImageRefIfNeed];
    }
}

- (void)clearContextImage:(BOOL)now {

    _needClearImage = YES;
    if (now) {
        [self clearImageIfNeed];
    }
}

- (void)clearBufferImage:(BOOL)now {
    
    _needClearBufferImage = YES;
    if (now) {
        [self clearBufferImageIfNeed];
    }
}

#pragma mark - Clear

- (void)clearContextIfNeed {
    
    if (_needClearContextRef) {
        if (_needFreeContextRef && _contextRef != NULL) {
            CGContextRelease(_contextRef);
        }
        _contextRef = NULL;
    }
    _needFreeContextRef  = NO;
    _needClearContextRef = NO;
}

- (void)clearBufferImageRefIfNeed {
    
    if (_needClearBufferImageRef) {
        if (_needFreeBufferImageRef && _bufferImageRef != NULL) {
            CGImageRelease(_bufferImageRef);
        }
        _bufferImageRef = NULL;
    }
    _needFreeBufferImageRef  = NO;
    _needClearBufferImageRef = NO;
}

- (void)clearImageRefIfNeed {
    
    if (_needClearImageRef) {
        if (_needFreeImageRef && _imageRef != NULL) {
            CGImageRelease(_imageRef);
        }
        _imageRef = NULL;
    }
    _needFreeImageRef  = NO;
    _needClearImageRef = NO;
}

- (void)clearBufferIfNeed {
    
    if (_needClearBuffer) {
        if (_needFreeBuffer && _imageBuffer != NULL) {
            free(_imageBuffer);
        }
        _imageBuffer = NULL;
    }
    _needClearBuffer = NO;
    _needFreeBuffer  = NO;
}

- (void)clearImageIfNeed {
    
    if (_needClearImage && _image != nil) {
        _image = nil;
    }
    _needClearImage = NO;
}

- (void)clearBufferImageIfNeed {
    
    if (_needClearBufferImage && _bufferImage != nil) {
        _bufferImage = nil;
    }
    _needClearBufferImage = NO;
}

#pragma mark - Dealloc
- (void)dealloc {
    
    _image       = nil;
    _bufferImage = nil;
    if (_imageRef != NULL) {
        CGImageRelease(_imageRef);
    }
    if (_bufferImageRef != NULL) {
        CGImageRelease(_bufferImageRef);
    }
    if (_contextRef != NULL) {
        CGContextRelease(_contextRef);
    }
    if (_imageBuffer != NULL) {
        free(_imageBuffer);
    }
    _contextRef     = NULL;
    _imageRef       = NULL;
    _imageBuffer    = NULL;
    _bufferImageRef = NULL;
}

@end
