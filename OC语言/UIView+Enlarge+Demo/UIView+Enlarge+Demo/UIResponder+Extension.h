//
//  UIResponder+Extension.h
//  UIView+Enlarge+Demo
//
//  Created by 66-admin-qs. on 2018/11/19.
//  Copyright © 2018 Fly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (Extension)

@end

@interface UIButton (Extension)

- (void)orgSetEnlargeEdgeWithTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;

@end

NS_ASSUME_NONNULL_END
