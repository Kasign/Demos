//
//  FlyCollectionView.m
//  DiyCollectionView
//
//  Created by Fly. on 2018/11/29.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "FlyCollectionView.h"
#import <objc/runtime.h>

@interface FlyCollectionView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableDictionary   *   cellReuseQueues;//复用池 identifier : NSMutableSet
@property (nonatomic, strong) NSMutableDictionary   *   visibleCellsDict;//可见的cell indexPath:FlyCollectionReusableView
@property (nonatomic, strong) NSMutableDictionary   *   cellClassDict;//注册的类名表 identifier:className
@property (nonatomic, strong) NSMutableDictionary   *   supplementaryViewReuseQueues;//复用池 key：NSMutableSet{}
@property (nonatomic, strong) NSMutableDictionary   *   supplementaryViewClassDict;//注册的类名表 key:className
@property (nonatomic, strong) NSMutableDictionary   *   visibleSupplementaryViewsDict;//可见的 kind:{indexPath:view}
@property (nonatomic, strong) NSMutableDictionary   *   itemCountInSectionDict;//每个section中item个数
@property (nonatomic, readwrite) NSInteger    numberOfSections;
@property (nonatomic, assign) NSInteger       moreCount;

@property (nonatomic, strong) NSMutableArray   *   reloadItems;
@property (nonatomic, strong) NSMutableArray   *   insertItems;
@property (nonatomic, strong) NSMutableArray   *   deleteItems;

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
        self.backgroundColor = [UIColor clearColor];
        self.collectionViewLayout = layout;
        [self fly_setUp];
    }
    return self;
}

- (void)fly_setUp {
    
    _cellReuseQueues = [NSMutableDictionary dictionary];
    _cellClassDict = [NSMutableDictionary dictionary];
    _supplementaryViewClassDict = [NSMutableDictionary dictionary];
    _supplementaryViewReuseQueues = [NSMutableDictionary dictionary];
    _itemCountInSectionDict = [NSMutableDictionary dictionary];
    self.collectionViewLayout.collectionView = self;
    _numberOfSections = -1;
    _visibleCellsDict = [NSMutableDictionary dictionary];
    _visibleSupplementaryViewsDict = [NSMutableDictionary dictionary];
}

- (void)reset_cachedData
{
    [self reload_cachedData];
    
    //将可见的cell放入复用池
    for (NSIndexPath * indexPath in _visibleCellsDict.allKeys) {
        FlyCollectionReusableView * cell = [_visibleCellsDict objectForKey:indexPath];
        [self p_insertCellToReuseQueueFromVisibleDict:cell indexPath:indexPath];
    }
}

- (void)reload_cachedData
{
    _numberOfSections = -1;
    _itemCountInSectionDict = [NSMutableDictionary dictionary];
    //section数量 item数量
    for (NSInteger section = 0; section < [self numberOfSections]; section++) {
        [self p_numberOfItemsInSection:section];
    }
    
}

- (NSInteger)numberOfSections
{
    if (_numberOfSections == -1) {
        if ([self dataSourceResponseSEL:@selector(numberOfSectionsInFlyCollectionView:)]) {
            _numberOfSections = [self.dataSource numberOfSectionsInFlyCollectionView:self];
        }
    }
    _numberOfSections = MAX(_numberOfSections, 0);
    return _numberOfSections;
}

- (NSInteger)p_numberOfItemsInSection:(NSInteger)section
{
    NSInteger numerOfItems = 0;
    NSNumber * itemsCountNum = [_itemCountInSectionDict objectForKey:@(section)];
    if (!itemsCountNum) {
        if ([self dataSourceResponseSEL:@selector(flyCollectionView:numberOfItemsInSection:)]) {
            numerOfItems = [self.dataSource flyCollectionView:self numberOfItemsInSection:section];
            numerOfItems = MAX(numerOfItems, 0);
            [_itemCountInSectionDict setObject:@(numerOfItems) forKey:@(section)];
        }
    } else {
        numerOfItems = [itemsCountNum integerValue];
    }
    
    return numerOfItems;
}

#pragma mark - register

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier
{
    if ([identifier isKindOfClass:[NSString class]] && cellClass)
    {
        [_cellClassDict setObject:cellClass forKey:identifier];
        NSMutableSet * mutableSet = [NSMutableSet set];
        [_cellReuseQueues setObject:mutableSet forKey:identifier];
    }
}

- (void)registerClass:(Class)viewClass forSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier
{
    if (viewClass && [identifier isKindOfClass:[NSString class]] && [elementKind isKindOfClass:[NSString class]])
    {
        [_visibleSupplementaryViewsDict setObject:[NSMutableDictionary dictionary] forKey:elementKind];
        NSString * reuseKey = [FlyCollectionView reuseKeyForSupplementaryViewOfKind:elementKind withReuseIdentifier:identifier];
        if (reuseKey) {
            [_supplementaryViewClassDict setObject:viewClass forKey:reuseKey];
            NSMutableSet * mutableSet = [NSMutableSet set];
            [_supplementaryViewReuseQueues setObject:mutableSet forKey:reuseKey];
        }
    }
}

#pragma mark - reload & 刷新
- (void)reloadData
{
    [self reset_cachedData];
    [self.collectionViewLayout prepareLayout];
    [self reloadVisibleViews];
}

- (void)reloadVisibleViews
{
    [self reloadVisibleHeaders];
    [self reloadVisibleCells];
    [self reloadVisibleFooters];
}

- (void)reloadVisibleCells
{
    NSArray * visibleIndexPaths = [self p_indexPathsForVisibleItemsExceptArr:_visibleCellsDict.allKeys];
    [self p_reloadItemsAtIndexPaths:visibleIndexPaths];
}

- (void)reloadVisibleHeaders
{
    if ([self isValidForElementKind:UICollectionElementKindSectionHeader]) {
        NSDictionary * headerDict = [_visibleSupplementaryViewsDict objectForKey:UICollectionElementKindSectionHeader];
        NSArray * visibleHeaderIndexPaths = [self p_indexPathsForVisibleSupplementaryElementsOfKind:UICollectionElementKindSectionHeader exceptArr:headerDict.allKeys];
        [self p_reloadSupplementaryElementsOfKind:UICollectionElementKindSectionHeader atIndexPaths:visibleHeaderIndexPaths];
    }
}

- (void)reloadVisibleFooters
{
    if ([self isValidForElementKind:UICollectionElementKindSectionFooter]) {
        NSDictionary * footerDict = [_visibleSupplementaryViewsDict objectForKey:UICollectionElementKindSectionFooter];
        NSArray * visibleFooterIndexPaths = [self p_indexPathsForVisibleSupplementaryElementsOfKind:UICollectionElementKindSectionFooter exceptArr:footerDict.allKeys];
        [self p_reloadSupplementaryElementsOfKind:UICollectionElementKindSectionFooter atIndexPaths:visibleFooterIndexPaths];
    }
}

#pragma mark reload 重新delegate
- (void)p_reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    if ([indexPaths isKindOfClass:[NSArray class]]) {
        for (NSIndexPath * indexPath in indexPaths) {
            FlyCollectionReusableView * cellView = [self p_cellForItemAtIndexPath:indexPath];
            if (cellView && cellView.superview != self) {
                [self addSubview:cellView];
            }
        }
    }
}

- (void)p_reloadSupplementaryElementsOfKind:(NSString *)elementKind atIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    if ([indexPaths isKindOfClass:[NSArray class]] && [elementKind isKindOfClass:[NSString class]]) {
        for (NSIndexPath * indexPath in indexPaths) {
            FlyCollectionReusableView * supplementaryView = [self p_supplementaryViewForElementKind:elementKind atIndexPath:indexPath];
            if (supplementaryView && supplementaryView.superview != self) {
                [self addSubview:supplementaryView];
            }
        }
    }
}

#pragma mark 单个刷新delegate
- (nullable FlyCollectionReusableView *)p_supplementaryViewForElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    FlyCollectionReusableView * reusableView = nil;
    if ([self dataSourceResponseSEL:@selector(flyCollectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
        reusableView = [self.dataSource flyCollectionView:self viewForSupplementaryElementOfKind:elementKind atIndexPath:indexPath];
    }
    return reusableView;
}

- (FlyCollectionReusableView *)p_cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FlyCollectionReusableView * reusableView = nil;
    if ([self dataSourceResponseSEL:@selector(flyCollectionView:cellForItemAtIndexPath:)]) {
        reusableView = [self.dataSource flyCollectionView:self cellForItemAtIndexPath:indexPath];
    }
    return reusableView;
}

#pragma mark reLayout
- (void)p_reLayoutItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    if ([indexPaths isKindOfClass:[NSArray class]]) {
        for (NSIndexPath * indexPath in indexPaths) {
            [self p_reLayoutCellWithIndexPath:indexPath];
        }
    }
}

- (void)p_reLayoutSupplementaryElementsOfKind:(NSString *)elementKind atIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    if ([indexPaths isKindOfClass:[NSArray class]] && [elementKind isKindOfClass:[NSString class]]) {
        for (NSIndexPath * indexPath in indexPaths) {
            [self p_reLayoutSupplementaryOfKind:elementKind indexPath:indexPath];
        }
    }
}

- (void)p_reLayoutCellWithIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath isKindOfClass:[NSIndexPath class]]) {
        UICollectionViewLayoutAttributes * layoutAttributes = [self p_layoutAttributesForItemAtIndexPath:indexPath];
        FlyCollectionReusableView * cell = [self p_getCellFromVisibleDict:indexPath];
        if ([cell isKindOfClass:[FlyCollectionReusableView class]]) {
            FlyLog(@"%@ %@",[self stringWithIndexPath:indexPath],[NSValue valueWithCGRect:layoutAttributes.frame]);
            [self p_layoutReusableView:cell layoutAttributes:layoutAttributes];
        }
    }
}

- (void)p_reLayoutSupplementaryOfKind:(NSString *)elementKind indexPath:(NSIndexPath *)indexPath
{
    if ([indexPath isKindOfClass:[NSIndexPath class]] && [elementKind isKindOfClass:[NSString class]]) {
        UICollectionViewLayoutAttributes * layoutAttributes = [self p_layoutAttributesForSupplementaryElementOfKind:elementKind atIndexPath:indexPath];
        FlyCollectionReusableView * supplementaryView = [self p_getSupplementaryFromVisibleDict:indexPath kind:elementKind];
        if (supplementaryView) {
            [self p_layoutReusableView:supplementaryView layoutAttributes:layoutAttributes];
        }
    }
}

#pragma mark - remove & insert
- (void)p_removeCellFromVisibleCells:(NSArray<NSIndexPath *> *)indexPaths
{
    if ([indexPaths isKindOfClass:[NSArray class]] && indexPaths.count > 0) {
        for (NSIndexPath * indexPath in indexPaths) {
            FlyCollectionReusableView * cell = [self p_getCellFromVisibleDict:indexPath];
            [self p_insertCellToReuseQueueFromVisibleDict:cell indexPath:indexPath];
        }
    }
}

#pragma mark - dequeueReusable
- (FlyCollectionReusableView *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * layoutAttributes = [self p_layoutAttributesForItemAtIndexPath:indexPath];
    FlyCollectionReusableView * reusableView = [self p_getCellFromVisibleDict:indexPath];
    if (!reusableView) {
        reusableView = [self p_reusableCellViewWithIdentifier:identifier layoutAttributes:layoutAttributes];
    }
    [self p_layoutReusableView:reusableView layoutAttributes:layoutAttributes];
    if (reusableView) {
        [self p_insertCellToVisibleDict:reusableView indexPath:indexPath];
    }
    
    return reusableView;
}

- (FlyCollectionReusableView *)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * layoutAttributes = [self p_layoutAttributesForSupplementaryElementOfKind:elementKind atIndexPath:indexPath];
    FlyCollectionReusableView * reusableView = [self p_getSupplementaryFromVisibleDict:indexPath kind:elementKind];
    if (!reusableView) {
        reusableView = [self p_supplementaryViewForElementKind:elementKind identifier:identifier layoutAttributes:layoutAttributes];
    }
    [self p_layoutReusableView:reusableView layoutAttributes:layoutAttributes];
    if (reusableView) {
        [self p_insertSupplementaryToVisibleDict:reusableView kind:elementKind indexPath:indexPath];
    }
    return reusableView;
}

#pragma mark - 生成或者从复用池取
- (FlyCollectionReusableView *)p_reusableCellViewWithIdentifier:(NSString *)identifier layoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    FlyCollectionReusableView * reusableView = nil;
    if (identifier) {
        reusableView = [self p_getCellFromReuseQueues:identifier];
        if (!reusableView) {
            Class cellClass = [_cellClassDict objectForKey:identifier];
            reusableView = [[cellClass alloc] initWithFrame:layoutAttributes.bounds];
            reusableView.reuseIdentifier = identifier;
        }
    }
    return reusableView;
}

- (FlyCollectionReusableView *)p_supplementaryViewForElementKind:(NSString *)elementKind identifier:(NSString *)identifier layoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    FlyCollectionReusableView * reusableView = nil;
    if (identifier && elementKind) {
        NSString * reuseKey = [FlyCollectionView reuseKeyForSupplementaryViewOfKind:elementKind withReuseIdentifier:identifier];
        if (reuseKey) {
            reusableView = [self p_getSupplementaryFromReuseQueues:identifier kind:elementKind];
            if (!reusableView) {
                Class supplementaryClass = [_supplementaryViewClassDict objectForKey:reuseKey];
                reusableView = [[supplementaryClass alloc] initWithFrame:layoutAttributes.bounds];
                reusableView.reuseIdentifier = identifier;
            }
        }
    }
    return reusableView;
}

#pragma mark - 复用池 ↔ visible
#pragma mark 1、cell重新进入复用池
- (void)p_insertCellToReuseQueueFromVisibleDict:(FlyCollectionReusableView *)reusableView indexPath:(NSIndexPath *)indexPath
{
    if ([reusableView isKindOfClass:[FlyCollectionReusableView class]]) {
        NSString * identifier = reusableView.reuseIdentifier;
        if (identifier) {
            [self p_deleteCellFromVisibleDict:reusableView indexPath:indexPath];
            [self p_insertCellToReuseQueues:reusableView];
        }
    }
}

#pragma mark 2、cell从复用池进入可见区域
- (void)p_insertCellToVisibleDictFromReuseQueue:(FlyCollectionReusableView *)reusableView indexPath:(NSIndexPath *)indexPath
{
    if ([reusableView isKindOfClass:[FlyCollectionReusableView class]] && [indexPath isKindOfClass:[NSIndexPath class]] && [self isVisibleFrame:reusableView.frame]) {
        NSString * identifier = reusableView.reuseIdentifier;
        if (identifier) {
            [self p_deleteCellFromReuseQueues:reusableView];
            [self p_insertCellToVisibleDict:reusableView indexPath:indexPath];
        }
    }
}

#pragma mark 3、Supplementary重新进入复用池
- (void)p_insertSupplementaryToReuseQueuesFromVisibleDict:(FlyCollectionReusableView *)reusableView kind:(NSString *)elementKind indexPath:(NSIndexPath *)indexPath
{
    if ([reusableView isKindOfClass:[FlyCollectionReusableView class]]) {
        NSString * identifier = reusableView.reuseIdentifier;
        if (identifier) {
            [self p_deleteSupplementaryFromVisibleDict:reusableView kind:elementKind indexPath:indexPath];
            [self p_insertSupplementaryToReuseQueues:reusableView kind:elementKind];
        }
    }
}

#pragma mark 4、Supplementary从复用池进入可见区域
- (void)p_insertSupplementaryToVisibleDictFromReuseQueues:(FlyCollectionReusableView *)reusableView kind:(NSString *)elementKind indexPath:(NSIndexPath *)indexPath
{
    if ([reusableView isKindOfClass:[FlyCollectionReusableView class]] && [indexPath isKindOfClass:[NSIndexPath class]] && [self isVisibleFrame:reusableView.frame]) {
        NSString * identifier = reusableView.reuseIdentifier;
        if (identifier) {
            [self p_deleteSupplementaryFromReuseQueues:reusableView kind:elementKind];
            [self p_insertSupplementaryToVisibleDict:reusableView kind:elementKind indexPath:indexPath];
        }
    }
}

#pragma mark ①、CellReuseQueues
- (void)p_insertCellToReuseQueues:(FlyCollectionReusableView *)reusableView
{
    if ([reusableView isKindOfClass:[FlyCollectionReusableView class]]) {
        NSString * identifier = reusableView.reuseIdentifier;
        if (identifier) {
            NSMutableSet * mutableSet = [_cellReuseQueues objectForKey:identifier];
            if (mutableSet) {
                [reusableView removeFromSuperview];
                [mutableSet addObject:reusableView];
            }
        }
    }
}

- (void)p_deleteCellFromReuseQueues:(FlyCollectionReusableView *)reusableView
{
    if ([reusableView isKindOfClass:[FlyCollectionReusableView class]]) {
        NSString * identifier = reusableView.reuseIdentifier;
        if (identifier) {
            NSMutableSet * mutableSet = [_cellReuseQueues objectForKey:identifier];
            if (mutableSet) {
                [mutableSet removeObject:reusableView];
            }
        }
    }
}

- (FlyCollectionReusableView *)p_getCellFromReuseQueues:(NSString *)identifier
{
    FlyCollectionReusableView * reusableView = nil;
    if ([identifier isKindOfClass:[NSString class]]) {
        NSMutableSet * mutableSet = [_cellReuseQueues objectForKey:identifier];
        if (mutableSet) {
            reusableView = [mutableSet anyObject];
            if (reusableView) {
                [reusableView setReuseIdentifier:identifier];
                [mutableSet removeObject:reusableView];
            }
        } else {
            FlyLog(@"mutableSet 丢失 %s",__FUNCTION__);
        }
    }
    return reusableView;
}

#pragma mark ②、VisibleCell
- (void)p_insertCellToVisibleDict:(FlyCollectionReusableView *)reusableView indexPath:(NSIndexPath *)indexPath
{
    if ([reusableView isKindOfClass:[FlyCollectionReusableView class]] && [indexPath isKindOfClass:[NSIndexPath class]]) {
        [_visibleCellsDict setObject:reusableView forKey:indexPath];
    }
}

- (void)p_deleteCellFromVisibleDict:(FlyCollectionReusableView *)reusableView indexPath:(NSIndexPath *)indexPath
{
    if ([reusableView isKindOfClass:[FlyCollectionReusableView class]]) {
        NSIndexPath * deleteIndexPath = nil;
        if ([indexPath isKindOfClass:[NSIndexPath class]]) {
            FlyCollectionReusableView * currentCell = [_visibleCellsDict objectForKey:indexPath];
            if (currentCell == reusableView) {
                deleteIndexPath = indexPath;
            }
        }
        if (!deleteIndexPath) {
            for (NSIndexPath * subIndexPath in _visibleCellsDict.allKeys) {
                FlyCollectionReusableView * currentCell = [_visibleCellsDict objectForKey:subIndexPath];
                if (currentCell == reusableView) {
                    deleteIndexPath = subIndexPath;
                    break;
                }
            }
        }
        if (deleteIndexPath) {
            [_visibleCellsDict removeObjectForKey:deleteIndexPath];
        }
    }
}

- (FlyCollectionReusableView *)p_getCellFromVisibleDict:(NSIndexPath *)indexPath
{
    FlyCollectionReusableView * reusableView = nil;
    if ([indexPath isKindOfClass:[NSIndexPath class]]) {
        reusableView = [_visibleCellsDict objectForKey:indexPath];
    }
    return reusableView;
}

#pragma mark ③、SupplementaryReuseQueues
- (void)p_insertSupplementaryToReuseQueues:(FlyCollectionReusableView *)reusableView kind:(NSString *)elementKind
{
    if ([reusableView isKindOfClass:[FlyCollectionReusableView class]] && [elementKind isKindOfClass:[NSString class]]) {
        NSString * identifier = reusableView.reuseIdentifier;
        if (identifier) {
            NSString * reuseKey = [FlyCollectionView reuseKeyForSupplementaryViewOfKind:elementKind withReuseIdentifier:identifier];
            NSMutableSet * mutableSet = [_supplementaryViewReuseQueues objectForKey:reuseKey];
            if (mutableSet) {
                [reusableView removeFromSuperview];
                [mutableSet addObject:reusableView];
            } else {
                FlyLog(@"mutableSet 丢失 %s",__FUNCTION__);
            }
        }
    }
}

- (void)p_deleteSupplementaryFromReuseQueues:(FlyCollectionReusableView *)reusableView kind:(NSString *)elementKind
{
    if ([reusableView isKindOfClass:[FlyCollectionReusableView class]] && [elementKind isKindOfClass:[NSString class]]) {
        NSString * identifier = reusableView.reuseIdentifier;
        if (identifier) {
            NSString * reuseKey = [FlyCollectionView reuseKeyForSupplementaryViewOfKind:elementKind withReuseIdentifier:identifier];
            NSMutableSet * mutableSet = [_supplementaryViewReuseQueues objectForKey:reuseKey];
            if (mutableSet) {
                [mutableSet removeObject:reusableView];
            }
        }
    }
}

- (FlyCollectionReusableView *)p_getSupplementaryFromReuseQueues:(NSString *)identifier kind:(NSString *)elementKind
{
    FlyCollectionReusableView * reusableView = nil;
    if ([identifier isKindOfClass:[NSString class]] && [elementKind isKindOfClass:[NSString class]]) {
        NSString * reuseKey = [FlyCollectionView reuseKeyForSupplementaryViewOfKind:elementKind withReuseIdentifier:identifier];
        NSMutableSet * mutableSet = [_supplementaryViewReuseQueues objectForKey:reuseKey];
        if (mutableSet) {
            reusableView = [mutableSet anyObject];
            if (reusableView) {
                [reusableView setReuseIdentifier:identifier];
                [mutableSet removeObject:reusableView];
            }
        } else {
            FlyLog(@"mutableSet 丢失 %s",__FUNCTION__);
        }
    }
    return reusableView;
}


#pragma mark ④、VisibleSupplementary
- (void)p_insertSupplementaryToVisibleDict:(FlyCollectionReusableView *)reusableView kind:(NSString *)elementKind indexPath:(NSIndexPath *)indexPath
{
    if ([reusableView isKindOfClass:[FlyCollectionReusableView class]] && [elementKind isKindOfClass:[NSString class]] && [indexPath isKindOfClass:[NSIndexPath class]]) {
        NSString * identifier = reusableView.reuseIdentifier;
        if (identifier) {
            NSMutableDictionary * mutableDict = [_visibleSupplementaryViewsDict objectForKey:elementKind];
            if (mutableDict) {
                [mutableDict setObject:reusableView forKey:indexPath];
            } else {
                FlyLog(@"数据丢失 %s",__FUNCTION__);
            }
        }
    }
}

- (void)p_deleteSupplementaryFromVisibleDict:(FlyCollectionReusableView *)reusableView kind:(NSString *)elementKind indexPath:(NSIndexPath *)indexPath
{
    if ([reusableView isKindOfClass:[FlyCollectionReusableView class]] && [elementKind isKindOfClass:[NSString class]]) {
        NSMutableDictionary * mutableDict = [_visibleSupplementaryViewsDict objectForKey:elementKind];
        NSIndexPath * deleteIndexPath = nil;
        if ([indexPath isKindOfClass:[NSIndexPath class]]) {
            FlyCollectionReusableView * currentView = [mutableDict objectForKey:indexPath];
            if (currentView == reusableView) {
                deleteIndexPath = indexPath;
            }
        }
        if (!deleteIndexPath) {
            for (NSIndexPath * subIndexPath in mutableDict.allKeys) {
                FlyCollectionReusableView * currentView = [mutableDict objectForKey:subIndexPath];
                if (currentView == reusableView) {
                    deleteIndexPath = subIndexPath;
                    break;
                }
            }
        }
        if (deleteIndexPath) {
            [mutableDict removeObjectForKey:deleteIndexPath];
        }
    }
}

- (FlyCollectionReusableView *)p_getSupplementaryFromVisibleDict:(NSIndexPath *)indexPath kind:(NSString *)elementKind
{
    FlyCollectionReusableView * reusableView = nil;
    if ([indexPath isKindOfClass:[NSIndexPath class]] && [elementKind isKindOfClass:[NSString class]]) {
        NSMutableDictionary * mutableDict = [_visibleSupplementaryViewsDict objectForKey:elementKind];
        if (mutableDict) {
            reusableView = [mutableDict objectForKey:indexPath];
        }
    }
    return reusableView;
}

#pragma mark - 获取 indexPath
#warning 可优化
- (NSArray *)p_indexPathsForVisibleItems
{
    NSMutableArray * indexPaths = [NSMutableArray array];
    NSInteger sectionNum = self.numberOfSections;
    for (NSInteger section = 0; section < sectionNum; section ++) {
        NSInteger itemsInSection = [self p_numberOfItemsInSection:section];
        for (NSInteger row = 0; row < itemsInSection; row ++) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:row inSection:section];
            UICollectionViewLayoutAttributes * layoutAttributes = [self p_layoutAttributesForItemAtIndexPath:indexPath];
            if ([self isVisibleFrame:layoutAttributes.frame]) {
                [indexPaths addObject:indexPath];
            }
        }
    }
    return [indexPaths copy];
}

- (NSArray *)p_indexPathsForVisibleItemsExceptArr:(NSArray<NSIndexPath *> *)exceptArr
{
    NSArray * remainIndexPaths = nil;
    NSMutableArray * visibleIndexPaths = [[self p_indexPathsForVisibleItems] mutableCopy];
    if ([exceptArr isKindOfClass:[NSArray class]]) {
        [visibleIndexPaths removeObjectsInArray:exceptArr];
    }
    remainIndexPaths = [visibleIndexPaths copy];
    return remainIndexPaths;
}

- (NSArray *)p_indexPathsForVisibleSupplementaryElementsOfKind:(NSString *)elementKind
{
    NSMutableArray * indexPaths = [NSMutableArray array];
    if ([self isValidForElementKind:elementKind]) {
        NSInteger sectionNum = self.numberOfSections;
        for (NSInteger section = 0; section < sectionNum; section ++) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            UICollectionViewLayoutAttributes * layoutAttributes = [self p_layoutAttributesForSupplementaryElementOfKind:elementKind atIndexPath:indexPath];
            if ([self isVisibleFrame:layoutAttributes.frame]) {
                [indexPaths addObject:indexPath];
            }
        }
    }
    return [indexPaths copy];
}

- (NSArray *)p_indexPathsForVisibleSupplementaryElementsOfKind:(NSString *)elementKind exceptArr:(NSArray<NSIndexPath *> *)exceptArr
{
    NSArray * remainIndexPaths = nil;
    NSMutableArray * visibleHeaderIndexPaths = [[self p_indexPathsForVisibleSupplementaryElementsOfKind:elementKind] mutableCopy];
    if ([exceptArr isKindOfClass:[NSArray class]] && exceptArr.count > 0 && exceptArr.count > 0) {
        [visibleHeaderIndexPaths removeObjectsInArray:exceptArr];
    }
    remainIndexPaths = [visibleHeaderIndexPaths copy];
    return remainIndexPaths;
}

- (NSIndexPath *)p_indexPathForCell:(FlyCollectionReusableView *)cell
{
    NSIndexPath * targetIndexPath = nil;
    if ([cell isKindOfClass:[FlyCollectionReusableView class]]) {
        for (NSIndexPath * indexPath in _visibleCellsDict.allKeys) {
            FlyCollectionReusableView * reusabelView = [_visibleCellsDict objectForKey:indexPath];
            if (reusabelView == cell) {
                targetIndexPath = indexPath;
                break;
            }
        }
    }
    return targetIndexPath;
}

- (NSIndexPath *)p_indexPathForSupplementaryView:(FlyCollectionReusableView *)supplementaryView isHeader:(BOOL *)isHeader isFooter:(BOOL *)isFooter
{
    NSIndexPath * targetIndexPath = nil;
    BOOL isInHeader = NO;
    BOOL isInFooter = NO;
    
    NSMutableDictionary * visibleHeaderDict = [_visibleSupplementaryViewsDict objectForKey:UICollectionElementKindSectionHeader];
    NSMutableDictionary * visibleFooterDict = [_visibleSupplementaryViewsDict objectForKey:UICollectionElementKindSectionFooter];
    
    for (NSIndexPath * indexPath in visibleHeaderDict.allKeys) {
        FlyCollectionReusableView * reusabelView = [visibleHeaderDict objectForKey:indexPath];
        if (reusabelView == supplementaryView) {
            targetIndexPath = indexPath;
            isInHeader = YES;
            break;
        }
    }
    
    if (!targetIndexPath) {
        for (NSIndexPath * indexPath in visibleFooterDict.allKeys) {
            FlyCollectionReusableView * reusabelView = [visibleFooterDict objectForKey:indexPath];
            if (reusabelView == supplementaryView) {
                targetIndexPath = indexPath;
                isInFooter = YES;
                break;
            }
        }
    }
    
    if (isHeader) {
        *isHeader = isInHeader;
    }
    if (isFooter) {
        *isFooter = isInFooter;
    }
    
    return targetIndexPath;
}

#pragma mark - 设置frame等
- (void)p_layoutReusableView:(FlyCollectionReusableView *)reusableView layoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    if ([reusableView isKindOfClass:[FlyCollectionReusableView class]] && [layoutAttributes isKindOfClass:[UICollectionViewLayoutAttributes class]]) {
        if (!CGRectEqualToRect(reusableView.frame, layoutAttributes.frame)) {
            [reusableView setFrame:layoutAttributes.frame];
        }
        if (!CGAffineTransformEqualToTransform(layoutAttributes.transform, CGAffineTransformIdentity)) {
            reusableView.transform = layoutAttributes.transform;
        }
        if (!CATransform3DEqualToTransform(layoutAttributes.transform3D, CATransform3DIdentity)) {
            reusableView.layoutAttributes.transform3D = layoutAttributes.transform3D;
        }
        if (layoutAttributes.zIndex != 0) {
            reusableView.layer.zPosition = layoutAttributes.zIndex;
        }
        if (layoutAttributes.alpha != 1.f) {
            reusableView.alpha = layoutAttributes.alpha;
        }
    }
}

#pragma mark - sys

//重新排序
- (NSArray *)reorderedItems
{
    return nil;
}

- (NSArray *)visibleViews
{
    return nil;
}

- (void)updateSectionIndex
{
    
}

- (BOOL)isViewInReuseQueue:(FlyCollectionReusableView *)reusableView
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
- (UICollectionViewLayoutAttributes *)p_layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * layoutAttributes = [self.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)p_layoutAttributesForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * layoutAttributes = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        layoutAttributes = [self.collectionViewLayout layoutAttributesForHeaderInSection:indexPath.section];
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        layoutAttributes = [self.collectionViewLayout layoutAttributesForFooterInSection:indexPath.section];
    }
    return layoutAttributes;
}

#pragma mark - scroll
- (void)p_didScroll
{
    [self p_insertUnVisibleViewToReuseQueuesFromVisibleDicts];
    [self reloadVisibleViews];
}

- (void)scrollToSection:(NSInteger)section atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    NSInteger sectionCount = [self numberOfSections];
    if (section >= 0 && sectionCount > section) {
        CGRect indexRect = [self.collectionViewLayout rectForSection:section];
        [self p_orgScrollToRect:indexRect atScrollPosition:scrollPosition animated:animated];
    }
}

- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated
{
//    if (![self isValidIndexPath:indexPath]) {
//        return;
//    }

    CGRect indexRect = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
    if (CGRectEqualToRect(indexRect, CGRectZero)) {
        if ([self numberOfSections] > indexPath.section) {
            indexRect = [self.collectionViewLayout rectForSection:indexPath.section];
        } else {
            return;
        }
    }
    [self p_orgScrollToRect:indexRect atScrollPosition:scrollPosition animated:animated];
}

- (void)p_orgScrollToRect:(CGRect)rect atScrollPosition:(UICollectionViewScrollPosition)position animated:(BOOL)animated
{
    CGRect currentRect = rect;
    if (CGRectEqualToRect(currentRect, CGRectZero)) {
        return;
    }
    CGPoint currentOffset = self.contentOffset;
    CGFloat contentHeight = self.contentSize.height;
    CGFloat collectionHeight = CGRectGetHeight(self.frame);
    CGFloat offsetX = currentOffset.x;
    CGFloat offsetY = currentOffset.y;
    
    CGFloat insetBottom = self.contentInset.bottom;
    CGFloat insetTop    = self.contentInset.top;
    switch (position) {
        case UICollectionViewScrollPositionNone:
            if (offsetY + collectionHeight <= currentRect.origin.y) {
                offsetY = currentRect.origin.y + currentRect.size.height - collectionHeight;
            }
            break;
        case UICollectionViewScrollPositionTop:
            offsetY = currentRect.origin.y;
            break;
        case UICollectionViewScrollPositionCenteredVertically:
            offsetY = currentRect.origin.y + currentRect.size.height * 0.5 - collectionHeight * 0.5;
            break;
        case UICollectionViewScrollPositionBottom:
            offsetY = currentRect.origin.y + currentRect.size.height - collectionHeight;
            break;
            
        default:
            break;
    }
    CGFloat maxOffSetY = contentHeight + insetBottom - collectionHeight;
    offsetY = MAX(MIN(maxOffSetY, offsetY), - insetTop);
    if (offsetX != currentOffset.x && offsetY != currentOffset.y) {
        [self setContentOffset:CGPointMake(offsetX, offsetY) animated:animated];
    }
}

- (void)p_insertUnVisibleViewToReuseQueuesFromVisibleDicts
{
    NSMutableDictionary * visibleCellsDict = [_visibleCellsDict mutableCopy];
    for (NSIndexPath * indexPath in visibleCellsDict.allKeys) {
        FlyCollectionReusableView * itemView = [visibleCellsDict objectForKey:indexPath];
        if (![self isVisibleFrame:itemView.frame]) {
            [self p_insertCellToReuseQueueFromVisibleDict:itemView indexPath:indexPath];
        }
    }
    
    
    if ([self isValidForElementKind:UICollectionElementKindSectionHeader]) {
        NSDictionary * visibleHeaderDict = [[_visibleSupplementaryViewsDict objectForKey:UICollectionElementKindSectionHeader] copy];
        for (NSIndexPath * indexPath in visibleHeaderDict.allKeys) {
            FlyCollectionReusableView * itemView = [visibleHeaderDict objectForKey:indexPath];
            if (![self isVisibleFrame:itemView.frame]) {
                [self p_insertSupplementaryToReuseQueuesFromVisibleDict:itemView kind:UICollectionElementKindSectionHeader indexPath:indexPath];
            }
        }
    }
    
    if ([self isValidForElementKind:UICollectionElementKindSectionFooter]) {
        NSDictionary * visibleFooterDict = [[_visibleSupplementaryViewsDict objectForKey:UICollectionElementKindSectionFooter] copy];
        for (NSIndexPath * indexPath in visibleFooterDict.allKeys) {
            FlyCollectionReusableView * itemView = [visibleFooterDict objectForKey:indexPath];
            if (![self isVisibleFrame:itemView.frame]) {
                [self p_insertSupplementaryToReuseQueuesFromVisibleDict:itemView kind:UICollectionElementKindSectionFooter indexPath:indexPath];
            }
        }
    }
}

- (void)p_resetKeysWithReloadItems:(NSArray<NSIndexPath *> *)reloadIndexPaths isInsert:(BOOL)isInsert
{
    if ([reloadIndexPaths isKindOfClass:[NSArray class]] && reloadIndexPaths.count > 0) {
        NSMutableDictionary * resultDict = [NSMutableDictionary dictionaryWithCapacity:_visibleCellsDict.count + reloadIndexPaths.count];
        NSDictionary * visibleCellsDict = [_visibleCellsDict copy];
        for (NSIndexPath * indexPath in visibleCellsDict.allKeys) {
            FlyCollectionReusableView * view = [visibleCellsDict objectForKey:indexPath];
            int largeTime = 0;
            for (NSIndexPath * reloadIndexPath in reloadIndexPaths) {
                if (reloadIndexPath.section == reloadIndexPath.section) {
                    NSComparisonResult result = [indexPath compare:reloadIndexPath];
                    if (isInsert) {//插入
                        if (result != NSOrderedAscending) {//大于等于的都要加
                            largeTime ++;
                        }
                    } else {//删除
                        if (result == NSOrderedDescending) {//大的才减
                            largeTime --;
                        }
                    }
                }
            }
            NSIndexPath * resultIndexPath = indexPath;
            if (largeTime != 0) {
                resultIndexPath = [NSIndexPath indexPathForItem:MAX(0,(indexPath.item + largeTime)) inSection:indexPath.section];
            }
            if (view && resultIndexPath) {
                [resultDict setObject:view forKey:resultIndexPath];
            }
        }
        _visibleCellsDict = resultDict;
    }
}

#pragma mark - 条件判断
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

- (BOOL)isValidForElementKind:(NSString *)elementKind
{
    BOOL isValid = NO;
    for (NSString * key in _supplementaryViewClassDict.allKeys) {
        if ([key containsString:elementKind]) {
            isValid = YES;
            break;
        }
    }
    return isValid;
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

#pragma mark - 重写方法

- (void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
    [self p_didScroll];
}

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated
{
    [super setContentOffset:contentOffset animated:animated];
    [self p_didScroll];
}

- (void)removeFromSuperview
{
    self.collectionViewLayout.collectionView = nil;
    [super removeFromSuperview];
}

- (void)dealloc
{
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    [self reloadData];
}

#pragma mark - key
+ (NSString *)reuseKeyForSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier
{
    NSString * resultString = nil;
    if ([kind isKindOfClass:[NSString class]] && [identifier isKindOfClass:[NSString class]]) {
        resultString = [NSString stringWithFormat:@"%@/%@",kind,identifier];
    }
    return resultString;
}

#pragma mark - 公有方法
- (nullable FlyCollectionReusableView *)supplementaryViewForElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    FlyCollectionReusableView * reusableView = nil;
    if (elementKind && indexPath) {
        NSDictionary * dict = [_visibleSupplementaryViewsDict objectForKey:elementKind];
        reusableView = [dict objectForKey:indexPath];
    }
    return reusableView;
}

- (NSArray<FlyCollectionReusableView *> *)visibleCells
{
    return _visibleCellsDict.allValues;
}

- (NSArray<NSIndexPath *> *)indexPathsForVisibleItems
{
    return _visibleCellsDict.allKeys;
}

- (NSArray<FlyCollectionReusableView *> *)visibleSupplementaryViewsOfKind:(NSString *)elementKind
{
    NSArray * supplementaryViews = nil;
    if (elementKind) {
        NSDictionary * dict = [_visibleSupplementaryViewsDict objectForKey:elementKind];
        supplementaryViews = dict.allValues;
    }
    return supplementaryViews;
}

- (NSArray<NSIndexPath *> *)indexPathsForVisibleSupplementaryElementsOfKind:(NSString *)elementKind
{
    NSArray * indexPaths = nil;
    if (elementKind) {
        NSDictionary * dict = [_visibleSupplementaryViewsDict objectForKey:elementKind];
        indexPaths = dict.allKeys;
    }
    return [indexPaths copy];
}

- (NSIndexPath *)indexPathForCell:(FlyCollectionReusableView *)cell
{
    NSIndexPath * targetIndexPath = [self p_indexPathForCell:cell];
    return targetIndexPath;
}

- (FlyCollectionReusableView *)cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FlyCollectionReusableView * reusableView = nil;
    if (indexPath) {
        reusableView = [_visibleCellsDict objectForKey:indexPath];
    }
    return reusableView;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    NSNumber * itemsCountNum = [_itemCountInSectionDict objectForKey:@(section)];
    return [itemsCountNum integerValue];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * layoutAttributes = [self.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * layoutAttributes = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        layoutAttributes = [self.collectionViewLayout layoutAttributesForHeaderInSection:indexPath.section];
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        layoutAttributes = [self.collectionViewLayout layoutAttributesForFooterInSection:indexPath.section];
    }
    return layoutAttributes;
}

#pragma mark - insert & delete
#pragma mark section
- (void)insertSections:(NSIndexSet *)sections
{
    
}

- (void)deleteSections:(NSIndexSet *)sections
{
    
}

- (void)reloadSections:(NSIndexSet *)sections
{
    
}

- (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection
{
    
}

#pragma mark item
- (void)insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    if ([indexPaths isKindOfClass:[NSArray class]] && indexPaths.count > 0) {
        [self reload_cachedData];
        [self.collectionViewLayout prepareLayout];
        [self p_resetKeysWithReloadItems:indexPaths isInsert:YES];
        NSArray * needLayoutArr = [self p_indexPathsForVisibleItemsExceptArr:indexPaths];
        NSMutableArray * visibleCellKeys = [_visibleCellsDict.allKeys mutableCopy];
        [visibleCellKeys removeObjectsInArray:needLayoutArr];
        [self p_removeCellFromVisibleCells:visibleCellKeys];
        [UIView animateWithDuration:0.25 animations:^{
            [self p_reLayoutItemsAtIndexPaths:needLayoutArr];
            [self p_insertUnVisibleViewToReuseQueuesFromVisibleDicts];
        }];
        [self p_reloadItemsAtIndexPaths:indexPaths];
    }
}

- (void)deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    if ([indexPaths isKindOfClass:[NSArray class]] && indexPaths.count > 0) {
        [self reload_cachedData];
        [self.collectionViewLayout prepareLayout];
        [self p_removeCellFromVisibleCells:indexPaths];
        [self p_resetKeysWithReloadItems:indexPaths isInsert:NO];
        NSArray * needLayoutArr = [self p_indexPathsForVisibleItemsExceptArr:nil];
        
        NSMutableArray * needReloadArr = [needLayoutArr mutableCopy];
        [needReloadArr removeObjectsInArray:_visibleCellsDict.allKeys];
        [self p_reloadItemsAtIndexPaths:needReloadArr];
        
        [UIView animateWithDuration:0.25 animations:^{
            [self p_reLayoutItemsAtIndexPaths:needLayoutArr];
        }];
    }
}

- (void)reloadItemsAtIndexPaths:(NSArray *)indexPaths
{
    [self reload_cachedData];
    [self.collectionViewLayout prepareLayout];
    [self p_reloadItemsAtIndexPaths:indexPaths];
}

- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath
{
    
}

#pragma mark - touches
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (touches.count == 1) {
        UITouch * touch = [touches anyObject];
        UIView * view = touch.view;
        while (view && ![view isKindOfClass:[FlyCollectionReusableView class]] && ![view isKindOfClass:[FlyCollectionView class]]) {
            view = view.superview;
        }
        
        if ([view isKindOfClass:[FlyCollectionReusableView class]]) {
            NSIndexPath * indexPath = [self p_indexPathForCell:(FlyCollectionReusableView *)view];
            if (indexPath) {//是cell
                if ([self delegateResponseSEL:@selector(flyCollectionView:didSelectItemAtIndexPath:)]) {
                    [self.delegate flyCollectionView:self didSelectItemAtIndexPath:indexPath];
                }
            } else {
                BOOL isHeader = NO;
                BOOL isFooter = NO;
                indexPath = [self p_indexPathForSupplementaryView:(FlyCollectionReusableView *)view isHeader:&isHeader isFooter:&isFooter];
                if (indexPath) {
                    
                }
            }
        } else if ([view isKindOfClass:[FlyCollectionView class]]) {//点击在空白处
            
            
        }
    }
}

- (NSString *)stringWithIndexPath:(NSIndexPath *)indexPath
{
    return [NSString stringWithFormat:@"%d - %d",(int)indexPath.section,(int)indexPath.row];
}

@end
