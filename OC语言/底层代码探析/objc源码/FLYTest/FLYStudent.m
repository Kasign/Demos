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
    
    
    if (sel == @selector(saySomething)) {
        
        NSLog(@"来了 - sayHello");
        
        IMP sayHIMP = class_getMethodImplementation(self, @selector(sayHello));
        
        Method method = class_getClassMethod(self, sel);
        
        const char * methodType = method_getTypeEncoding(method);
        
        return class_addMethod(self, sel, sayHIMP, methodType);
    }
    
    return [super resolveInstanceMethod:sel];
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    
    NSLog(@"%s - %@", __func__, NSStringFromSelector(sel));
    return [super resolveClassMethod:sel];
}

@end
