//
//  FLYStudent.m
//  FLYTest
//
//  Created by Qiushan on 2020/1/4.
//  Copyright © 2020 walg. All rights reserved.
//

#import "FLYStudent.h"

@implementation FLYStudent

+ (void)sayHH {
    
    NSLog(@"%s", __func__);
}

- (void)sayHH {
    
    NSLog(@"%s", __func__);
}


+ (BOOL)resolveInstanceMethod:(SEL)sel {
    
    NSLog(@"%s - %@", __func__, NSStringFromSelector(sel));
    
//    if (sel == @selector(sayLove)) {
//        
//        NSLog(@"来了 - sayHello");
//        SEL targetSel = @selector(sayHappy);
//        Class targetClass = object_getClass([self superclass]);//父类的isa -> 父类的元类
//        IMP sayHIMP = class_getMethodImplementation(targetClass, targetSel);
//        Method method = class_getClassMethod(targetClass, targetSel);
//        const char * methodType = method_getTypeEncoding(method);
//        Class class = [self class];
//        class = object_getClass(class);//给当前类的元类加一个方法
//        return class_addMethod(class, sel, sayHIMP, methodType);
//        
//    } else if (sel == @selector(saySomething)) {
//        
//        NSLog(@"来了 - sayGoGo");
//        SEL targetSel = @selector(sayGoGo);
//        Class targetClass = [self superclass];
//        IMP sayHIMP = class_getMethodImplementation(targetClass, targetSel);
//        Method method = class_getClassMethod(targetClass, targetSel);
//        const char * methodType = method_getTypeEncoding(method);
//        return class_addMethod([self class], sel, sayHIMP, methodType);
//    }
    
    return [super resolveInstanceMethod:sel];
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    
    NSLog(@"%s - %@", __func__, NSStringFromSelector(sel));
    if (sel == @selector(sayLove)) {
        NSLog(@"来了 - sayHello");
        SEL targetSel = @selector(sayHH);
        Class targetClass = object_getClass([self class]);//父类的isa -> 父类的元类
        targetClass = [self class];
        IMP sayHIMP = class_getMethodImplementation(targetClass, targetSel);
        Method method = class_getClassMethod(targetClass, targetSel);
        const char * methodType = method_getTypeEncoding(method);
        Class class = [self class];
        class = object_getClass(class);//给当前类的元类加一个方法
        return class_addMethod(class, sel, sayHIMP, methodType);
    }
    return [super resolveClassMethod:sel];
}

//- (id)forwardingTargetForSelector:(SEL)aSelector {
//
//    NSLog(@"%s - %@", __func__, NSStringFromSelector(aSelector));
//    return [super forwardingTargetForSelector:aSelector];
//}
//
//
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
//
//    NSLog(@"%s - %@", __func__, NSStringFromSelector(aSelector));
//    return [super methodSignatureForSelector:aSelector];
//}
//
//
//- (void)forwardInvocation:(NSInvocation *)anInvocation {
//
//}


@end
