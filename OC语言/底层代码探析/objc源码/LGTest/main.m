//
//  main.m
//  LGTest
//
//  Created by cooci on 2019/2/7.
//

#import <Foundation/Foundation.h>
#import "LGPerson.h"
#import <objc/runtime.h>


void testObjc_copyIvar_copyProperies(Class pClass){
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(pClass, &count);
    for (unsigned int i=0; i < count; i++) {
        Ivar const ivar = ivars[i];
        //获取实例变量名
        const char*cName = ivar_getName(ivar);
        NSString *ivarName = [NSString stringWithUTF8String:cName];
        NSLog(@"class_copyIvarList:%@",ivarName);
    }
    free(ivars);

    unsigned int pCount = 0;
    objc_property_t *properties = class_copyPropertyList(pClass, &pCount);
    for (unsigned int i=0; i < pCount; i++) {
        objc_property_t const property = properties[i];
        //获取属性名
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        //获取属性值
        NSLog(@"class_copyProperiesList:%@",propertyName);
    }
    free(properties);
}

void testObjc_copyMethodList(Class pClass){
    unsigned int count = 0;
    Method *methods = class_copyMethodList(pClass, &count);
    for (unsigned int i=0; i < count; i++) {
        Method const method = methods[i];
        //获取方法名
        NSString *key = NSStringFromSelector(method_getName(method));
        
        NSLog(@"Method, name: %@", key);
    }
    free(methods);
}

void testInstanceMethod_classToMetaclass(Class pClass){
    
    const char *className = class_getName(pClass);
    Class metaClass = objc_getMetaClass(className);
    
    Method method1 = class_getInstanceMethod(pClass, @selector(sayHello));
    Method method2 = class_getInstanceMethod(metaClass, @selector(sayHello));

    Method method3 = class_getInstanceMethod(pClass, @selector(sayHappy));
    Method method4 = class_getInstanceMethod(metaClass, @selector(sayHappy));
    
    NSLog(@"%p-%p-%p-%p",method1,method2,method3,method4);
    NSLog(@"%s",__func__);
}

void testClassMethod_classToMetaclass(Class pClass){
    
    const char *className = class_getName(pClass);
    Class metaClass = objc_getMetaClass(className);
    
    Method method1 = class_getClassMethod(pClass, @selector(sayHello));
    Method method2 = class_getClassMethod(metaClass, @selector(sayHello));

    Method method3 = class_getClassMethod(pClass, @selector(sayHappy));
    Method method4 = class_getClassMethod(metaClass, @selector(sayHappy)); // ?
    
    NSLog(@"%p-%p-%p-%p",method1,method2,method3,method4);
    NSLog(@"%s",__func__);
}

void testIMP_classToMetaclass(Class pClass){
    
    const char *className = class_getName(pClass);
    Class metaClass = objc_getMetaClass(className);

    IMP imp1 = class_getMethodImplementation(pClass, @selector(sayHello));
    IMP imp2 = class_getMethodImplementation(metaClass, @selector(sayHello));

    IMP imp3 = class_getMethodImplementation(pClass, @selector(sayHappy));
    IMP imp4 = class_getMethodImplementation(metaClass, @selector(sayHappy));

    NSLog(@"%p-%p-%p-%p",imp1,imp2,imp3,imp4);
    NSLog(@"%s",__func__);
}

// 0x100002248-0x0-0x0-0x1000021e0
// 0x0-0x0-0x1000021e0-0x1000021e0

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        LGPerson *person = [LGPerson alloc];
        Class pClass     = object_getClass(person);
        
        testObjc_copyIvar_copyProperies(pClass);
        testObjc_copyMethodList(pClass);

        testInstanceMethod_classToMetaclass(pClass);
        testClassMethod_classToMetaclass(pClass);
        
        NSLog(@"%@ - %p",person,pClass);
    }
    return 0;
}


