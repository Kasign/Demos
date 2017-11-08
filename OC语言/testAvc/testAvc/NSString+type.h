//
//  NSString+type.h
//  
//  Created by FLY on 2017/10/20.
//  Copyright © 2017年 FLY. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#pragma mark - DateFormatter type
FOUNDATION_EXTERN NSString * const kDateFormatterTypeFull   ;
FOUNDATION_EXTERN NSString * const kDateFormatterTypeLong   ;
FOUNDATION_EXTERN NSString * const kDateFormatterTypeMiddle ;
FOUNDATION_EXTERN NSString * const kDateFormatterTypeShort  ;
FOUNDATION_EXTERN NSString * const kDateFormatterTypeYear   ;
FOUNDATION_EXTERN NSString * const kDateFormatterTypeMonth  ;
FOUNDATION_EXTERN NSString * const kDateFormatterTypeDay    ;
FOUNDATION_EXTERN NSString * const kDateFormatterTypeHour   ;
FOUNDATION_EXTERN NSString * const kDateFormatterTypeMinute ;
FOUNDATION_EXTERN NSString * const kDateFormatterTypeSecond ;

#pragma mark - layer
// CALayer
FOUNDATION_EXTERN NSString * const kANIMALayerBackgroundColor  ;
FOUNDATION_EXTERN NSString * const kANIMALayerBounds           ;
FOUNDATION_EXTERN NSString * const kANIMALayerCornerRadius     ;
FOUNDATION_EXTERN NSString * const kANIMALayerBorderWidth      ;
FOUNDATION_EXTERN NSString * const kANIMALayerBorderColor      ;
FOUNDATION_EXTERN NSString * const kANIMALayerOpacity          ;
FOUNDATION_EXTERN NSString * const kANIMALayerPosition         ;
FOUNDATION_EXTERN NSString * const kANIMALayerPositionX        ;
FOUNDATION_EXTERN NSString * const kANIMALayerPositionY        ;
FOUNDATION_EXTERN NSString * const kANIMALayerRotation         ;
FOUNDATION_EXTERN NSString * const kANIMALayerRotationX        ;
FOUNDATION_EXTERN NSString * const kANIMALayerRotationY        ;
FOUNDATION_EXTERN NSString * const kANIMALayerScaleX           ;
FOUNDATION_EXTERN NSString * const kANIMALayerScaleXY          ;
FOUNDATION_EXTERN NSString * const kANIMALayerScaleY           ;
FOUNDATION_EXTERN NSString * const kANIMALayerSize             ;
FOUNDATION_EXTERN NSString * const kANIMALayerSubscaleXY       ;
FOUNDATION_EXTERN NSString * const kANIMALayerSubtranslationX  ;
FOUNDATION_EXTERN NSString * const kANIMALayerSubtranslationXY ;
FOUNDATION_EXTERN NSString * const kANIMALayerSubtranslationY  ;
FOUNDATION_EXTERN NSString * const kANIMALayerSubtranslationZ  ;
FOUNDATION_EXTERN NSString * const kANIMALayerTranslationX     ;
FOUNDATION_EXTERN NSString * const kANIMALayerTranslationXY    ;
FOUNDATION_EXTERN NSString * const kANIMALayerTranslationY     ;
FOUNDATION_EXTERN NSString * const kANIMALayerTranslationZ     ;
FOUNDATION_EXTERN NSString * const kANIMALayerZPosition        ;
FOUNDATION_EXTERN NSString * const kANIMALayerShadowColor      ;
FOUNDATION_EXTERN NSString * const kANIMALayerShadowOffset     ;
FOUNDATION_EXTERN NSString * const kANIMALayerShadowOpacity    ;
FOUNDATION_EXTERN NSString * const kANIMALayerShadowRadius     ;

#pragma mark - CAShapeLayer
FOUNDATION_EXTERN NSString * const kANIMAShapeLayerStrokeStart   ;
FOUNDATION_EXTERN NSString * const kANIMAShapeLayerStrokeEnd     ;
FOUNDATION_EXTERN NSString * const kANIMAShapeLayerStrokeColor   ;
FOUNDATION_EXTERN NSString * const kANIMAShapeLayerFillColor     ;
FOUNDATION_EXTERN NSString * const kANIMAShapeLayerLineWidth     ;
FOUNDATION_EXTERN NSString * const kANIMAShapeLayerLineDashPhase ;

#pragma mark - NSLayoutConstraint
/**
 Common NSLayoutConstraint property names.
 */
FOUNDATION_EXTERN NSString * const kANIMALayoutConstraintConstant  ;

#pragma mark - UIView
/**
 Common UIView property names.
 */
FOUNDATION_EXTERN NSString * const kANIMAViewAlpha;
FOUNDATION_EXTERN NSString * const kANIMAViewBackgroundColor;
FOUNDATION_EXTERN NSString * const kANIMAViewBounds;
FOUNDATION_EXTERN NSString * const kANIMAViewCenter;
FOUNDATION_EXTERN NSString * const kANIMAViewFrame;
FOUNDATION_EXTERN NSString * const kANIMAViewScaleX;
FOUNDATION_EXTERN NSString * const kANIMAViewScaleXY;
FOUNDATION_EXTERN NSString * const kANIMAViewScaleY;
FOUNDATION_EXTERN NSString * const kANIMAViewSize;
FOUNDATION_EXTERN NSString * const kANIMAViewTintColor;

#pragma mark - UIScrollView
/**
 Common UIScrollView property names.
 */
FOUNDATION_EXTERN NSString * const kANIMAScrollViewContentOffset;
FOUNDATION_EXTERN NSString * const kANIMAScrollViewContentSize;
FOUNDATION_EXTERN NSString * const kANIMAScrollViewZoomScale;
FOUNDATION_EXTERN NSString * const kANIMAScrollViewContentInset;
FOUNDATION_EXTERN NSString * const kANIMAScrollViewScrollIndicatorInsets;

#pragma mark - UITableView
/**
 Common UITableView property names.
 */
FOUNDATION_EXTERN NSString * const kANIMATableViewContentOffset;
FOUNDATION_EXTERN NSString * const kANIMATableViewContentSize;

#pragma mark - UICollectionView
/**
 Common UICollectionView property names.
 */
FOUNDATION_EXTERN NSString * const kANIMACollectionViewContentOffset;
FOUNDATION_EXTERN NSString * const kANIMACollectionViewContentSize;

#pragma mark - UINavigationBar
/**
 Common UINavigationBar property names.
 */
FOUNDATION_EXTERN NSString * const kANIMANavigationBarBarTintColor;

#pragma mark - UIToolbar
/**
 Common UIToolbar property names.
 */
FOUNDATION_EXTERN NSString * const kANIMAToolbarBarTintColor;

#pragma mark - UITabBar
/**
 Common UITabBar property names.
 */
FOUNDATION_EXTERN NSString * const kANIMATabBarBarTintColor;

#pragma mark - UILabel
/**
 Common UILabel property names.
 */
FOUNDATION_EXTERN NSString * const kANIMALabelTextColor;

#else

#pragma mark - NSView
/**
 Common NSView property names.
 */
FOUNDATION_EXTERN NSString * const kANIMAViewFrame;
FOUNDATION_EXTERN NSString * const kANIMAViewBounds;
FOUNDATION_EXTERN NSString * const kANIMAViewAlphaValue;
FOUNDATION_EXTERN NSString * const kANIMAViewFrameRotation;
FOUNDATION_EXTERN NSString * const kANIMAViewFrameCenterRotation;
FOUNDATION_EXTERN NSString * const kANIMAViewBoundsRotation;

#pragma mark - NSWindow
/**
 Common NSWindow property names.
 */
FOUNDATION_EXTERN NSString * const kANIMAWindowFrame;
FOUNDATION_EXTERN NSString * const kANIMAWindowAlphaValue;
FOUNDATION_EXTERN NSString * const kANIMAWindowBackgroundColor;

# endif

# if TARGET_OS_MAC || TARGET_OS_IPHONE

#pragma mark - SceneKit
/**
 Common SceneKit property names.
 */
FOUNDATION_EXTERN NSString * const kANIMASCNNodePosition;
FOUNDATION_EXTERN NSString * const kANIMASCNNodePositionX;
FOUNDATION_EXTERN NSString * const kANIMASCNNodePositionY;
FOUNDATION_EXTERN NSString * const kANIMASCNNodePositionZ;
FOUNDATION_EXTERN NSString * const kANIMASCNNodeTranslation;
FOUNDATION_EXTERN NSString * const kANIMASCNNodeTranslationX;
FOUNDATION_EXTERN NSString * const kANIMASCNNodeTranslationY;
FOUNDATION_EXTERN NSString * const kANIMASCNNodeTranslationZ;
FOUNDATION_EXTERN NSString * const kANIMASCNNodeRotation;
FOUNDATION_EXTERN NSString * const kANIMASCNNodeRotationX;
FOUNDATION_EXTERN NSString * const kANIMASCNNodeRotationY;
FOUNDATION_EXTERN NSString * const kANIMASCNNodeRotationZ;
FOUNDATION_EXTERN NSString * const kANIMASCNNodeRotationW;
FOUNDATION_EXTERN NSString * const kANIMASCNNodeEulerAngles;
FOUNDATION_EXTERN NSString * const kANIMASCNNodeEulerAnglesX;
FOUNDATION_EXTERN NSString * const kANIMASCNNodeEulerAnglesY;
FOUNDATION_EXTERN NSString * const kANIMASCNNodeEulerAnglesZ;
FOUNDATION_EXTERN NSString * const kANIMASCNNodeOrientation;
FOUNDATION_EXTERN NSString * const kANIMASCNNodeOrientationX;
FOUNDATION_EXTERN NSString * const kANIMASCNNodeOrientationY;
FOUNDATION_EXTERN NSString * const kANIMASCNNodeOrientationZ;
FOUNDATION_EXTERN NSString * const kANIMASCNNodeOrientationW;
FOUNDATION_EXTERN NSString * const kANIMASCNNodeScale;
FOUNDATION_EXTERN NSString * const kANIMASCNNodeScaleX;
FOUNDATION_EXTERN NSString * const kANIMASCNNodeScaleY;
FOUNDATION_EXTERN NSString * const kANIMASCNNodeScaleZ;
FOUNDATION_EXTERN NSString * const kANIMASCNNodeScaleXY;

#endif
