//
//  FLYImageChangeManager.m
//  图像修改器
//
//  Created by Qiushan on 2020/1/16.
//  Copyright © 2020 FLY. All rights reserved.
//

#import "FLYImageChangeManager.h"
#import "FLYImageChangeInstance.h"

@interface FLYImageChangeManager ()

@property (nonatomic, strong) UIColor *currentColor;
@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, strong) FLYImageChangeInstance *changInstance;

@end

@implementation FLYImageChangeManager

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _changInstance = [[FLYImageChangeInstance alloc] init];
        self.radius = 1;
        _currentAlpha = 0.94;
    }
    return self;
}

- (void)setOriImage:(UIImage *)oriImage {
    
    _oriImage     = oriImage;
    _currentImage = oriImage;
    [_changInstance setCurrentImage:oriImage];
}

- (void)setRadius:(NSInteger)radius {
    
    _radius = radius;
    [_changInstance setRadius:(int)radius];
}

- (void)setChangType:(FLYImageChangeType)changType {
    
    _changType = changType;
    if (changType == FLYImageChangeType_ChangeHorizontal || changType == FLYImageChangeType_ChangeVertical) {
        [_changInstance changeImageDirection:(changType == FLYImageChangeType_ChangeHorizontal ? 1 : changType == FLYImageChangeType_ChangeVertical ? 2 : 0)];
        _currentImage = [_changInstance getCurrentImage];
    }
}

- (void)pixelWithPosition:(CGPoint)position currentSize:(CGSize)currentSize {
    
    switch (_changType) {
        case FLYImageChangeType_GetColor:
            _currentColor = [_changInstance getColorAtPixel:position currentSize:currentSize];
            _changType = FLYImageChangeType_ChangeColor;
            return;
        case FLYImageChangeType_ChangeColor:
            [_changInstance changeImageColorAtPixel:position currentSize:currentSize color:_currentColor];
            break;
        case FLYImageChangeType_ChangeAlpha:
            [_changInstance changeImageAlphaAtPixel:position currentSize:currentSize alpha:_currentAlpha];
            break;
            
        default:
            break;
    }
    
    _currentImage = [_changInstance getCurrentImage];
}

@end
