//
//  UIDevice+Rotate.h
//  SYKRotateDemo
//
//  Created by Walg on 2021/8/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Rotate)

/// 获取当前方向
+ (UIInterfaceOrientation)interfaceOrientation;

/// 打开旋转开关，在合适时机需要关闭，对应到 AppDelegate 中的Api supportedInterfaceOrientationsForWindow，某些系统版本有效
+ (void)changeRotateSwitch:(BOOL)open;

/// 是否打开总开关
+ (BOOL)supportRotate;

/// 支持的方向
+ (UIInterfaceOrientationMask)supportedInterfaceOrientations;

/// 设置旋转
+ (void)rotateScreeen:(UIInterfaceOrientation)orientation;

@end

NS_ASSUME_NONNULL_END
