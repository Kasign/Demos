//
//  NSObject+FlyKVO.m
//  算法+链表
//
//  Created by mx-QS on 2019/9/25.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "NSObject+FlyKVO.h"
#import <objc/message.h>


@implementation NSObject (FlyKVO)

static id _Nullable (*fly_msgSendSuper)(id,SEL , ...) = (void *)objc_msgSendSuper;
static id _Nullable (*fly_msgSend)(id, SEL, ...) = (void *)objc_msgSend;

- (void)fly_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    
    if (![keyPath isKindOfClass:[NSString class]] || keyPath.length == 0) {
        return;
    }
    NSString *selectorName = [keyPath substringWithRange:NSMakeRange(0, 1)].uppercaseString;
    selectorName = [keyPath stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:selectorName];
    selectorName = [@"set" stringByAppendingFormat:@"%@:", selectorName];
    
    NSString *oldClassName = NSStringFromClass([self class]);
    NSString *newClassName = [@"FLYKVO_" stringByAppendingString:oldClassName];
    const char *classChar = [newClassName UTF8String];
    Class subClass = objc_allocateClassPair([self class], classChar, 0);
    
    Method method = class_getInstanceMethod([self class], NSSelectorFromString(selectorName));
    const char *types = method_getTypeEncoding(method);
    
    if (types) { //区分类型，数字 对象类型
        
    }
    
    class_addMethod(subClass, NSSelectorFromString(selectorName), (IMP)flySetProperty, types);
    
    objc_registerClassPair(subClass);
    
    object_setClass(self, subClass);
    
    objc_setAssociatedObject(self, "objc", observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, "keyPath", keyPath, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


void flySetNumProperty(id instance, SEL selector, int value) {
    
    id observer = objc_getAssociatedObject(instance, "objc");
    NSString *keyPath = objc_getAssociatedObject(instance, "keyPath");
    
    NSString *selectorName = [keyPath substringWithRange:NSMakeRange(0, 1)].uppercaseString;
    selectorName = [keyPath stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:selectorName];
    selectorName = [@"set" stringByAppendingFormat:@"%@:",selectorName];
    
    id oldValue = fly_msgSend(instance, NSSelectorFromString(keyPath));
    
    if (!oldValue) {
        oldValue = @0;
    }
    
    Class subClass = [instance class];
    fly_msgSend(instance, @selector(willChangeValueForKey:), keyPath);
    object_setClass(instance, class_getSuperclass(subClass));
    fly_msgSend(instance, NSSelectorFromString(selectorName), value);
    object_setClass(instance, subClass);
    fly_msgSend(observer, @selector(observeValueForKeyPath:ofObject:change:context:), keyPath, instance, @{@"old" : oldValue, @"new" : @(value)});
    fly_msgSend(instance, @selector(didChangeValueForKey:), keyPath);
}


void flySetProperty(id instance, SEL selector, id value) {
    
    id observer = objc_getAssociatedObject(instance, "objc");
    NSString *keyPath = objc_getAssociatedObject(instance, "keyPath");
    
    NSString *selectorName = [keyPath substringWithRange:NSMakeRange(0, 1)].uppercaseString;
    selectorName = [keyPath stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:selectorName];
    selectorName = [@"set" stringByAppendingFormat:@"%@:",selectorName];
    
    id oldValue = fly_msgSend(instance, NSSelectorFromString(keyPath));
    
    if (oldValue == nil) {
        oldValue = @"";
    }
    if (value == nil) {
        value = @"";
    }
    
    Class subClass = [instance class];
    fly_msgSend(instance, @selector(willChangeValueForKey:), keyPath);
    object_setClass(instance, class_getSuperclass(subClass));
    fly_msgSend(instance, NSSelectorFromString(selectorName), value);
    object_setClass(instance, subClass);
    fly_msgSend(observer, @selector(observeValueForKeyPath:ofObject:change:context:), keyPath, instance, @{@"old" : oldValue, @"new" : value});
    fly_msgSend(instance, @selector(didChangeValueForKey:), keyPath);
}


@end
