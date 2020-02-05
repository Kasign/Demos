//
//  FLYImageChangeManager.h
//  图像修改器
//
//  Created by Qiushan on 2020/1/16.
//  Copyright © 2020 FLY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FLYImageChangeType) {
    FLYImageChangeType_None     = 0,
    FLYImageChangeType_GetColor = 1,
    FLYImageChangeType_ChangeColor,
    FLYImageChangeType_ChangeAlpha,
    FLYImageChangeType_ChangeHorizontal,
    FLYImageChangeType_ChangeVertical,
};

@interface FLYImageChangeManager : NSObject

@property (nonatomic, strong, readonly) UIImage * currentImage;
@property (nonatomic, strong, readonly) UIColor * currentColor;
@property (nonatomic, strong) UIImage           * oriImage;
@property (nonatomic, assign) FLYImageChangeType  changType;
@property (nonatomic, assign) CGFloat             currentAlpha;
@property (nonatomic, assign) NSInteger           radius; //半径


- (void)pixelWithPosition:(CGPoint)position currentSize:(CGSize)currentSize;

@end

NS_ASSUME_NONNULL_END
