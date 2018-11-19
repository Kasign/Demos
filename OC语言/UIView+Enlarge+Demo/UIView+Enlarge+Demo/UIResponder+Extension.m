//
//  UIResponder+Extension.m
//  UIView+Enlarge+Demo
//
//  Created by 66-admin-qs. on 2018/11/19.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "UIResponder+Extension.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation UIResponder (Extension)

@end

static char orgTopNameKey;
static char orgLeftNameKey;
static char orgBottomNameKey;
static char orgRightNameKey;

@implementation UIButton (Extension)

- (void)orgSetEnlargeEdgeWithTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right {
    
    objc_setAssociatedObject(self, &orgTopNameKey,    [NSNumber numberWithFloat:top],    OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &orgRightNameKey,  [NSNumber numberWithFloat:right],  OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &orgBottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &orgLeftNameKey,   [NSNumber numberWithFloat:left],   OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)orgEnlargedRect {
    
    NSNumber * topEdge    = objc_getAssociatedObject(self, &orgTopNameKey);
    NSNumber * rightEdge  = objc_getAssociatedObject(self, &orgRightNameKey);
    NSNumber * bottomEdge = objc_getAssociatedObject(self, &orgBottomNameKey);
    NSNumber * leftEdge   = objc_getAssociatedObject(self, &orgLeftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge) {
        return CGRectMake(self.bounds.origin.x    - leftEdge.floatValue,
                          self.bounds.origin.y    - topEdge.floatValue,
                          self.bounds.size.width  + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue  + bottomEdge.floatValue);
    } else {
        return self.bounds;
    }
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//
//    if (self.hidden) {
//        return nil;
//    }
//    CGRect rect = [self orgEnlargedRect];
//    if (CGRectEqualToRect(rect, self.bounds)) {
//        return [super hitTest:point withEvent:event];
//    }
//    return CGRectContainsPoint(rect, point) ? self : nil;
//}

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    
//    BOOL result = [super pointInside:point withEvent:event];
//    NSLog(@"  \n**--pointInside---->>> \n self == %@ \n result: %d",self,result);
//    return result;
//}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView * targetView = [super hitTest:point withEvent:event];
    NSLog(@"   \n**--hitTest---->>>>> \n self : %@ \n targetView : %@",self,targetView);
    return targetView;
}

@end
