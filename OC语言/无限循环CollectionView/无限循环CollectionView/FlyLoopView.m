//
//  FlyLoopView.m
//  无限循环CollectionView
//
//  Created by mx-QS on 2019/6/12.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "FlyLoopView.h"
#import <objc/runtime.h>

#define FlyLog(format, ...) printf("\n%s  %s\n", [[NSString stringWithFormat:@"%@", [NSDate dateWithTimeIntervalSinceNow:8 * 60 * 60]] UTF8String], [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])
//#define FlyLog(format, ...)


@interface UICollectionViewCell (Fly)

@property (nonatomic, strong) NSIndexPath   *   oldIndexPath;

@end

@implementation UICollectionViewCell (Fly)

@dynamic oldIndexPath;

- (void)setOldIndexPath:(NSIndexPath *)oldIndexPath {
    
    objc_setAssociatedObject(self, "oldIndexPath", oldIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)oldIndexPath {
    
    return objc_getAssociatedObject(self, "oldIndexPath");
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"%@ %@",[super description], self.oldIndexPath];
}

@end


@interface FlyLoopView ()

@property (nonatomic, strong) UIPanGestureRecognizer   *   panGesture;
@property (nonatomic, strong) NSMutableSet             *   cellReuseQueues;     //复用池  NSMutableSet
@property (nonatomic, strong) NSMutableDictionary      *   visibleCellsDict;    //可见的cell indexPath:FlyCollectionReusableView
@property (nonatomic, strong) NSMutableDictionary      *   allAttributesDict;   //
@property (nonatomic, strong) NSMutableArray           *   animatedCells;

@end

@implementation FlyLoopView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(FlyLayout *)layout
{
    self = [super initWithFrame:frame];
    if (self) {
        _itemOffset = 0;
//        [self setClipsToBounds:YES];
        _collectionViewLayout = layout;
        _collectionViewLayout.loopView = self;
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [self addGestureRecognizer:_panGesture];
        
        _cellReuseQueues   = [NSMutableSet set];
        _visibleCellsDict  = [NSMutableDictionary dictionary];
        _allAttributesDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setIsLoop:(BOOL)isLoop {
    
    _isLoop = isLoop;
    _collectionViewLayout.needLoop = isLoop;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    [self reloadData];
}

#pragma mark - reload & 刷新
- (void)reloadData
{
    [self.collectionViewLayout prepareLayout];
    [self reloadVisibleViewsWithAnimated:NO];
}

- (void)reloadVisibleViewsWithAnimated:(BOOL)animated
{
    [self reloadVisibleCellsWithAnimated:animated];
}

- (void)reloadVisibleCellsWithAnimated:(BOOL)animated
{
    NSArray * visibleCells      = _visibleCellsDict.allKeys;
    NSArray * visibleIndexPaths = [self p_indexPathsForVisibleItemsExceptArr:visibleCells];
    if (animated) {
        _animatedCells = [visibleIndexPaths mutableCopy];
    }
    [self p_reloadItemsAtIndexPaths:visibleIndexPaths];
}

#pragma mark - number items
- (NSInteger)numberOfItems {
    
    return [self p_numberOfItemsInSection:0];
}

- (NSInteger)p_numberOfItemsInSection:(NSInteger)section
{
    NSInteger numerOfItems = 0;
    if ([self dataSourceResponseSEL:@selector(flyLoopViewNumberOfItems)]) {
        numerOfItems = [self.dataSource flyLoopViewNumberOfItems];
        numerOfItems = MAX(numerOfItems, 0);
    }
    return numerOfItems;
}

- (NSArray *)p_indexPathsForVisibleItemsExceptArr:(NSArray<NSIndexPath *> *)exceptArr
{
    NSMutableArray * visibleIndexPaths = [[self p_indexPathsForVisibleItems] mutableCopy];
    if ([exceptArr isKindOfClass:[NSArray class]]) {
        [visibleIndexPaths removeObjectsInArray:exceptArr];
        [visibleIndexPaths addObjectsFromArray:exceptArr];
    }
    return [visibleIndexPaths copy];
}

- (NSArray *)p_indexPathsForVisibleItems
{
    NSMutableArray * indexPaths = [NSMutableArray array];
    NSInteger itemsInSection    = [self p_numberOfItemsInSection:0];
    for (NSInteger row = 0; row < itemsInSection; row ++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:row inSection:0];
        UICollectionViewLayoutAttributes * layoutAttributes = [self p_layoutAttributesForItemAtIndexPath:indexPath];
        if ([self isVisibleFrame:layoutAttributes.frame]) {
            [indexPaths addObject:indexPath];
        }
    }
    return [indexPaths copy];
}

- (void)p_reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    if ([indexPaths isKindOfClass:[NSArray class]]) {
        for (NSIndexPath * indexPath in indexPaths) {
            UICollectionViewCell * cellView = [self p_cellForItemAtIndexPath:indexPath];
            if (cellView && cellView.superview != self) {
                [self addSubview:cellView];
            }
        }
    }
}

- (UICollectionViewCell *)p_cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    __block UICollectionViewCell * reusableView = nil;
    if ([self dataSourceResponseSEL:@selector(flyLoopView:cellForItemAtIndexPath:)]) {
        
        BOOL isAnimated = [_animatedCells containsObject:indexPath];
        
        [UIView animateKeyframesWithDuration:1 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews | UIViewKeyframeAnimationOptionBeginFromCurrentState | UIViewKeyframeAnimationOptionCalculationModeLinear | UIViewKeyframeAnimationOptionOverrideInheritedDuration animations:^{
            reusableView = [self.dataSource flyLoopView:self cellForItemAtIndexPath:indexPath];
        } completion:^(BOOL finished) {
            
        }];
    }
    return reusableView;
}

- (__kindof UICollectionViewCell *)dequeueReusableCellWithIndexPath:(NSIndexPath *)indexPath cellClass:(Class)cellClass {
    
    UICollectionViewLayoutAttributes * layoutAttributes = [self p_layoutAttributesInCachesForItemAtIndexPath:indexPath];
    UICollectionViewCell * reusableView = [self p_getCellFromVisibleDict:indexPath];
    if (!reusableView) {
        reusableView = [self p_reusableCellViewWithLayoutAttributes:layoutAttributes class:cellClass];
    }
    [self p_layoutReusableView:reusableView layoutAttributes:layoutAttributes];
    if (reusableView) {
        [self p_insertCellToVisibleDict:reusableView indexPath:indexPath];
    }
    return reusableView;
}

//控制显示的区域，此处放大一些区域
- (BOOL)isVisibleFrame:(CGRect)frame
{
    BOOL    isVisible   = NO;
    CGSize  visableSize = self.bounds.size;
    CGPoint offSet      = CGPointZero;
    CGSize  extenSize   = self.bounds.size;//放大一屏
    CGRect  visibleRect = CGRectZero;
    
    if (self.collectionViewLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        visibleRect = CGRectMake(offSet.x - extenSize.width * 0.5, offSet.y, visableSize.width + extenSize.width, visableSize.height);
    } else if (self.collectionViewLayout.scrollDirection == UICollectionViewScrollDirectionVertical) {
        visibleRect = CGRectMake(offSet.x, offSet.y - extenSize.height * 0.5, visableSize.width, visableSize.height + extenSize.height);
    }
    
    isVisible = CGRectContainsRect(visibleRect, frame);
    if (!isVisible) {
        isVisible = CGRectIntersectsRect(visibleRect, frame);
    }
    return isVisible;
}

#pragma mark - 生成或者从复用池取
- (UICollectionViewCell *)p_reusableCellViewWithLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes class:(Class)class
{
    UICollectionViewCell * reusableView = [self p_getCellFromReuseQueues];
    if (!reusableView) {
        reusableView = [[class alloc] initWithFrame:layoutAttributes.frame];
    }
    return reusableView;
}

- (UICollectionViewCell *)p_getCellFromReuseQueues
{
    UICollectionViewCell * reusableView = nil;
    if ([_cellReuseQueues isKindOfClass:[NSMutableSet class]]) {
        reusableView = [_cellReuseQueues anyObject];
        if (reusableView) {
            [_cellReuseQueues removeObject:reusableView];
            [self p_prepareReuseCell:reusableView];
        }
    } else {
        _cellReuseQueues = [NSMutableSet set];
    }
    return reusableView;
}

- (void)p_prepareReuseCell:(UICollectionViewCell *)reusaView {
    
    if ([reusaView isKindOfClass:[UICollectionViewCell class]]) {
        [reusaView prepareForReuse];
        [reusaView setAlpha:0];
        [reusaView setFrame:CGRectMake(- self.bounds.size.width, - self.bounds.size.height, 0, 0)];
    }
}

- (void)p_layoutReusableView:(UICollectionViewCell *)reusableView layoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    if ([reusableView isKindOfClass:[UICollectionViewCell class]] && [layoutAttributes isKindOfClass:[UICollectionViewLayoutAttributes class]]) {
        
        NSInteger dis = CGRectGetMinX(layoutAttributes.frame) - CGRectGetMaxX(reusableView.frame);
        
        FlyLog(@"\nold : %@\nnew : %@\ndis : %ld\n", reusableView, layoutAttributes, dis);
        reusableView.oldIndexPath = layoutAttributes.indexPath;
        dis = ABS(dis);
//        if (dis >= self.bounds.size.width) {
//            layoutAttributes.hidden = YES;
//        } else {
//            layoutAttributes.hidden = NO;
//        }

        [UIView animateKeyframesWithDuration:2 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews|UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
           
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 animations:^{
                if (!CGRectEqualToRect(reusableView.frame, layoutAttributes.frame)) {
                    [reusableView setFrame:layoutAttributes.frame];
                }
                if (!CGAffineTransformEqualToTransform(layoutAttributes.transform, reusableView.transform)) {
                    reusableView.transform = layoutAttributes.transform;
                }
                if (!CATransform3DEqualToTransform(layoutAttributes.transform3D, reusableView.layer.transform)) {
                    reusableView.layer.transform = layoutAttributes.transform3D;
                }
            }];
            [UIView addKeyframeWithRelativeStartTime:0.1 relativeDuration:0.9 animations:^{
                if (reusableView.layer.zPosition != layoutAttributes.zIndex) {
                    reusableView.layer.zPosition = layoutAttributes.zIndex;
                }
                if (reusableView.alpha != layoutAttributes.alpha) {
                    reusableView.alpha = layoutAttributes.alpha;
                }
                if (reusableView.hidden != layoutAttributes.hidden) {
                    reusableView.hidden = layoutAttributes.hidden;
                }
            }];
        } completion:^(BOOL finished) {
            
        }];
        
//
//        if (reusableView.layer.zPosition != layoutAttributes.zIndex) {
//            reusableView.layer.zPosition = layoutAttributes.zIndex;
//        }
//        if (reusableView.alpha != layoutAttributes.alpha) {
//            reusableView.alpha = layoutAttributes.alpha;
//        }
//        if (!CGRectEqualToRect(reusableView.frame, layoutAttributes.frame)) {
//            [reusableView setFrame:layoutAttributes.frame];
//        }
//        if (!CGAffineTransformEqualToTransform(layoutAttributes.transform, reusableView.transform)) {
//            reusableView.transform = layoutAttributes.transform;
//        }
//        if (!CATransform3DEqualToTransform(layoutAttributes.transform3D, reusableView.layer.transform)) {
//            reusableView.layer.transform = layoutAttributes.transform3D;
//        }
//        if (reusableView.hidden != layoutAttributes.hidden) {
//            reusableView.hidden = layoutAttributes.hidden;
//        }
    }
}

- (UICollectionViewCell *)p_getCellFromVisibleDict:(NSIndexPath *)indexPath
{
    UICollectionViewCell * reusableView = nil;
    if ([indexPath isKindOfClass:[NSIndexPath class]]) {
        reusableView = [_visibleCellsDict objectForKey:indexPath];
    }
    return reusableView;
}

#pragma mark - layoutAttributes

- (UICollectionViewLayoutAttributes *)p_layoutAttributesInCachesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * layoutAttributes = [_allAttributesDict objectForKey:indexPath];
    if (!layoutAttributes) {
        layoutAttributes = [self p_layoutAttributesForItemAtIndexPath:indexPath];
    }
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)p_layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * layoutAttributes = [self.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
    
    if (layoutAttributes && indexPath) {
       [_allAttributesDict setObject:layoutAttributes forKey:indexPath];
    }
    return layoutAttributes;
}

#pragma mark - delegate
- (BOOL)delegateResponseSEL:(SEL)sel
{
    BOOL response = [self.delegate conformsToProtocol:@protocol(FlyLoopViewDelegate)] && [self.delegate respondsToSelector:sel];
    return response;
}

- (BOOL)dataSourceResponseSEL:(SEL)sel
{
    BOOL response = [self.dataSource conformsToProtocol:@protocol(FlyLoopViewDataSource)] && [self.dataSource respondsToSelector:sel];
    return response;
}

- (void)setItemOffset:(NSInteger)item animated:(BOOL)animated {
    
    [self setItemOffset:item];
    [self reloadVisibleViewsWithAnimated:animated];
}

- (void)setItemOffset:(NSInteger)itemOffset {
    
    itemOffset = itemOffset < 0 ? itemOffset + [self numberOfItems] : itemOffset;
    itemOffset = itemOffset % [self numberOfItems];
    if (_itemOffset != itemOffset) {
        _itemOffset = itemOffset;
        if (self.superview) {
            [self p_didScroll];
            [self.collectionViewLayout layoutAttributesForElementsInRect:self.bounds];
        }
    }
}

- (void)p_didScroll
{
    [self p_insertUnVisibleViewToReuseQueuesFromVisibleDicts];
}

- (void)p_insertUnVisibleViewToReuseQueuesFromVisibleDicts
{
    NSMutableDictionary * visibleCellsDict = [_visibleCellsDict mutableCopy];
    for (NSIndexPath * indexPath in visibleCellsDict.allKeys) {
        UICollectionViewCell * itemView = [visibleCellsDict objectForKey:indexPath];
        if (![self isVisibleFrame:itemView.frame]) {
            [self p_insertCellToReuseQueueFromVisibleDict:itemView indexPath:indexPath];
        }
    }
}

- (void)p_insertCellToReuseQueueFromVisibleDict:(UICollectionViewCell *)reusableView indexPath:(NSIndexPath *)indexPath
{
    if ([reusableView isKindOfClass:[UICollectionViewCell class]]) {
        [self p_deleteCellFromVisibleDict:reusableView indexPath:indexPath];
        [self p_insertCellToReuseQueues:reusableView];
    }
}

#pragma mark 2、cell从复用池进入可见区域
- (void)p_insertCellToVisibleDictFromReuseQueue:(UICollectionViewCell *)reusableView indexPath:(NSIndexPath *)indexPath
{
    if ([reusableView isKindOfClass:[UICollectionViewCell class]] && [indexPath isKindOfClass:[NSIndexPath class]] && [self isVisibleFrame:reusableView.frame]) {
        [self p_deleteCellFromReuseQueues:reusableView];
        [self p_insertCellToVisibleDict:reusableView indexPath:indexPath];
    }
}

#pragma mark ①、CellReuseQueues
- (void)p_insertCellToReuseQueues:(UICollectionViewCell *)reusableView
{
    if ([reusableView isKindOfClass:[UICollectionViewCell class]]) {
        [reusableView removeFromSuperview];
        [_cellReuseQueues addObject:reusableView];
    }
}

- (void)p_deleteCellFromReuseQueues:(UICollectionViewCell *)reusableView
{
    if ([reusableView isKindOfClass:[UICollectionViewCell class]]) {
        [_cellReuseQueues removeObject:reusableView];
    }
}

#pragma mark ②、VisibleCell
- (void)p_insertCellToVisibleDict:(UICollectionViewCell *)reusableView indexPath:(NSIndexPath *)indexPath
{
    if ([reusableView isKindOfClass:[UICollectionViewCell class]] && [indexPath isKindOfClass:[NSIndexPath class]]) {
        [_visibleCellsDict setObject:reusableView forKey:indexPath];
    }
}

- (void)p_deleteCellFromVisibleDict:(UICollectionViewCell *)reusableView indexPath:(NSIndexPath *)indexPath
{
    if ([reusableView isKindOfClass:[UICollectionViewCell class]]) {
        NSIndexPath * deleteIndexPath = nil;
        if ([indexPath isKindOfClass:[NSIndexPath class]]) {
            UICollectionViewCell * currentCell = [_visibleCellsDict objectForKey:indexPath];
            if (currentCell == reusableView) {
                deleteIndexPath = indexPath;
            }
        }
        if (!deleteIndexPath) {
            for (NSIndexPath * subIndexPath in _visibleCellsDict.allKeys) {
                UICollectionViewCell * currentCell = [_visibleCellsDict objectForKey:subIndexPath];
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

#pragma mark - 手势
- (void)panGestureAction:(UIPanGestureRecognizer *)panGesture {
    
    CGPoint velocity      = [panGesture velocityInView:panGesture.view];
    CGPoint transPoint    = [panGesture translationInView:panGesture.view];
    CGPoint locationPoint = [panGesture locationInView:panGesture.view];
    
    CGFloat velocityX = velocity.x;
    CGFloat velocityY = velocity.y;
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            [panGesture setTranslation:transPoint inView:panGesture.view];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {

        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            if (velocityX < 0) {
                [self setItemOffset:self.itemOffset + 1 animated:YES];
            } else {
                [self setItemOffset:self.itemOffset - 1 animated:YES];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (velocityX < 0) {
                [self setItemOffset:self.itemOffset + 1 animated:YES];
            } else {
                [self setItemOffset:self.itemOffset - 1 animated:YES];
            }
        }
            break;
        default:
        {
            
        }
            break;
    }
    
}

- (void)dealloc {
    
    NSLog(@"---->>> %@ dealloc<<<----", [self class]);
}

@end
