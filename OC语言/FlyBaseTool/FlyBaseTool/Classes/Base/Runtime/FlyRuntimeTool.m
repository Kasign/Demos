//
//  FlyRuntimeTool.m
//  算法+链表
//
//  Created by mx-QS on 2019/9/25.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "FlyRuntimeTool.h"

@implementation FlyRuntimeTool

+ (void)loopInstanceSuperClass:(id)instance
{
    while (![instance isMemberOfClass:[NSObject class]] && ![instance isKindOfClass:[NSNull class]]) {
        [self getClassMethods:instance];
        instance = [[instance superclass] new];
    }
}

+ (void)getClassMethods:(id)instance
{
    FLYLog(@"-------------------------********-------------------------");
    FLYLog(@"当前类名：%@", [instance class]);
    NSMutableArray *methodArray = [NSMutableArray array];
    unsigned int methodCount = 0;
    Method *methodList = class_copyMethodList([instance class], &methodCount);
    for (int i= 0; i<methodCount; i++) {
        Method method  = methodList[i];
        SEL  methodSEL = method_getName(method);
        const char *types = method_getTypeEncoding(method);
        NSString *type = [NSString stringWithUTF8String:types];
        [methodArray addObject:[NSString stringWithFormat:@"%@ - %@", NSStringFromSelector(methodSEL), type]];
    }
    free(methodList);
    FLYLog(@"实例方法：%@", methodArray);
    
    //类方法都是在元类方法列表里
    [methodArray removeAllObjects];
    methodCount = 0;
    const char *clsName = class_getName([instance class]);
    Class metaClass = objc_getMetaClass(clsName);
    Method *metaMethodList = class_copyMethodList(metaClass, &methodCount);
    for (int i = 0; i < methodCount ; i ++) {
        Method method = metaMethodList[i];
        SEL selector = method_getName(method);
        const char *types = method_getTypeEncoding(method);
        NSString *type = [NSString stringWithUTF8String:types];
        [methodArray addObject:[NSString stringWithFormat:@"%@ - %@", NSStringFromSelector(selector), type]];
    }
    free(metaMethodList);
    FLYLog(@"类方法：%@", methodArray);
    
    
    //获取成员变量和属性
    NSMutableDictionary *nameTypeDict = [NSMutableDictionary dictionary];
    unsigned int ivarCount;
    Ivar *ivars = class_copyIvarList([instance class], &ivarCount);
    for (int i = 0; i<ivarCount; i++) {
        Ivar ivar = ivars[i];
        const char *ivarCharName = ivar_getName(ivar);
        const char *ivarCharType = ivar_getTypeEncoding(ivar);
        NSString *ivarName = [NSString stringWithCString:ivarCharName encoding:NSUTF8StringEncoding];
        NSString *ivarType = [NSString stringWithCString:ivarCharType encoding:NSUTF8StringEncoding];
        [nameTypeDict setObject:ivarType forKey:ivarName];
    }
    free(ivars);
    FLYLog(@"成员变量:%@", nameTypeDict);
    
    //获取属性
    [nameTypeDict removeAllObjects];
    unsigned int outCount;
    objc_property_t *propertyList = class_copyPropertyList([instance class], &outCount);
    for (int i = 0; i<outCount; i++) {
        objc_property_t property = propertyList[i];
        const char *propertyChar = property_getName(property);
        const char *attributesChar = property_getAttributes(property);
        NSString *propertyName = [NSString stringWithCString:propertyChar encoding:NSUTF8StringEncoding];
        char *attributeValue = property_copyAttributeValue(property, attributesChar);
        NSString *attributesStr = @"";
        if (!attributesChar) {
            attributesStr = @"NULL";
        } else {
            attributesStr = [NSString stringWithCString:attributesChar encoding:NSUTF8StringEncoding];
        }
        [nameTypeDict setObject:attributesStr forKey:propertyName];
    }
    free(propertyList);
    FLYLog(@"属性:%@",nameTypeDict);

    //获取协议列表
    NSMutableArray *protocoArray = [NSMutableArray array];
    unsigned int protocoCount = 0;
    __unsafe_unretained Protocol ** protocolList =  class_copyProtocolList([instance class], &protocoCount);
    for (int i = 0; i<protocoCount; i++) {
        Protocol *protocol = protocolList[i];
        const char *protocolName =  protocol_getName(protocol);
        [protocoArray addObject:[NSString stringWithUTF8String:protocolName]];
    }
    FLYLog(@"协议列表：%@", protocoArray);
    FLYLog(@"-------------------------********-------------------------");
}

@end
