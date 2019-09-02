//
//  FlySort.m
//  算法+链表
//
//  Created by mx-QS on 2019/8/27.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "FlySort.h"
#define FlyTestLog(...)  FlyLog(...)
#define CutOff (1)

@implementation FlySort

//+ (instancetype)allocWithZone:(struct _NSZone *)zone
//{
//    static FlySort * sort = nil;
//    @synchronized (self) {
//        if (sort == nil) {
//            sort = [super allocWithZone:zone];
//        }
//    }
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        if (sort == nil) {
//            sort = [super allocWithZone:zone];
//        }
//    });
//    return sort;
//}

- (void)setName:(NSString *)name {
    
    _name = name;
}

/**
 1、如果S中元素个数是0或者1，则返回
 2、取S中任一元素v，称之为枢纽元
 3、将S - {v}(s中其余元素)分成两个不相交的集合；S1 = {x∈S - {v} | x≤v}和S2 = {x∈S-{v} | x ≥ v}
 4、返回{quicksort(S1)后，继随 v,继而 quicksort(S2)}
 */
+ (NSArray *)fly_quickSortList:(NSArray *)sortArray
{
    NSMutableArray * arr = [NSMutableArray arrayWithArray:sortArray];
    //    FLYQuickSort1(arr, 0, arr.count - 1);
    FLYQuickSort1(arr, 0, arr.count - 1);
    return arr.copy;
}

+ (NSArray *)fly_insertSortList:(NSArray *)sortArray
{
    NSMutableArray * arr = [NSMutableArray arrayWithArray:sortArray];
    FLYInsertSort(arr);
    return arr.copy;
}

+ (NSArray *)fly_stackSortList:(NSArray *)sortArray {
    
    NSMutableArray * arr = [NSMutableArray arrayWithArray:sortArray];
    FLYStackSort(arr);
    return arr.copy;
}

#pragma mark - 快速排序 方式二
void FLYQuickSort2(NSMutableArray * sortArr, NSInteger left, NSInteger right)
{
    NSInteger i,j;
    NSInteger pivot;
    if (left + CutOff <= right) {
        
        pivot = Median3(sortArr, left, right);
        
        i = left;
        j = right - 1;
        for (; ; ) {
            
            while ([sortArr[++i] integerValue] < pivot) {
                
            }
            while ([sortArr[--j] integerValue] > pivot) {
                
            }
            
            if (i < j) {
                Swap(sortArr, i, j);
            } else {
                break;
            }
        }
        
        Swap(sortArr, i, right - 1);
        FLYQuickSort2(sortArr, left, i - 1);
        FLYQuickSort2(sortArr, i + 1, right);
    } else {
        FlyLog(@" 》i = %ld j= %ld《", i, j);
    }
}

NSInteger Median3(NSMutableArray * sortArr, NSInteger left, NSInteger right)
{
    NSInteger center = (left + right)/2;
    if ([sortArr[left] integerValue] > [sortArr[center] integerValue]) {
        Swap(sortArr, left, center);
    }
    if ([sortArr[left] integerValue] > [sortArr[right] integerValue]) {
        Swap(sortArr, left, right);
    }
    if ([sortArr[center] integerValue] > [sortArr[right] integerValue]) {
        Swap(sortArr, center, right);
    }
    Swap(sortArr, center, right);
    return [sortArr[right - 1] integerValue];
}


#pragma mark - 快速排序 方式一
void FLYQuickSort1(NSMutableArray * arr, NSInteger left, NSInteger right)
{
    if(left < right)
    {
        NSInteger base = Partition(arr, left, right);
        FLYQuickSort1(arr, left, base - 1);
        FLYQuickSort1(arr, base + 1, right);
    }
}

void Swap(NSMutableArray * arr, NSInteger index1, NSInteger index2)
{
    if (index1 != index2)
    {
        NSNumber * temp = arr[index1];
        arr[index1] = arr[index2];
        arr[index2] = temp;
        FlyLog(@"%@    %ld - %ld", [arr componentsJoinedByString:@"-"], index1, index2);
    }
}

NSInteger Partition(NSMutableArray * arr, NSInteger left, NSInteger right)
{
    NSInteger base = [arr[left] integerValue];
    while (left < right) {
        while (left < right && [arr[right] integerValue] >= base) {
            right --;
        }
        Swap(arr, left, right);
        while (left < right && [arr[left] integerValue] <= base) {
            left ++;
        }
        Swap(arr, left, right);
    }
    return left;
}

#pragma mark - 插入排序
void FLYInsertSort(NSMutableArray * sortArr)
{
    NSInteger i,j;
    NSInteger tmp;
    for (i = 1; i < sortArr.count; i ++) {
        tmp = [sortArr[i] integerValue];
        for (j = i; j > 0 && [sortArr[j - 1] integerValue] >= tmp; j --) {
            sortArr[j] = sortArr[j - 1];
        }
        sortArr[j] = @(tmp);
    }
}

#pragma mark - 堆排序
void FLYStackSort(NSMutableArray * sortArr)
{
    
}

@end
