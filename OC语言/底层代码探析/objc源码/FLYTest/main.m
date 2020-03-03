//
//  main.m
//  FLYTest
//
//  Created by Walg on 2019/12/22.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <malloc/malloc.h>
#import "FLYPerson.h"
#import "FLYTeacher.h"
#import "FLYStudent.h"

//struct {
//    double a;   // 占8位 0 - 7
//    char b;     // 占1位 8 - 9
//    int c;      // 占4位 12 - 15
//    char d;     // 占1位 16 - 17  补齐 7位
//} FLYStruct1;
//
//struct {
//    double a;  // 占8位 0 - 7
//    int c;     // 占4位 8 - 11
//    char b;    // 占1位 11 - 12
//    char d;    // 占1位 12 - 13 补齐 3位
//} FLYStruct2;
//
//int main(int argc, const char * argv[]) {
//    @autoreleasepool {
//
//        NSLog(@"%lu %lu", sizeof(FLYStruct1),  sizeof(FLYStruct2));
//
//        FLYTeacher * p = [FLYTeacher alloc];
//        // ISA             // 占用8位
//        p.age = 18;        // 占用4位
//        p.height = 188;    // 占用4位
//        p.name   = @"eirc";// 占用8位
//        p.hobby  = @"girl";// 占用8位
//        //des1             // 占用1位
//        //des2             // 占用1位
//
//        NSLog(@"%lu - %lu", class_getInstanceSize([p class]), malloc_size((__bridge const void *)(p)));
//
//        //总和： 34 因为内存对齐 所以 class_getInstanceSize([p class]) = 40
//
////        FLYPerson * person = [[FLYPerson alloc] init];
////        Class pClass       = object_getClass(person);
////        [person sayHello];
////        [person sayByeBye];
////        [person sayGoGo];
////
////        NSLog(@"%@ - %p", person, pClass);
//    }
//    return 0;
//}

extern void instrumentObjcMessageSends(BOOL flag);

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        // insert code here...
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        
//        NSLog(@"Hello, World!");
//        FLYPerson * person = [FLYPerson alloc];
//        Class pClass       = object_getClass(person);
//        NSLog(@"%@ - %p", person, pClass);
//        
//        [FLYPerson sayHaHa];
        
//        instrumentObjcMessageSends(true);
        
        FLYStudent *person = [[FLYStudent alloc] init];
        // 对象方法测试
        // 对象的实力方法 - 自己没有 - 老爸没有 - 找老爸的老爸 -> NSObject 也没有 - 奔溃
        [person saySomething];
        
//        [FLYStudent sayLove];
                
//        instrumentObjcMessageSends(false);
#pragma clang diagnostic pop
    }
    return 0;
}
