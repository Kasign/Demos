//
//  FLYImageChangeInstance.h
//  图像修改器
//
//  Created by Qiushan on 2020/1/16.
//  Copyright © 2020 FLY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYImageChangeInstance : NSObject

@property (nonatomic, assign) int  radius;//半径

- (void)setCurrentImage:(UIImage *)image;

- (UIColor *)getColorAtPixel:(CGPoint)position currentSize:(CGSize)currentSize;
- (void)changeImageColorAtPixel:(CGPoint)position currentSize:(CGSize)currentSize color:(UIColor *)color;
- (void)changeImageDirection:(int)direction;
- (void)changeImageAlphaAtPixel:(CGPoint)position currentSize:(CGSize)currentSize alpha:(CGFloat)alpha;
- (UIImage *)getCurrentImage;

@end

NS_ASSUME_NONNULL_END
