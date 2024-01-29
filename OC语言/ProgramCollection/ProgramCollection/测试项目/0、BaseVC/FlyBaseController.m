//
//  FlyBaseController.m
//  算法+链表
//
//  Created by mx-QS on 2019/8/16.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "FlyBaseController.h"

@interface FlyBaseController ()

@end

@implementation FlyBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

+ (NSString *)functionName {
    
    return @"未定义";
}

- (void)dealloc {
    
    FLYLog(@"----* %@ dealloc *----", [self class]);
}

@end
