//
//  ViewController.m
//  手机中所有App信息
//
//  Created by qiuShan on 2018/1/2.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <Messages/Messages.h>
#import "Student.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self testStudent];
    [self getAllAPPSInfo];
}

- (void)getAllAPPSInfo
{
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    
//    unsigned int methodCount = 0;
//    Method * methodList =  class_copyMethodList([LSApplicationWorkspace_class class], &methodCount);
//
//    for (int i = 0; i < methodCount; i++) {
//        Method  method = methodList[i];
//        NSString * methodName = NSStringFromSelector(method_getName(method));
//        NSLog(@"%@",methodName);
//    }
//    free(methodList);
    NSObject * workSpace = [LSApplicationWorkspace_class performSelector:NSSelectorFromString(@"defaultWorkspace")];
    NSLog(@"apps: %@", [workSpace performSelector:NSSelectorFromString(@"allInstalledApplications")]);
}

- (void)testStudent
{
    Class student = objc_getClass("Student");
    unsigned int methodCount = 0;
    Method * methodList = class_copyMethodList([Student class], &methodCount);
    for (int i=0; i<methodCount; i++) {
        Method  method = methodList[i];
        NSString * methodName = NSStringFromSelector(method_getName(method));
        NSLog(@"%@",methodName);
    }
    free(methodList);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
