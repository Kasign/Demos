//
//  FlyQuickSort.h
//  算法+链表
//
//  Created by Walg on 2019/8/26.
//  Copyright © 2019 Fly. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 1、如果S中元素个数是0或者1，则返回
 2、取S中任一元素v，称之为枢纽元
 3、将S - {v}(s中其余元素)分成两个不想交的集合；S1 = {x∈S - {v} | x≤v}和S2 = {x∈S-{v} | x ≥ v}
 4、返回{quicksort(S1)后，继随 v,继而 quicksort(S2)}
 */

@interface FlyQuickSort : NSObject

+ (NSArray *)fly_quickSortList:(NSArray *)sortArray;

@end


@interface FlyInsertSort : NSObject

+ (NSArray *)fly_insertSortList:(NSArray *)sortArray;

@end

NS_ASSUME_NONNULL_END
