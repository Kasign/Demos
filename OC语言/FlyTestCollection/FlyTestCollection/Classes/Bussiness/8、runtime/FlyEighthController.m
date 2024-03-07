//
//  FlyEighthController.m
//  算法+链表
//
//  Created by mx-QS on 2019/9/24.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "FlyEighthController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "Person.h"
#import "Person+Custom.h"

@interface FlyEighthController ()

@end

@implementation FlyEighthController

static id _Nullable (*fly_msgSendSuper)(id,SEL , ...) = (void *)objc_msgSendSuper;
static id _Nullable (*fly_msgSend)(id, SEL, ...) = (void *)objc_msgSend;

+ (NSString *)functionName {
    
    return @"runtime";
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //交换方法
    [self exchangeMethod];
    
    id p = fly_msgSend(objc_getClass("Person"), sel_registerName("alloc"));
    p = fly_msgSend(p, sel_registerName("init"));
    SEL run = sel_registerName("run");
    fly_msgSend(p, run);
    
    SEL sleep = sel_registerName("sleep");
    fly_msgSend(p, sleep);
    
    NSMutableArray * methodArray = [NSMutableArray array];
    unsigned int methodCount = 0;
    Method * methodList = class_copyMethodList([Person class], &methodCount);
    for (int i= 0; i<methodCount; i++) {
        Method method = methodList[i];
        SEL methodSEL = method_getName(method);
        [methodArray addObject:NSStringFromSelector(methodSEL)];
    }
    free(methodList);
    FLYLog(@"实例方法->>%@", methodArray);//note:获取不到类方法
    
    //类方法都是在元类方法列表里
    methodCount = 0;
    const char *clsName = class_getName([Person class]);
    Class metaClass = objc_getMetaClass(clsName);
    Method * metaMethodList = class_copyMethodList(metaClass, &methodCount);
    
    [methodArray removeAllObjects];
    
    for (int i = 0; i < methodCount ; i ++) {
        Method method = metaMethodList[i];
        SEL selector = method_getName(method);
        //        const char *methodName = sel_getName(selector);
        [methodArray addObject:NSStringFromSelector(selector)];
    }
    FLYLog(@"类方法->>%@", methodArray);
    free(metaMethodList);
    
    
    fly_msgSend([Person new], sel_registerName("walk"));
    fly_msgSend([Person class], sel_registerName("dance"));
    
    
    Person *person = [Person new];
    person.nickname = @"aaa";
    
    FLYLog(@"名字是：%@",person.nickname);
    
    unsigned int count;
    Method * methodlist = class_copyMethodList([p class], &count);
    
    IMP lastImp = NULL;
    SEL lastSel = NULL;
    //调用被覆盖的方法 原理：被覆盖的方法会排在方法列表的后的位置，在正常调用的时候，会从前向后找，在前面找到了就不继续向后找了，扩展：在方法交换的时候也是交换排在前面的方法
    for (NSInteger i = 0; i < count; i++) {
        Method method = methodlist[i];
        NSString * methodName = [NSString stringWithCString:sel_getName(method_getName(method)) encoding:NSUTF8StringEncoding];
        if ([methodName isEqualToString:@"run"]) {
            lastImp = method_getImplementation(method);
            lastSel = method_getName(method);
        }
    }
    if (lastImp) {
//        lastImp(p, lastSel);
        fly_msgSend(p, lastSel);
    }
    free(methodlist);
    
    //获取成员变量和属性
    //    unsigned int ivarCount;
    //    Ivar *ivars = class_copyIvarList([Person class], &ivarCount);
    //    for (int i = 0; i<ivarCount; i++) {
    //        Ivar ivar = ivars[i];
    //        NSString *name = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
    //        FLYLog(@"那么：%@",name);
    //    }
    //    free(ivars);
    /*
     打印结果：
     2017-03-23 10:08:34.786 RunTimeDemo[39519:20492047] 那么：hight
     2017-03-23 10:08:34.786 RunTimeDemo[39519:20492047] 那么：_age
     2017-03-23 10:08:34.787 RunTimeDemo[39519:20492047] 那么：_name
     */
    
    //获取属性
    //    unsigned int outCount;
    //    objc_property_t *propertyList = class_copyPropertyList([Person class], &outCount);
    //    for (int i = 0; i<outCount; i++) {
    //        objc_property_t property = propertyList[i];
    //        NSString *name = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
    //        FLYLog(@"那么：%@",name);
    //    }
    //    free(propertyList);
    /*
     打印结果：
     2017-03-23 10:07:39.364 RunTimeDemo[39446:20482962] 那么：nickname
     2017-03-23 10:07:39.364 RunTimeDemo[39446:20482962] 那么：age
     2017-03-23 10:07:39.364 RunTimeDemo[39446:20482962] 那么：name
     */
    
    //获取协议列表
    //    NSMutableArray *protocoArray = [NSMutableArray array];
    //    unsigned int protocoCount = 0;
    //    __unsafe_unretained Protocol **protocolList =  class_copyProtocolList([Person class], &protocoCount);
    //    for (int i = 0; i<protocoCount; i++) {
    //        Protocol *protocol = protocolList[i];
    //        const char *protocolName =  protocol_getName(protocol);
    //        [protocoArray addObject:[NSString stringWithUTF8String:protocolName]];
    //    }
    //    FLYLog(@"协议列表：%@",protocoArray);
    
}

- (void)exchangeMethod {
    
    Method method1 = class_getInstanceMethod([Person class], @selector(run));
    Method method2 = class_getInstanceMethod([Person class], @selector(walk));
    method_exchangeImplementations(method1, method2);
}

@end
