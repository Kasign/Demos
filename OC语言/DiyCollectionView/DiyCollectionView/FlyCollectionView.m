//
//  FlyCollectionView.m
//  DiyCollectionView
//
//  Created by Fly. on 2018/11/29.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "FlyCollectionView.h"
#import "FlyCollectionViewObject.h"
#import <objc/runtime.h>

@interface FlyCollectionView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableDictionary   *   cellReuseQueues;//复用池 identifier : NSDictionary
@property (nonatomic, strong) NSMutableDictionary   *   visibleCellsDict;
@property (nonatomic, strong) NSMutableDictionary   *   cellClassDict;

@property (nonatomic, strong) NSMutableDictionary   *   supplementaryViewReuseQueues;
@property (nonatomic, strong) NSMutableDictionary   *   supplementaryViewClassDict;
@property (nonatomic, strong) NSMutableDictionary   *   visibleSupplementaryViewsDict;

@property (nonatomic, readwrite) NSInteger numberOfSections;
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
        self.collectionViewLayout = layout;
        [self fly_setUp];
    }
    return self;
}

- (void)fly_setUp {
    
    _cellReuseQueues = [NSMutableDictionary dictionary];
    _supplementaryViewReuseQueues = [NSMutableDictionary dictionary];
    _visibleCellsDict = [NSMutableDictionary dictionary];
    _cellClassDict = [NSMutableDictionary dictionary];
    _supplementaryViewClassDict = [NSMutableDictionary dictionary];
    _moreCount = 2;
    self.collectionViewLayout.collectionView = self;
}

- (void)setDelegate:(id<FlyCollectionViewDelegate>)delegate
{
    [super setDelegate:delegate];
}

- (NSInteger)numberOfSections
{
    _numberOfSections = 1;
    if ([self dataSourceResponseSEL:@selector(numberOfSectionsInFlyCollectionView:)]) {
        _numberOfSections = [self.dataSource numberOfSectionsInFlyCollectionView:self];
    }
    return _numberOfSections;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    NSInteger numerOfItems = 0;
    if ([self dataSourceResponseSEL:@selector(flyCollectionView:numberOfItemsInSection:)]) {
        numerOfItems = [self.dataSource flyCollectionView:self numberOfItemsInSection:section];
    }
    return numerOfItems;
}

#pragma mark - public method
- (FlyCollectionReusableView *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * layoutAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    FlyCollectionReusableView * reusableView = [self reusableCellViewWithIdentifier:identifier layoutAttributes:layoutAttributes];
    if (reusableView) {
        [_visibleCellsDict setObject:reusableView forKey:indexPath];
    }
    FlyLog(@"dequeueReusable -> \n %p -- %@",reusableView,indexPath);
    return reusableView;
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier
{
    if ([identifier isKindOfClass:[NSString class]] && cellClass)
    {
//        FlyCollectionViewObject * cellObject = [FlyCollectionViewObject initWithClass:cellClass identifier:identifier type:0];
        [_cellClassDict setObject:cellClass forKey:identifier];
        NSMutableSet * mutableSet = [NSMutableSet set];
        [_cellReuseQueues setObject:mutableSet forKey:identifier];
    }
}

#pragma mark supplement
- (FlyCollectionReusableView *)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * layoutAttributes = [self layoutAttributesForSupplementaryElementOfKind:elementKind atIndexPath:indexPath];
    FlyCollectionReusableView * reusableView = [self supplementaryViewForElementKind:elementKind identifier:identifier layoutAttributes:layoutAttributes];
    if (reusableView) {
        [_visibleSupplementaryViewsDict setObject:reusableView forKey:indexPath];
    }
    FlyLog(@"dequeueReusable -> \n %p -- %@",reusableView,indexPath);
    return reusableView;
}

- (void)registerClass:(Class)viewClass forSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier
{
    if ([identifier isKindOfClass:[NSString class]] && [elementKind isKindOfClass:[NSString class]] && viewClass)
    {
        NSString * reuseKey = [FlyCollectionView reuseKeyForSupplementaryViewOfKind:elementKind withReuseIdentifier:identifier];
        if (reuseKey) {
            [_supplementaryViewClassDict setObject:viewClass forKey:reuseKey];
            NSMutableSet * mutableSet = [NSMutableSet set];
            [_supplementaryViewReuseQueues setObject:mutableSet forKey:reuseKey];
        }
    }
}

#pragma mark - show subViews
- (void)reloadData
{
    [self fly_setUp];
    [self.collectionViewLayout prepareLayout];
    [self reloadVisibleViews];
}

- (void)reloadVisibleViews
{
    NSMutableArray * visibleIndexPaths = [[self indexPathsForVisibleItems] mutableCopy];
    [visibleIndexPaths removeObjectsInArray:_visibleCellsDict.allKeys];
    [self reloadItemsAtIndexPaths:visibleIndexPaths.copy];
    
    NSMutableArray * visibleHeaderIndexPaths = [[self indexPathsForVisibleSupplementaryElementsOfKind:UICollectionElementKindSectionHeader] mutableCopy];
    [visibleHeaderIndexPaths removeObjectsInArray:_visibleSupplementaryViewsDict.allKeys];
    [self reloadItemsAtIndexPaths:visibleHeaderIndexPaths.copy];
    [self reloadSupplementaryElementsOfKind:UICollectionElementKindSectionHeader atIndexPaths:visibleHeaderIndexPaths];
    
    NSMutableArray * visibleFooterIndexPaths = [[self indexPathsForVisibleSupplementaryElementsOfKind:UICollectionElementKindSectionFooter] mutableCopy];
    [visibleFooterIndexPaths removeObjectsInArray:_visibleSupplementaryViewsDict.allKeys];
    [self reloadItemsAtIndexPaths:visibleFooterIndexPaths.copy];
    [self reloadSupplementaryElementsOfKind:UICollectionElementKindSectionFooter atIndexPaths:visibleFooterIndexPaths];
}

- (FlyCollectionReusableView *)reusableCellViewWithIdentifier:(NSString *)identifier layoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    FlyCollectionReusableView * reusableView = nil;
    if (identifier) {
        NSMutableSet * mutableSet = [_cellReuseQueues objectForKey:identifier];
        reusableView = [mutableSet anyObject];
        if (!reusableView) {
            reusableView = [[FlyCollectionReusableView alloc] initWithFrame:layoutAttributes.bounds];
            reusableView.reuseIdentifier = identifier;
        } else {
            [mutableSet removeObject:reusableView];
        }
        [reusableView setFrame:layoutAttributes.frame];
    }
    return reusableView;
}

- (nullable FlyCollectionReusableView *)supplementaryViewForElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    FlyCollectionReusableView * reusableView = nil;
    if ([self dataSourceResponseSEL:@selector(flyCollectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
        reusableView = [self.dataSource flyCollectionView:self viewForSupplementaryElementOfKind:elementKind atIndexPath:indexPath];
    }
    return reusableView;
}

- (FlyCollectionReusableView *)supplementaryViewForElementKind:(NSString *)elementKind identifier:(NSString *)identifier layoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    FlyCollectionReusableView * reusableView = nil;
    if (identifier && elementKind) {
        NSString * reuseKey = [FlyCollectionView reuseKeyForSupplementaryViewOfKind:elementKind withReuseIdentifier:identifier];
        if (reuseKey) {
            NSMutableSet * mutableSet = [_supplementaryViewReuseQueues objectForKey:reuseKey];
            reusableView = [mutableSet anyObject];
            if (!reusableView) {
                reusableView = [[FlyCollectionReusableView alloc] initWithFrame:layoutAttributes.bounds];
                reusableView.reuseIdentifier = identifier;
            } else {
                [mutableSet removeObject:reusableView];
            }
            [reusableView setFrame:layoutAttributes.frame];
        }
    }
    return reusableView;
}

#pragma mark - sys
- (NSArray *)indexPathsForVisibleItems
{
    NSMutableArray * indexPaths = [NSMutableArray array];
    NSInteger sectionNum = self.numberOfSections;
    for (NSInteger section = 0; section < sectionNum; section ++) {
        NSInteger itemsInSection = [self numberOfItemsInSection:section];
        for (NSInteger row = 0; row < itemsInSection; row ++) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:row inSection:section];
            UICollectionViewLayoutAttributes * layoutAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            if ([self isVisibleFrame:layoutAttributes.frame]) {
                [indexPaths addObject:indexPath];
            }
        }
    }
    return [indexPaths copy];
}

- (NSArray *)indexPathsForVisibleSupplementaryElementsOfKind:(NSString *)elementKind
{
    NSMutableArray * indexPaths = [NSMutableArray array];
    NSInteger sectionNum = self.numberOfSections;
    for (NSInteger section = 0; section < sectionNum; section ++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        UICollectionViewLayoutAttributes * layoutAttributes = [self layoutAttributesForSupplementaryElementOfKind:elementKind atIndexPath:indexPath];
        if ([self isVisibleFrame:layoutAttributes.frame]) {
            [indexPaths addObject:indexPath];
        }
    }
    return [indexPaths copy];
}

- (void)reloadItemsAtIndexPaths:(NSArray *)indexPaths
{
    if ([indexPaths isKindOfClass:[NSArray class]]) {
        for (NSIndexPath * indexPath in indexPaths) {
            FlyCollectionReusableView * cellView = [self cellForItemAtIndexPath:indexPath];
            if (cellView && cellView.superview != self) {
                [self addSubview:cellView];
            }
        }
    }
}

- (void)reloadSupplementaryElementsOfKind:(NSString *)elementKind atIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    if ([indexPaths isKindOfClass:[NSArray class]] && [elementKind isKindOfClass:[NSString class]]) {
        for (NSIndexPath * indexPath in indexPaths) {
            FlyCollectionReusableView * supplementaryView = [self supplementaryViewForElementKind:elementKind atIndexPath:indexPath];
            if (supplementaryView && supplementaryView.superview != self) {
                [self addSubview:supplementaryView];
            }
        }
    }
}

//重新排序
- (NSArray *)reorderedItems
{
    return nil;
}

- (FlyCollectionReusableView *)cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FlyCollectionReusableView * reusableView = nil;
    if ([self dataSourceResponseSEL:@selector(flyCollectionView:cellForItemAtIndexPath:)]) {
        reusableView = [self.dataSource flyCollectionView:self cellForItemAtIndexPath:indexPath];
    }
    return reusableView;
}

- (NSIndexPath *)indexPathForCell:(FlyCollectionReusableView *)cell
{
    NSIndexPath * targetIndexPath = nil;
    for (NSIndexPath * indexPath in _visibleCellsDict.allKeys) {
        FlyCollectionReusableView * reusabelView = [_visibleCellsDict objectForKey:indexPath];
        if (reusabelView == cell) {
            targetIndexPath = indexPath;
            break;
        }
    }
    return targetIndexPath;
}

- (NSArray *)visibleViews
{
    return nil;
}

- (void)updateSectionIndex
{
    
}

- (BOOL)isViewInReuseQueue:(NSDictionary *)reuseQueue
{
    return NO;
}

- (void)updateVisibleCellsNow:(NSArray *)updateCells
{
    
    
}

- (FlyCollectionReusableView *)visibleViewForLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    FlyCollectionReusableView * visibleView = nil;
    if ([layoutAttributes isKindOfClass:[UICollectionViewLayoutAttributes class]]) {
        NSIndexPath * indexPath = layoutAttributes.indexPath;
        if (indexPath && !layoutAttributes.representedElementKind) {
            visibleView = [_visibleCellsDict objectForKey:indexPath];
        }
    }
    return visibleView;
}

//_scrollFirstResponderCellToVisible:

#pragma mark - layoutAttributes
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * layoutAttributes = [self.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * layoutAttributes = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        layoutAttributes = [self.collectionViewLayout layoutAttributesForHeadterInSection:indexPath.section];
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        layoutAttributes = [self.collectionViewLayout layoutAttributesForFooterInSection:indexPath.section];
    }
    return layoutAttributes;
}

#pragma mark - scroll
- (void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
    [self didScroll];
}

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated
{
    [super setContentOffset:contentOffset animated:animated];
    [self didScroll];
}

- (void)didScroll
{
    NSMutableDictionary * visibleCellsDict = [_visibleCellsDict mutableCopy];
    for (NSIndexPath * indexPath in visibleCellsDict.allKeys) {
        FlyCollectionReusableView * itemView = [visibleCellsDict objectForKey:indexPath];
        if (![self isVisibleFrame:itemView.frame]) {
            [itemView removeFromSuperview];
            [_visibleCellsDict removeObjectForKey:indexPath];
            NSMutableSet * mutableSet = [_cellReuseQueues objectForKey:itemView.reuseIdentifier];
            if (mutableSet) {
                [mutableSet addObject:itemView];
            }
        }
    }
    [self reloadVisibleViews];
}

- (BOOL)isVisibleFrame:(CGRect)frame
{
    BOOL isVisible = NO;
    
    CGSize visableSize = self.visibleSize;
    CGPoint offSet = self.contentOffset;
    CGRect visibleRect = CGRectMake(offSet.x, offSet.y, visableSize.width, visableSize.height);
    
    isVisible = CGRectContainsRect(visibleRect, frame);
    if (!isVisible) {
       isVisible = CGRectIntersectsRect(visibleRect, frame);
    }
    return isVisible;
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
    self.collectionViewLayout.collectionView = nil;
    [super removeFromSuperview];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    [self reloadData];
}

+ (NSString *)reuseKeyForSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier
{
    NSString * resultString = nil;
    if ([kind isKindOfClass:[NSString class]] && [identifier isKindOfClass:[NSString class]]) {
        resultString = [NSString stringWithFormat:@"%@/%@",kind,identifier];
    }
    return resultString;
}

@end
