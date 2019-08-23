//
//  FlyThirdController.m
//  算法+链表
//
//  Created by mx-QS on 2019/8/16.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "FlyThirdController.h"

@interface FlyThirdController ()

@end

@implementation FlyThirdController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self insertSort:[@[@(10), @(8), @(12), @(30), @(13), @(61), @(44), @(2)] mutableCopy]];
}

///时间复杂度 O（n^2）
- (void)insertSort:(NSMutableArray *)sortArray
{
    
    int j,p;
    
    NSInteger tmp;
    
    for (p = 1; p < sortArray.count; p++) {
        tmp = [sortArray[p] integerValue];
        for (j = p ; j > 0 && [sortArray[j - 1] integerValue] > tmp; j--) {
            sortArray[j] = sortArray[j - 1];
        }
        sortArray[j] = @(tmp);
    }
    
    FlyLog(@"%@", sortArray);
}

@end
