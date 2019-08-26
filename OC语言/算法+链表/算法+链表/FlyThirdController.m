//
//  FlyThirdController.m
//  算法+链表
//
//  Created by mx-QS on 2019/8/16.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "FlyThirdController.h"
#import <Math.h>

@interface FlyThirdController ()

@end

@implementation FlyThirdController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSArray * sortArr = @[@(10), @(8), @(12), @(30), @(13), @(61), @(44), @(10), @(8), @(12), @(30), @(13), @(61), @(44), @(10), @(8), @(12), @(30), @(13), @(61), @(44), @(10), @(8), @(12), @(30), @(13), @(61), @(44), @(10), @(8), @(12), @(30), @(13), @(61), @(44), @(13), @(48), @(19), @(30), @(13), @(61), @(44), @(10), @(8), @(12), @(80), @(13), @(61), @(44), @(10), @(8), @(12), @(30), @(53), @(21), @(54), @(10), @(8), @(12), @(30), @(13), @(65), @(44), @(11), @(28), @(12), @(30), @(13), @(61), @(44), @(11), @(8), @(52), @(32), @(13), @(61), @(44), @(2)];
    
    FlyLog(@"待排序 %@", sortArr);
    [self insertSortList:sortArr];
    [self stackSortList:sortArr];
    [self quickSortList:sortArr];
}


///插入排序 时间复杂度 O（n^2）
- (void)insertSortList:(NSArray *)sortArray {
    
    NSMutableArray * array = [NSMutableArray arrayWithArray:sortArray];
    NSInteger i,j;
    NSInteger tmp;
    for (i = 1; i < sortArray.count; i ++) {
        tmp = [[array objectAtIndex:i] integerValue];
        for (j = i; j > 0 && [array[j - 1] integerValue] > tmp; j --) {
            array[j] = array[j - 1];
        }
        array[j] = @(tmp);
    }
    FlyLog(@"插入排序 %@", array);
}


///快速排序

/**
 1、如果S中元素个数是0或者1，则返回
 2、取S中任一元素v，称之为枢纽元
 3、将S - {v}(s中其余元素)分成两个不想交的集合；S1 = {x∈S - {v} | x≤v}和S2 = {x∈S-{v} | x ≥ v}
 4、返回{quicksort(S1)后，继随 v,继而 quicksort(S2)}
 */
- (void)quickSortList:(NSArray *)sortArray {

    NSMutableArray * array = [NSMutableArray arrayWithArray:sortArray];
    
    
    FlyLog(@"快速排序 %@", array);
}

- (NSInteger)median3:(NSArray *)sortArr left:(NSInteger)left right:(NSInteger)right {
    
    NSInteger center = (left + right)/2;
    if ([sortArr[left] integerValue] > [sortArr[center] integerValue]) {
        
    }
    
    return 0;
}

///堆排序
- (void)stackSortList:(NSArray *)sortArray {
    
    NSMutableArray * array = [NSMutableArray arrayWithArray:sortArray];
    
    
    FlyLog(@"堆排序 %@", array);
}


@end
