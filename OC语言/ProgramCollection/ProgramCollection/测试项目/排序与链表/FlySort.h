//
//  FlySort.h
//  算法+链表
//
//  Created by mx-QS on 2019/8/27.
//  Copyright © 2019 Fly. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlySort : NSObject

@property (nonatomic, copy) NSString   *name;

/**
 1、如果S中元素个数是0或者1，则返回
 2、取S中任一元素v，称之为枢纽元
 3、将S - {v}(s中其余元素)分成两个不想交的集合；S1 = {x∈S - {v} | x≤v}和S2 = {x∈S-{v} | x ≥ v}
 4、返回{quicksort(S1)后，继随 v,继而 quicksort(S2)}
 */
+ (NSArray *)fly_quickSortList:(NSArray *)sortArray;

+ (NSArray *)fly_insertSortList:(NSArray *)sortArray;

+ (NSArray *)fly_stackSortList:(NSArray *)sortArray;

@end

NS_ASSUME_NONNULL_END
