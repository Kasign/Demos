//
//  UIView+AssociatedObject.m
//  Runtime+Demo
//
//  Created by qiuShan on 2018/3/8.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "UIView+AssociatedObject.h"
#import <objc/runtime.h>

@implementation UIView (AssociatedObject)

- (void)setAssociatedObject:(id)associatedObject
{
    objc_setAssociatedObject(self, @selector(associatedObject), associatedObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)associatedObject
{
   return objc_getAssociatedObject(self, @selector(associatedObject));
}



@end
