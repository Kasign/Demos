//
//  ViewController.m
//  三方库合集
//
//  Created by mx-QS on 2019/8/1.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "ViewController.h"
#import "FlyModelObject.h"
#import <MJExtension.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fly_MJExtension_test];
}

- (void)fly_MJExtension_test {
    
    FlyModelObject * object1 = [[FlyModelObject alloc] init];
//    object1.nameDic = @{@"name" : @"123"};
//    object1.modelIndex = 10;
    object1.modelType  = @"0";
    object1.converBlock = ^(NSInteger index) {
        NSLog(@"%ld",index);
    };
//    FlyModelObject2 * detailModel = [[FlyModelObject2 alloc] init];
//    detailModel.nameDic = @{@"name" : @"1111111"};
//    detailModel.modelIndex = 1111;
//    detailModel.modelType  = @"111";
//    
//    __weak typeof(object1) weakObject1 = object1;
//    detailModel.converBlock = ^(NSInteger index) {
//        NSLog(@"%@", weakObject1.modelType);
//    };
//    
//    object1.detailModel = detailModel;
    
    NSDictionary * objectDic = [object1 mj_keyValues];
    NSLog(@"%@", objectDic);
    object1.modelType = @"11";
    FlyModelObject * object2 = [FlyModelObject mj_objectWithKeyValues:objectDic];
    NSLog(@"%@", object2);
    object1.modelType = @"12";
    FlyModelObject * object3 = [object1 copy];
    NSLog(@"%@", object3);
    FlyModelObject * object4 = [FlyModelObject mj_objectWithKeyValues:objectDic];
    NSLog(@"%@", object4);
    FlyModelObject * object5 = [object1 copy];
    NSLog(@"%@", object5);
    object1 = nil;
}

@end
