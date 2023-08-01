//
//  NSString+type.m
//  
//  Created by FLY on 2017/10/20.
//  Copyright © 2017年 FLY. All rights reserved.
//

#import "NSString+type.h"

#if TARGET_OS_IPHONE

#pragma mark - date formatter type
NSString  *const kDateFormatterTypeFull   = @"yyyy-MM-dd HH:mm:ss";
NSString  *const kDateFormatterTypeLong   = @"yyyy-MM-dd HH:mm";
NSString  *const kDateFormatterTypeMiddle = @"MM-dd HH:mm";
NSString  *const kDateFormatterTypeShort  = @"HH:mm";
NSString  *const kDateFormatterTypeYear   = @"yyyy";
NSString  *const kDateFormatterTypeMonth  = @"MM";
NSString  *const kDateFormatterTypeDay    = @"dd";
NSString  *const kDateFormatterTypeHour   = @"HH";
NSString  *const kDateFormatterTypeMinute = @"mm";
NSString  *const kDateFormatterTypeSecond = @"ss";

#pragma mark - layer
// CALayer
NSString  *const kANIMALayerBackgroundColor  = @"backgroundColor";
NSString  *const kANIMALayerBounds           = @"bounds";
NSString  *const kANIMALayerCornerRadius     = @"cornerRadius";
NSString  *const kANIMALayerBorderWidth      = @"borderWidth";
NSString  *const kANIMALayerBorderColor      = @"borderColor";
NSString  *const kANIMALayerOpacity          = @"opacity";
NSString  *const kANIMALayerPosition         = @"position";
NSString  *const kANIMALayerPositionX        = @"positionX";
NSString  *const kANIMALayerPositionY        = @"positionY";
NSString  *const kANIMALayerRotation         = @"rotation";
NSString  *const kANIMALayerRotationX        = @"rotationX";
NSString  *const kANIMALayerRotationY        = @"rotationY";
NSString  *const kANIMALayerScaleX           = @"scaleX";
NSString  *const kANIMALayerScaleXY          = @"scaleXY";
NSString  *const kANIMALayerScaleY           = @"scaleY";
NSString  *const kANIMALayerSize             = @"size";
NSString  *const kANIMALayerSubscaleXY       = @"subscaleXY";
NSString  *const kANIMALayerSubtranslationX  = @"subtranslationX";
NSString  *const kANIMALayerSubtranslationXY = @"subtranslationXY";
NSString  *const kANIMALayerSubtranslationY  = @"subtranslationY";
NSString  *const kANIMALayerSubtranslationZ  = @"subtranslationZ";
NSString  *const kANIMALayerTranslationX     = @"translationX";
NSString  *const kANIMALayerTranslationXY    = @"translationXY";
NSString  *const kANIMALayerTranslationY     = @"translationY";
NSString  *const kANIMALayerTranslationZ     = @"translationZ";
NSString  *const kANIMALayerZPosition        = @"zPosition";
NSString  *const kANIMALayerShadowColor      = @"shadowColor";
NSString  *const kANIMALayerShadowOffset     = @"shadowOffset";
NSString  *const kANIMALayerShadowOpacity    = @"shadowOpacity";
NSString  *const kANIMALayerShadowRadius     = @"shadowRadius";

#pragma mark - CAShapeLayer
NSString  *const kANIMAShapeLayerStrokeStart   = @"shapeLayer.strokeStart";
NSString  *const kANIMAShapeLayerStrokeEnd     = @"shapeLayer.strokeEnd";
NSString  *const kANIMAShapeLayerStrokeColor   = @"shapeLayer.strokeColor";
NSString  *const kANIMAShapeLayerFillColor     = @"shapeLayer.fillColor";
NSString  *const kANIMAShapeLayerLineWidth     = @"shapeLayer.lineWidth";
NSString  *const kANIMAShapeLayerLineDashPhase = @"shapeLayer.lineDashPhase";

#pragma mark - NSLayoutConstraint
NSString  *const kANIMALayoutConstraintConstant = @"layoutConstraint.constant";

#pragma mark - UIView
NSString  *const kANIMAViewAlpha           = @"view.alpha";
NSString  *const kANIMAViewBackgroundColor = @"view.backgroundColor";
NSString  *const kANIMAViewBounds          = kANIMALayerBounds;
NSString  *const kANIMAViewCenter          = @"view.center";
NSString  *const kANIMAViewFrame           = @"view.frame";
NSString  *const kANIMAViewScaleX          = @"view.scaleX";
NSString  *const kANIMAViewScaleXY         = @"view.scaleXY";
NSString  *const kANIMAViewScaleY          = @"view.scaleY";
NSString  *const kANIMAViewSize            = kANIMALayerSize;
NSString  *const kANIMAViewTintColor       = @"view.tintColor";

#pragma mark - UIScrollView
NSString  *const kANIMAScrollViewContentOffset         = @"scrollView.contentOffset";
NSString  *const kANIMAScrollViewContentSize           = @"scrollView.contentSize";
NSString  *const kANIMAScrollViewZoomScale             = @"scrollView.zoomScale";
NSString  *const kANIMAScrollViewContentInset          = @"scrollView.contentInset";
NSString  *const kANIMAScrollViewScrollIndicatorInsets = @"scrollView.scrollIndicatorInsets";

#pragma mark - UITableView
NSString  *const kANIMATableViewContentOffset = kANIMAScrollViewContentOffset;
NSString  *const kANIMATableViewContentSize   = kANIMAScrollViewContentSize;

#pragma mark - UICollectionView
NSString  *const kANIMACollectionViewContentOffset = kANIMAScrollViewContentOffset;
NSString  *const kANIMACollectionViewContentSize   = kANIMAScrollViewContentSize;

#pragma mark - UINavigationBar
NSString  *const kANIMANavigationBarBarTintColor = @"navigationBar.barTintColor";

#pragma mark - UIToolbar
NSString  *const kANIMAToolbarBarTintColor = kANIMANavigationBarBarTintColor;

#pragma mark - UITabBar
NSString  *const kANIMATabBarBarTintColor = kANIMANavigationBarBarTintColor;

#pragma mark - UILabel
NSString  *const kANIMALabelTextColor = @"label.textColor";

#else

#pragma mark - NSView
NSString  *const kANIMAViewFrame               = @"view.frame";
NSString  *const kANIMAViewBounds              = @"view.bounds";
NSString  *const kANIMAViewAlphaValue          = @"view.alphaValue";
NSString  *const kANIMAViewFrameRotation       = @"view.frameRotation";
NSString  *const kANIMAViewFrameCenterRotation = @"view.frameCenterRotation";
NSString  *const kANIMAViewBoundsRotation      = @"view.boundsRotation";

#pragma mark - NSWindow
NSString  *const kANIMAWindowFrame           = @"window.frame";
NSString  *const kANIMAWindowAlphaValue      = @"window.alphaValue";
NSString  *const kANIMAWindowBackgroundColor = @"window.backgroundColor";

# endif

# if TARGET_OS_MAC || TARGET_OS_IPHONE

#pragma mark - SceneKit
NSString  *const kANIMASCNNodePosition     = @"scnode.position";
NSString  *const kANIMASCNNodePositionX    = @"scnnode.position.x";
NSString  *const kANIMASCNNodePositionY    = @"scnnode.position.y";
NSString  *const kANIMASCNNodePositionZ    = @"scnnode.position.z";
NSString  *const kANIMASCNNodeTranslation  = @"scnnode.translation";
NSString  *const kANIMASCNNodeTranslationX = @"scnnode.translation.x";
NSString  *const kANIMASCNNodeTranslationY = @"scnnode.translation.y";
NSString  *const kANIMASCNNodeTranslationZ = @"scnnode.translation.z";
NSString  *const kANIMASCNNodeRotation     = @"scnnode.rotation";
NSString  *const kANIMASCNNodeRotationX    = @"scnnode.rotation.x";
NSString  *const kANIMASCNNodeRotationY    = @"scnnode.rotation.y";
NSString  *const kANIMASCNNodeRotationZ    = @"scnnode.rotation.z";
NSString  *const kANIMASCNNodeRotationW    = @"scnnode.rotation.w";
NSString  *const kANIMASCNNodeEulerAngles  = @"scnnode.eulerAngles";
NSString  *const kANIMASCNNodeEulerAnglesX = @"scnnode.eulerAngles.x";
NSString  *const kANIMASCNNodeEulerAnglesY = @"scnnode.eulerAngles.y";
NSString  *const kANIMASCNNodeEulerAnglesZ = @"scnnode.eulerAngles.z";
NSString  *const kANIMASCNNodeOrientation  = @"scnnode.orientation";
NSString  *const kANIMASCNNodeOrientationX = @"scnnode.orientation.x";
NSString  *const kANIMASCNNodeOrientationY = @"scnnode.orientation.y";
NSString  *const kANIMASCNNodeOrientationZ = @"scnnode.orientation.z";
NSString  *const kANIMASCNNodeOrientationW = @"scnnode.orientation.w";
NSString  *const kANIMASCNNodeScale        = @"scnnode.scale";
NSString  *const kANIMASCNNodeScaleX       = @"scnnode.scale.x";
NSString  *const kANIMASCNNodeScaleY       = @"scnnode.scale.y";
NSString  *const kANIMASCNNodeScaleZ       = @"scnnode.scale.z";
NSString  *const kANIMASCNNodeScaleXY      = @"scnnode.scale.xy";

#endif
