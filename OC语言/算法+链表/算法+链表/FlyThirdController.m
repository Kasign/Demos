//
//  FlyThirdController.m
//  算法+链表
//
//  Created by mx-QS on 2019/8/16.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "FlyThirdController.h"
#import "FlySort.h"

@interface FlyThirdController ()
{
    
    NSInteger num;
    
}

@property (nonatomic, strong) FlySort   *   sort1;

@end

@implementation FlyThirdController

- (void)viewDidLoad {
    [super viewDidLoad];

//    _sort1 = [[FlySort alloc] init];
//    [_sort1 addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];//这一步会导致sort1的类改变
//
//    void (*setter)(id, SEL, BOOL);
//    int i;
//
//    setter = (void (*)(id, SEL, BOOL))[self methodForSelector:@selector(setFilled:)];
//
//    for ( i = 0 ; i < 10000 ; i++ )
//    {
//        setter(self, @selector(setFilled:), YES);
//    }
}

- (void)setFilled:(NSInteger)number{
    
    NSLog(@"%ld",++num);
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    NSLog(@"%@", change);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    NSArray * sortArr = @[@(10), @(8), @(12), @(30), @(13), @(61), @(44), @(10), @(8), @(12), @(30), @(13), @(61), @(44), @(10), @(8), @(12), @(30), @(13), @(61), @(44), @(10), @(8), @(12), @(30), @(13), @(61), @(44), @(10), @(8), @(12), @(30), @(13), @(61), @(44), @(13), @(48), @(19), @(30), @(13), @(61), @(44), @(10), @(8), @(12), @(80), @(13), @(61), @(44), @(10), @(8), @(12), @(30), @(53), @(21), @(54), @(10), @(8), @(12), @(30), @(13), @(65), @(44), @(11), @(28), @(12), @(30), @(13), @(61), @(44), @(11), @(8), @(52), @(32), @(13), @(61), @(44), @(2)];
//
//    FlyLog(@"待排序 %@", [sortArr componentsJoinedByString:@"-"]);
//    [self insertSortList:sortArr];
//    [self stackSortList:sortArr];
//    [self quickSortList:sortArr];
    
    _sort1.name = @"haha";
}

///插入排序 时间复杂度 O（n^2）
- (void)insertSortList:(NSArray *)sortArray {
    
    sortArray = [FlySort fly_insertSortList:sortArray];
    FlyLog(@"插入排序 %@", [sortArray componentsJoinedByString:@"-"]);
}


///快速排序
/**
 1、如果S中元素个数是0或者1，则返回
 2、取S中任一元素v，称之为枢纽元
 3、将S - {v}(s中其余元素)分成两个不想交的集合；S1 = {x∈S - {v} | x≤v}和S2 = {x∈S-{v} | x ≥ v}
 4、返回{quicksort(S1)后，继随 v,继而 quicksort(S2)}
 */
- (void)quickSortList:(NSArray *)sortArray {
    
    NSArray * arr = [FlySort fly_quickSortList:sortArray];
    FlyLog(@"快速排序 %@", [arr componentsJoinedByString:@"-"]);
}

///堆排序
- (void)stackSortList:(NSArray *)sortArray {
    
    NSMutableArray * array = [NSMutableArray arrayWithArray:sortArray];
    
    
    FlyLog(@"堆排序 %@", [array componentsJoinedByString:@"-"]);
}

@end
