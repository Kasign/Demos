//
//  FLYStudent.m
//  FLYTest
//
//  Created by Qiushan on 2020/1/4.
//  Copyright © 2020 walg. All rights reserved.
//

#import "FLYStudent.h"

@implementation FLYStudent

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    
    NSLog(@"%s - %@", __func__, NSStringFromSelector(sel));
    
    
    if (sel == @selector(sayLove)) {

        NSLog(@"来了 - sayHello");

        IMP sayHIMP = class_getMethodImplementation(self, @selector(sayHello));

        Method method = class_getClassMethod(self, sel);

        const char * methodType = method_getTypeEncoding(method);

        return class_addMethod(self, sel, sayHIMP, methodType);
    }
    
    return [super resolveInstanceMethod:sel];
    
//    return YES;
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    
    NSLog(@"%s - %@", __func__, NSStringFromSelector(sel));
//    return [super resolveClassMethod:sel];
    if (sel == @selector(sayLove)) {

        NSLog(@"来了 - sayHello");

        IMP sayHIMP = class_getMethodImplementation([self superclass], @selector(sayHappy));

        Method method = class_getClassMethod([self superclass], @selector(sayHappy));

        const char * methodType = method_getTypeEncoding(method);

        return class_addMethod(self, sel, sayHIMP, methodType);
    }
    return [super resolveClassMethod:sel];
}


- (id)forwardingTargetForSelector:(SEL)aSelector {

    NSLog(@"%s - %@", __func__, NSStringFromSelector(aSelector));
    return [super forwardingTargetForSelector:aSelector];
}


//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
//
//    NSLog(@"%s - %@", __func__, NSStringFromSelector(aSelector));
//    return [super methodSignatureForSelector:aSelector];
//}
//
//- (void)forwardInvocation:(NSInvocation *)anInvocation {
//
//}

@end
