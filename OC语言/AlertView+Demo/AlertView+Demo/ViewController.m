//
//  ViewController.m
//  AlertView+Demo
//
//  Created by Q on 2018/5/22.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "ViewController.h"
#import "FlyAlertViewController.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"阿萨德" preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableArray *methodArray = [NSMutableArray array];
    unsigned int methodCount = 0;
    Method *methodList = class_copyMethodList(NSClassFromString(@"UIAlertController"), &methodCount);
    for (int i= 0; i<methodCount; i++) {
        Method method = methodList[i];
        SEL  methodSEL = method_getName(method);
        [methodArray addObject:NSStringFromSelector(methodSEL)];
    }
    free(methodList);
    NSLog(@"%@",methodArray);//note:获取不到类方法
    
    
    methodCount = 0;
    const char *clsName = class_getName(NSClassFromString(@"UIAlertController"));
    Class metaClass = objc_getMetaClass(clsName);
    Method * metaMethodList = class_copyMethodList(metaClass, &methodCount);
    
    for (int i = 0; i < methodCount ; i ++) {
        Method method = metaMethodList[i];
        SEL selector = method_getName(method);
        const char *methodName = sel_getName(selector);
        NSLog(@" >>>%s",methodName);
    }
    free(metaMethodList);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self showAlertView];
}

- (void)showDetailViewController:(UIViewController *)vc sender:(id)sender
{
    
}

- (void)showAlertView
{
    FlyAlertViewController * alertView = [FlyAlertViewController alertControllerWithTitle:@"提示" message:@"阿萨德黄金卡水电费看见哈迪斯副科级哈伺服电机开会阿萨德黄金卡水电费看见哈迪斯副科级哈伺服电机开会阿萨德黄金卡水电费看见哈迪斯副科级哈伺服电机开会阿萨德黄金卡水电费看见哈迪斯副科级哈伺服电机开会" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertView addAction:cancelAction];
    
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertView addAction:confirmAction];
    [self presentViewController:alertView animated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
