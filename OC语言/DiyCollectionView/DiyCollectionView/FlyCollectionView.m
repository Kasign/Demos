//
//  FlyCollectionView.m
//  DiyCollectionView
//
//  Created by Fly. on 2018/11/29.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "FlyCollectionView.h"
#import "FlyCollectionViewObject.h"

@interface FlyCollectionView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray   *   cell_dequeue_arr;
@property (nonatomic, strong) NSMutableArray   *   fly_cell_class_identifier;
@property (nonatomic, strong) NSMutableDictionary   *   cell_undequeue_dict;

@property (nonatomic, assign) NSInteger       moreCount;


@end

@implementation FlyCollectionView
@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame collectionViewLayout:[FlyCollectionViewLayout new]];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithFrame:CGRectZero collectionViewLayout:[FlyCollectionViewLayout new]];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(FlyCollectionViewLayout *)layout
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.alwaysBounceVertical = YES;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor clearColor];
        [super setDelegate:self];
        [self fly_setUp];
    }
    return self;
}

- (void)fly_setUp {
    
    _cell_dequeue_arr = [NSMutableArray array];
    _fly_cell_class_identifier = [NSMutableArray array];
    _cell_undequeue_dict = [NSMutableDictionary dictionary];
    _moreCount = 2;
}

#pragma mark - public method
- (FlyCollectionReusableView *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * layoutAttributes = [self getLayoutAttributesWithIndex:indexPath];
    FlyCollectionReusableView * reusableView = [self getReusableViewWithIdentifier:identifier layoutAttributes:layoutAttributes];
    if (reusableView) {
        [_cell_dequeue_arr addObject:reusableView];
    }
    return reusableView;
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier
{
    if ([identifier isKindOfClass:[NSString class]] && cellClass)
    {
        FlyCollectionViewObject * cellObject = [FlyCollectionViewObject initWithClass:cellClass identifier:identifier type:0];
        [_fly_cell_class_identifier addObject:cellObject];
        
        NSMutableSet * mutableSet = [NSMutableSet set];
        [_cell_undequeue_dict setObject:mutableSet forKey:identifier];
    }
}

#pragma mark - show subViews
- (void)reloadData
{
    
    [self refreshView];
}

- (void)refreshView
{
    NSInteger sectionNum = 0;
    NSInteger itemsInSection = 0;
    if ([self dataSourceResponseSEL:@selector(numberOfSectionsInFlyCollectionView:)]) {
        sectionNum = [self.dataSource numberOfSectionsInFlyCollectionView:self];
    }
    for (NSInteger i = 0; i < sectionNum; i ++) {
        if ([self dataSourceResponseSEL:@selector(flyCollectionView:numberOfItemsInSection:)]) {
            itemsInSection = [self.dataSource flyCollectionView:self numberOfItemsInSection:i];
        }
        FlyCollectionReusableView * reusableView = nil;
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        if ([self dataSourceResponseSEL:@selector(flyCollectionView:cellForItemAtIndexPath:)]) {
            reusableView = [self.dataSource flyCollectionView:self cellForItemAtIndexPath:indexPath];
        }
        if (reusableView) {
            [self addSubview:reusableView];
        }
    }
}

#pragma mark - need method
//生成新的可复用的cell
- (void)createNewReusedItem:(NSString *)identifier
{
    if (identifier) {
        NSMutableSet * mutableSet = [_cell_undequeue_dict objectForKey:identifier];
        for (int i = 0; i < _moreCount; i++) {
            FlyCollectionReusableView * reusedCell = [[FlyCollectionReusableView alloc] initWithFrame:CGRectZero];
            reusedCell.reuseIdentifier = identifier;
            [mutableSet addObject:reusedCell];
        }
        [_cell_undequeue_dict setObject:mutableSet forKey:identifier];
    }
}

- (FlyCollectionReusableView *)getReusableViewWithIdentifier:(NSString *)identifier layoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    FlyCollectionReusableView * reusableView = nil;
    if (identifier) {
        NSMutableSet * mutableSet = [_cell_undequeue_dict objectForKey:identifier];
        reusableView = [mutableSet anyObject];
        if (!reusableView) {
            reusableView = [[FlyCollectionReusableView alloc] initWithFrame:layoutAttributes.bounds];
            [mutableSet addObject:reusableView];
        }
        reusableView.layoutAttributes = layoutAttributes;
    }
    return reusableView;
}

- (UICollectionViewLayoutAttributes *)getLayoutAttributesWithIndex:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * layoutAttributes = nil;
    
    
    
    
    return layoutAttributes;
}

#pragma mark - scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    
    if ([self delegateResponseSEL:@selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll:self];
    }
}

#pragma mark - delegate
- (BOOL)delegateResponseSEL:(SEL)sel
{
    BOOL response = [self.delegate conformsToProtocol:@protocol(FlyCollectionViewDelegate)] && [self.delegate respondsToSelector:sel];
    return response;
}

- (BOOL)dataSourceResponseSEL:(SEL)sel
{
    BOOL response = [self.dataSource conformsToProtocol:@protocol(FlyCollectionViewDataSource)] && [self.dataSource respondsToSelector:sel];
    return response;
}

- (void)removeFromSuperview
{
    
    [super removeFromSuperview];
}

- (void)dealloc
{
    
}

@end
