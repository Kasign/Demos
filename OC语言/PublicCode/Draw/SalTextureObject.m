//
//  SalTextureObject.m
//  Unity-iPhone
//
//  Created by Qiushan on 2020/6/18.
//

#import "SalTextureObject.h"
#import "SalContent.h"
#import "SalStorageInstance.h"
#import "SALSteam.h"


@interface SalTextureObject ()

@property (nonatomic, copy, readwrite) NSString    *   key;
@property (nonatomic, strong) UIImage              *   oriImage;
@property (nonatomic, assign) SalStorageType           keyStorageType;
@property (nonatomic, assign) BOOL                     isOriNil;       //是否初始为空
@property (nonatomic, assign) BOOL                     isCropToNil;
@property (nonatomic, assign) BOOL                     isSmallSize;
@property (nonatomic, assign) BOOL                     isBigShow;
@property (nonatomic, assign) CGSize                   nodeSize;
@property (nonatomic, strong) NSArray              *   nineInfoArr;
@property (nonatomic, strong) SALSteam             *   steam;
@property (nonatomic, strong) SalImageInfo         *   oriImageInfo;   //原始数据解析的info

@end

@implementation SalTextureObject

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _visibleArea = CGRectMake(0, 0, 1, 1);
        _cropRect    = CGRectMake(0, 0, 1, 1);
        _edgeInsets  = SALEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}

- (void)clearData {
    
    _key            = nil;
    _oriImage       = nil;
    _oriImageInfo   = nil;
    _nineInfoArr    = nil;
    _isOriNil       = NO;
    _isCropToNil    = NO;
    _keyStorageType = SalStorageType_NONE;
    _cropRect       = CGRectZero;
    _steam.cropArea = CGRectMake(0, 0, 1, 1);
}

- (SALSteam *)steam {
    
    if (_steam == nil) {
        _steam = [[SALSteam alloc] init];
    }
    return _steam;
}

#pragma mark - change texture
- (void)changeTextureWithKey:(NSString *)key block:(TextureChangeBlock)block {
    
    [self clearData];
    if ([key isKindOfClass:[NSString class]]) {
        
        _key = [SalDataTool getStr:key];
        //容错
        if (_key.length == 0) {
            _isOriNil = YES;
            [self willDisplayTexture];
            if (block) {
                block(self, NO);
            }
            return;
        }
        
        __weak __typeof(self) weakSelf = self;
        [SalImageDataCenter cache_imageResourceObjectWithStr:key block:^(SalResourceObject * _Nonnull resourceObject, BOOL isUrl) {
            
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            CGSize showSize = CGSizeZero;
            if (resourceObject) {
                strongSelf.keyStorageType  = resourceObject.storageType;
                strongSelf.oriImageInfo    = resourceObject.imageInfo;
                strongSelf.steam.imageInfo = resourceObject.imageInfo;
                if (strongSelf.oriImageInfo == nil) {
                    strongSelf.oriImage = [resourceObject getData];
                    strongSelf.oriImage = [SalDataTool salImageWithData:strongSelf.oriImage];
                    showSize = strongSelf.oriImage.size;
                } else {
                    showSize = strongSelf.oriImageInfo.showSize;
                }
            } else if (!isUrl) {
                strongSelf.oriImage = [SalDataTool salImageWithData:key];
                showSize = strongSelf.oriImage.size;
            } else {
                if (block) {
                    block(strongSelf, NO);
                }
                return;
            }
            
            if (showSize.width < 3 || showSize.height < 3) {
                strongSelf.isSmallSize = YES;
            } else {
                strongSelf.isSmallSize = NO;
            }
            
            [strongSelf changeEdgeInsetsInfoIfNeed];
            [strongSelf prepareDisplayTexture];
            
            if (block) {
                if (strongSelf.contentNode.texture) {
                    block(strongSelf, YES);
                } else {
                    block(strongSelf, NO);
                }
            }
        }];
    } else {
        _isOriNil = YES;
        [self prepareDisplayTexture];
        if (block) {
            block(self, NO);
        }
    }
}

 - (void)changeOriInfoAndDisplay:(SalImageInfo *)imageInfo block:(TextureChangeBlock)block {
    
     [self clearData];
     if ([imageInfo isKindOfClass:[SalImageInfo class]]) {
         
         _oriImageInfo = imageInfo;
         CGSize showSize = imageInfo.showSize;
         if (showSize.width < 3 || showSize.height < 3) {
             _isSmallSize = YES;
         } else {
             _isSmallSize = NO;
         }
         self.steam.imageInfo = imageInfo;
         [self changeEdgeInsetsInfoIfNeed];
         [self prepareDisplayTexture];
         if (block) {
             block(self, YES);
         }
     } else {
         _isOriNil = YES;
         [self prepareDisplayTexture];
         if (block) {
             block(self, NO);
         }
     }
}

- (void)changeOriImage:(UIImage *)oriImage block:(TextureChangeBlock)block {
    
    [self clearData];
    if ([oriImage isKindOfClass:[UIImage class]]) {
        
        _oriImage = oriImage;
        CGSize showSize = oriImage.size;
        if (showSize.width < 3 || showSize.height < 3) {
            _isSmallSize = YES;
        } else {
            _isSmallSize = NO;
        }
        [self changeEdgeInsetsInfoIfNeed];
        [self prepareDisplayTexture];
        if (block) {
            block(self, YES);
        }
    } else {
        _isOriNil = YES;
        [self prepareDisplayTexture];
        if (block) {
            block(self, NO);
        }
    }
}

#pragma mark - Crop
- (void)setCropRect:(CGRect)cropRect {
    
    if (!CGRectEqualToRect(_cropRect, cropRect)) {
        _cropRect = cropRect;
        [self getOriImageInfoIfNeed];
        [self cropBufferIfNeed];
        [_contentNode setSize:cropRect.size];
    }
}

- (void)cropBufferIfNeed {
    
    // 裁剪成空值
    if (_cropRect.size.width <= 0 || _cropRect.size.height <= 0) {
        _isCropToNil = YES;
        [self prepareDisplayTexture];
        return;
    }
    
    _isCropToNil = NO;
    
    CGSize oriSize      = self.steam.imageInfo.showSize;
    CGRect needCropRect = CGRectMake(0, 0, 1, 1);
    if (_cropRect.origin.x >= 0 && _cropRect.origin.y >= 0 && _cropRect.size.width >= 0 && _cropRect.size.height >= 0 && _cropRect.origin.x + _cropRect.size.width <= oriSize.width && _cropRect.origin.y + _cropRect.size.height <= oriSize.height) {
        
        CGFloat oriWidth  = oriSize.width;
        CGFloat oriHeight = oriSize.height;
        
        CGPoint point = _cropRect.origin;
        CGSize  size  = _cropRect.size;
        
        point.x = point.x * 1.0/oriWidth;
        point.y = point.y * 1.0/oriHeight;
        
        size.width  = size.width * 1.f/oriWidth;
        size.height = size.height * 1.f/oriHeight;
        
        needCropRect.origin = point;
        needCropRect.size   = size;
    }
    
    self.steam.cropArea = needCropRect;
    [self prepareDisplayTexture];
}

- (CGRect)currentCropArea {
    
    if (_steam) {
        return _steam.cropArea;
    }
    return CGRectMake(0, 0, 1, 1);
}

#pragma mark - visible
- (void)setVisibleArea:(CGRect)visibleArea {
    
    if (!CGRectEqualToRect(_visibleArea, visibleArea)) {
       
        [self getOriImageInfoIfNeed];
        _visibleArea = visibleArea;
        [self resetSteamImageInfoIfNeed];
        self.steam.visibleArea = visibleArea;
        [self prepareDisplayTexture];
    }
}

- (void)prepareDisplayTexture {
    
    [self willDisplayTexture];
}

#pragma mark - create buffer ifneed
- (void)getOriImageInfoIfNeed {
    
    if (_oriImageInfo == nil) {
        
        SalImageInfo * imageInfo = nil;
        SalResourceObject * resourceObject = nil;
        BOOL needReSave = NO;
        if (_key && _keyStorageType != SalStorageType_NONE) {
            resourceObject = [SalStorageInstance getResourceObjectWithKey:_key type:_keyStorageType];
            if (resourceObject == nil) {
                resourceObject = [SalStorageInstance getResourceObjectWithKey:_key];
            }
            if (resourceObject) {
                imageInfo = resourceObject.imageInfo;
                if (imageInfo == nil) {
                    if (_oriImage == nil) {
                        _oriImage = [resourceObject getData];
                        _oriImage = [SalDataTool salImageWithData:_oriImage];
                    }
                }
            }
        }
        
        if (imageInfo == nil && _oriImage) {
            imageInfo = [SalDrawTool decodeWithImage:_oriImage];
            //这里应该更新本地存储数据
            _oriImage = nil;//解析之后oriImage没用了，释放内存
            needReSave = imageInfo != nil;
        }
        if (imageInfo == nil && _contentNode.texture) {
            CGSize textureSize  = _contentNode.texture.size;
            CGImageRef imageRef = _contentNode.texture.CGImage;
            CGFloat scale = 2;
            scale = MIN(CGImageGetWidth(imageRef)/textureSize.width, scale);
            scale = MIN(CGImageGetHeight(imageRef)/textureSize.height, scale);
            imageInfo = [SalDrawTool decodeWithImageRef:imageRef scale:scale];
            if (imageRef != NULL) {
                CGImageRelease(imageRef);
                imageRef = NULL;
            }
            needReSave = imageInfo != nil;
        }
        if (needReSave) {
            resourceObject.imageInfo = imageInfo;
            if (_keyStorageType != SalStorageType_MEMORY && _keyStorageType != SalStorageType_NONE) {
                //这里不能动，动了出问题
                NSString * saveKey = _key;
                SalStorageType storageType = _keyStorageType;
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [SalStorageInstance saveData:resourceObject key:saveKey type:storageType];
                });
            }
        }
        CGSize showSize = imageInfo.showSize;
        if (showSize.width < 3 || showSize.height < 3) {
            _isSmallSize = YES;
        } else {
            _isSmallSize = NO;
        }
        _oriImageInfo        = imageInfo;
        self.steam.imageInfo = imageInfo;
    }
}

#pragma mark - 九宫格
- (void)setEdgeInsets:(SALEdgeInsets)edgeInsets {
    
    if (!SALEdgeInsetsEqualToEdgeInsets(_edgeInsets, edgeInsets)) {
        _edgeInsets = edgeInsets;
        [self changeEdgeInsetsInfoIfNeed];
        [self prepareDisplayTexture];
    }
}

- (void)changeEdgeInsetsInfoIfNeed {
    
    if (!SALEdgeInsetsEqualToEdgeInsets(_edgeInsets, SALEdgeInsetsMake(0, 0, 0, 0))) {//是九宫格
        
        [self getOriImageInfoIfNeed];
        if (self.oriImageInfo.showSize.width < _nodeSize.width && self.oriImageInfo.showSize.height < _nodeSize.height) {
            if (_nineInfoArr == nil) {
                _nineInfoArr = SALDivideBufferWithInsets(self.steam.imageInfo.imageBuffer, self.steam.imageInfo.imageStruct, _edgeInsets);
            }
            [self resetBufferWhenNineEdgeInsets];
        } else {
            _nineInfoArr = nil;
        }
    } else {
        _nineInfoArr = nil;
    }
}

- (void)contentNodeDidChangeSize:(SalContent *)contentNode size:(CGSize)size {
    
    if (!CGSizeEqualToSize(_nodeSize, size)) {
        _nodeSize = size;
        
        if (_nodeSize.width > 5 && _nodeSize.height > 5) {
            _isBigShow = YES;
        } else {
            _isBigShow = NO;
        }
        
        if (CGSizeEqualToSize(_nodeSize, CGSizeZero)) {
            return;
        }
        //九宫格
        if (!SALEdgeInsetsEqualToEdgeInsets(_edgeInsets, SALEdgeInsetsMake(0, 0, 0, 0))) {
            BOOL shouldChangeSizeWhenTextureChanged = _contentNode.shouldChangeSizeWhenTextureChanged;
            _contentNode.shouldChangeSizeWhenTextureChanged = NO;
            [self changeEdgeInsetsInfoIfNeed];
            [self prepareDisplayTexture];
            _contentNode.shouldChangeSizeWhenTextureChanged = shouldChangeSizeWhenTextureChanged;
        }
    }
}

- (void)resetBufferWhenNineEdgeInsets {
    
    if (!CGSizeEqualToSize(_nodeSize, CGSizeZero) && !SALEdgeInsetsEqualToEdgeInsets(_edgeInsets, SALEdgeInsetsMake(0, 0, 0, 0)) && _nineInfoArr.count > 0) {
        
        NSMutableArray * rectArr = [NSMutableArray arrayWithCapacity:9];
        
        CGSize showSize = self.oriImageInfo.showSize;
        
        size_t width  = _nodeSize.width;
        size_t height = _nodeSize.height;
        
        size_t left   = self.edgeInsets.left   * showSize.width;
        size_t right  = self.edgeInsets.right  * showSize.width;
        size_t top    = self.edgeInsets.top    * showSize.height;
        size_t bottom = self.edgeInsets.bottom * showSize.height;
        
        size_t x = 0, y = 0, w = left, h = top;
        
        while (1) {
            
            CGRect rect = CGRectMake(x, y, w, h);
            [rectArr addObject:[NSValue valueWithCGRect:rect]];
            
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
        _isSmallSize = NO;
        self.steam.imageInfo = [SalDataTool mergeImageInfoWithArr:_nineInfoArr rectArr:rectArr currentSize:_nodeSize targetSize:_nodeSize];
    }
}

- (void)resetSteamImageInfoIfNeed {
    
    if (self.steam.isSteam) {
        
        if (_isSmallSize && _isBigShow) {
            
            CGSize showSize = self.steam.imageInfo.showSize;
            CGFloat scale   = 10.f/showSize.width;
            scale = MAX(scale, 10.f/showSize.height);
            
            SalImageInfo * newImageInfo = [SalDataTool changeImageInfo:_oriImageInfo changeBlock:^(SalDrawTask * _Nonnull drawTask, SalImageTask * _Nonnull imageTask) {
                imageTask.drawRect = CGRectMake(0, 0, showSize.width * scale, showSize.height * scale);
                drawTask.drawSize = CGSizeMake(showSize.width * scale, showSize.height * scale);
            }];
            [_oriImageInfo clearBufferImage:NO];
            [_oriImageInfo clearBufferImageRefAndFree:YES now:NO];
            self.steam.imageInfo = newImageInfo;
            _isSmallSize = NO;
        }
    }
}

#pragma mark - Display Texture
- (void)willDisplayTexture {
    
    SalTexture * texture = nil;
    UIImage * image = [self currentImage];
    if (image) {
        texture = [SalTexture textureWithImage:image];
    }
    [self displayWithTexture:texture];
}

- (UIImage *)currentImage {
    
    UIImage * image = nil;
    if (!_isOriNil && !_isCropToNil) {
        if (self.steam.isSteam) {
            image = [self.steam currentImage];
        } else if (_oriImage) {
            image = _oriImage;
        }
    }
    return image;
}

- (void)displayWithTexture:(SKTexture *)texture {
    
    [_contentNode setTexture:texture];
}

#pragma mark - 状态判断

- (UIColor *)colorAtPixel:(CGPoint)point currentSize:(CGSize)currentSize {
    
    [self getOriImageInfoIfNeed];
    return SALGetColorWithOff(self.steam.imageInfo.imageBuffer, self.steam.imageInfo.imageStruct, self.steam.cropArea, self.steam.visibleArea, point, currentSize);
}

- (float)alphaAtPixel:(CGPoint)point currentSize:(CGSize)currentSize {

    UIColor * targetColor = [self colorAtPixel:point currentSize:currentSize];
    if ([targetColor isKindOfClass:[UIColor class]]) {
        return CGColorGetAlpha(targetColor.CGColor);
    }
    return -1;
}

- (void)dealloc {
    
    _contentNode = nil;
    if (self) {
        [self clearData];
    }
}

- (NSString *)debugDescription {
    
    return [NSString stringWithFormat:@"%@\n Key:%@\n ContentNode:%@\n CropRect:%@\n VisibleArea:%@\n EdgeInsets:(%f, %f, %f, %f)",
            [super debugDescription],
            _key,
            [self.contentNode debugShortDescription],
            NSStringFromCGRect(_cropRect),
            NSStringFromCGRect(_visibleArea),
            _edgeInsets.top,
            _edgeInsets.left,
            _edgeInsets.bottom,
            _edgeInsets.right];
}

@end
