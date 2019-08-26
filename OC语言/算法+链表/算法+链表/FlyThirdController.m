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
    
    NSArray * arr = @[@(10), @(8), @(12), @(30), @(13), @(61), @(44), @(2), @(8), @(12), @(30), @(13), @(61), @(44), @(2), @(8), @(12), @(30), @(13), @(61), @(44), @(2)];
    FlyLog(@"%@", [arr componentsJoinedByString:@"-"]);
//    [self insertSort:[arr mutableCopy]];
    [self quickSortList:arr];
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

- (void)quickSortList:(NSArray *)sortArray {
    
    NSMutableArray * arr = [NSMutableArray arrayWithArray:sortArray];
    QuickSort(arr, 0, arr.count - 1);
    FlyLog(@"快速排序 %@", [arr componentsJoinedByString:@"-"]);
}

void QuickSort(NSMutableArray * arr, NSInteger low, NSInteger high)
{
    if(low < high)
    {
        NSInteger base = Partition(arr, low, high);
        QuickSort(arr, low, base - 1);
        QuickSort(arr, base + 1, high);
    }
}

void Swap(NSMutableArray * arr, NSInteger low, NSInteger high)
{
    if (low != high) {
        NSNumber * temp = arr[low];
        arr[low]  = arr[high];
        arr[high] = temp;
        FlyLog(@"%@    %ld - %ld", [arr componentsJoinedByString:@"-"], low, high);
    }
}

NSInteger Partition1(NSMutableArray * arr, NSInteger low, NSInteger high)
{
    NSInteger baseIndex = (low + high ) / 2;
    NSInteger base = [arr[baseIndex] integerValue];
    FlyLog(@"index - %ld base - %ld", baseIndex, base);
    while(baseIndex < high)
    {
        while(baseIndex < high && [arr[high] integerValue] >= base)
        {
            high --;
        }
        Swap(arr, baseIndex, high);
        while(baseIndex < high && [arr[baseIndex] integerValue] <= base)
        {
            baseIndex ++;
        }
        Swap(arr, baseIndex, high);
    }
    return baseIndex;
}

NSInteger Partition(NSMutableArray * arr, NSInteger low, NSInteger high)
{
    NSInteger base = [arr[low] integerValue];
    while (low < high) {
        
        while (low < high && [arr[high] integerValue] >= base) {
            high --;
        }
        Swap(arr, low, high);
        while (low < high && [arr[low] integerValue] <= base) {
            low ++;
        }
        Swap(arr, low, high);
    }
    return low;
}

@end
