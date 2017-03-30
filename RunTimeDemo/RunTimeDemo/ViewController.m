//
//  ViewController.m
//  RunTimeDemo
//
//  Created by walg on 2017/3/22.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "ViewController.h"

#import <objc/message.h>
#import "Person.h"
#import "Person+Custom.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self exchangeMethod];
    
    
    id p =  objc_msgSend(objc_getClass("Person"), sel_registerName("alloc"));
    p = objc_msgSend(p, sel_registerName("init"));
    SEL run = sel_registerName("run");
    objc_msgSend(p, run);
    
    SEL sleep = sel_registerName("sleep");
    objc_msgSend(p, sleep);
    
    
    NSMutableArray *methodArray = [NSMutableArray array];
    unsigned int methodCount = 0;
    Method *methodList = class_copyMethodList([Person class], &methodCount);
    for (int i= 0; i<methodCount; i++) {
        Method method = methodList[i];
        SEL  methodSEL = method_getName(method);
        [methodArray addObject:NSStringFromSelector(methodSEL)];
    }
    free(methodList);
    NSLog(@"%@",methodArray);
    
    objc_msgSend([Person new], sel_registerName("walk"));
    
    
    Person *person = [Person new];
    person.nickname = @"aaa";
    
    NSLog(@"名字是：%@",person.nickname);
    
    
    //    unsigned int count;
    //    Method *methodlist = class_copyMethodList([p class], &count);
    //
    //    IMP lastImp = NULL;
    //    SEL lastSel = NULL;
    //    //调用被覆盖的方法
    //    for (NSInteger i = 0; i<count; i++) {
    //        Method method = methodlist[i];
    //        NSString *methodName = [NSString  stringWithCString:sel_getName(method_getName(method)) encoding:NSUTF8StringEncoding];
    //        if ([methodName isEqualToString:@"run"]) {
    //            lastImp = method_getImplementation(method);
    //            lastSel = method_getName(method);
    //        }
    //    }
    //    if (lastImp) {
    //        lastImp(p,lastSel);
    //        objc_msgSend(p, lastSel);
    //    }
    //    free(methodlist);
    
    //获取成员变量和属性
    //    unsigned int ivarCount;
    //    Ivar *ivars = class_copyIvarList([Person class], &ivarCount);
    //    for (int i = 0; i<ivarCount; i++) {
    //        Ivar ivar = ivars[i];
    //        NSString *name = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
    //        NSLog(@"那么：%@",name);
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
    //        NSLog(@"那么：%@",name);
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
//    NSLog(@"协议列表：%@",protocoArray);
    
}

-(void)exchangeMethod{
    Method method1 = class_getInstanceMethod([Person class], @selector(run));
    Method method2 = class_getInstanceMethod([Person class], @selector(walk));
    method_exchangeImplementations(method1, method2);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
