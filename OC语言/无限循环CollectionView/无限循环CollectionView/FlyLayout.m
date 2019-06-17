//
//  FlyLayout.m
//  无限循环CollectionView
//
//  Created by mx-QS on 2019/6/10.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "FlyLayout.h"
#import "FlyLoopView.h"

#define FlyLog(format, ...) printf("\n%s  %s\n", [[NSString stringWithFormat:@"%@", [NSDate dateWithTimeIntervalSinceNow:8 * 60 * 60]] UTF8String], [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])
//#define FlyLog(format, ...)

@interface FlyLayout ()

@property (nonatomic, assign) CGSize        loopViewSize;
@property (nonatomic, strong) NSMutableArray   *   layoutAttributesArr;
@property (nonatomic, strong) NSMutableArray   *   visibleAttributesArr;

@property (nonatomic, strong) NSMutableDictionary  * cachedItemAttributes;
@property (nonatomic, strong) NSMutableArray       * indexPathsToValidate;
@property (nonatomic, strong) NSMutableDictionary  * cachedItemSize;

@property (nonatomic, strong) NSMutableDictionary  * cachedMinItemSpacing;

@property (nonatomic, assign, readwrite) BOOL        shouldChanged; //size 等参数是否会变
@property (nonatomic, assign) BOOL       isFull; //是否铺满

@end

@implementation FlyLayout


- (instancetype)init
{
    self = [super init];
    if (self) {
        _scrollDirection = UICollectionViewScrollDirectionVertical;
        _isFull = NO;
    }
    return self;
}

- (void)prepareLayout
{
    _shouldChanged = [self delegateResponseSEL:@selector(loopViewLayout:initializeAttributes:indexPath:)];
    if (!_shouldChanged) {
        _cachedItemSize       = [NSMutableDictionary dictionary];
        _cachedMinItemSpacing = [NSMutableDictionary dictionary];
    }
    _cachedItemAttributes = [NSMutableDictionary dictionary];
    _indexPathsToValidate = [NSMutableArray array];
    
    _loopViewSize = self.loopView.bounds.size;
    [self cachedAllItemsAttributes];
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    if (_scrollDirection != scrollDirection) {
        _scrollDirection = scrollDirection;
        [self.loopView reloadData];
    }
}

- (id)delegate
{
    return self.loopView.delegate;
}

- (void)cachedAllItemsAttributes
{
    [self p_layoutAttributesForElementsInRect:self.loopView.bounds];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self p_layoutAttributesForElementsInRect:rect];
}

- (NSArray *)p_layoutAttributesForElementsInRect:(CGRect)rect
{
    _isFull = NO;
    [_layoutAttributesArr  removeAllObjects];
    [_cachedItemAttributes removeAllObjects];
    NSMutableArray * visibleAttributesArr = [NSMutableArray array];
    NSMutableArray * allAttributesArray   = _layoutAttributesArr;
    NSInteger    numberOfCellsInSection   = [self.loopView numberOfItems];
    
    if (_needLoop && numberOfCellsInSection > 0) {
        //需要轮巡
        NSInteger stopItem = -1;
        for (NSInteger item = self.loopView.itemOffset; item < numberOfCellsInSection * 2; item++) {
            @autoreleasepool {
                NSInteger currentItem = item % numberOfCellsInSection;
                NSIndexPath * itemIndexPath = [NSIndexPath indexPathForItem:currentItem inSection:0];
                UICollectionViewLayoutAttributes * itemAttributes = [self cachedLayoutAttributesForItemAtIndexPath:itemIndexPath isInvertedOrder:NO];
                [allAttributesArray addObject:itemAttributes];
                if (CGRectIntersectsRect(rect, itemAttributes.frame)) {//两个矩形相交才加入
                    [visibleAttributesArr addObject:itemAttributes];
                } else if (_needLoop) {
                    stopItem = item;
                    break;
                }
            }
        }
        
        NSInteger lastCount = numberOfCellsInSection - (stopItem - self.loopView.itemOffset);
        //前段区间计算
        NSInteger preStart = self.loopView.itemOffset - (lastCount - lastCount/2);
        NSInteger preEnd   = self.loopView.itemOffset;
        //后段区间计算
        NSInteger sufStart = stopItem;
        NSInteger sufEnd   = stopItem + lastCount/2;
        
//        FlyLog(@"\n-----计算------>>>>>\nitemOffset:%ld stop:%ld total:%ld\n前段：[%ld,%ld)\n后段：(%ld,%ld]\n---------",self.loopView.itemOffset,stopItem,numberOfCellsInSection,preStart,preEnd,sufStart,sufEnd);
        //前段，采用倒序计算 eg: [10, 20)
        for (NSInteger item = preEnd - 1; item > preStart; item--) {
            @autoreleasepool {
                NSInteger currentItem       = (item + numberOfCellsInSection) % numberOfCellsInSection;
                NSIndexPath * itemIndexPath = [NSIndexPath indexPathForItem:currentItem inSection:0];
                UICollectionViewLayoutAttributes * itemAttributes = [self cachedLayoutAttributesForItemAtIndexPath:itemIndexPath isInvertedOrder:YES];
                [allAttributesArray addObject:itemAttributes];
                if (CGRectIntersectsRect(rect, itemAttributes.frame)) {//两个矩形相交才加入
                    [visibleAttributesArr addObject:itemAttributes];
                }
            }
        }
        //后段，采用正序计算 eg: (10, 20]
        for (NSInteger item = sufStart + 1; item <= sufEnd; item++) {
            @autoreleasepool {
                NSInteger currentItem       = (item + numberOfCellsInSection) % numberOfCellsInSection;
                NSIndexPath * itemIndexPath = [NSIndexPath indexPathForItem:currentItem inSection:0];
                UICollectionViewLayoutAttributes * itemAttributes = [self cachedLayoutAttributesForItemAtIndexPath:itemIndexPath isInvertedOrder:NO];
                [allAttributesArray addObject:itemAttributes];
                if (CGRectIntersectsRect(rect, itemAttributes.frame)) {//两个矩形相交才加入
                    [visibleAttributesArr addObject:itemAttributes];
                }
            }
        }
    } else {
        //不需要轮巡
        for (NSInteger item = self.loopView.itemOffset; item < numberOfCellsInSection; item++) {
            NSIndexPath * itemIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
            UICollectionViewLayoutAttributes * itemAttributes = [self cachedLayoutAttributesForItemAtIndexPath:itemIndexPath isInvertedOrder:NO];
            [allAttributesArray addObject:itemAttributes];
            if (CGRectIntersectsRect(rect, itemAttributes.frame)) {//两个矩形相交才加入
                [visibleAttributesArr addObject:itemAttributes];
            }
        }
        
        for (NSInteger item = self.loopView.itemOffset - 1; item >= 0; item--) {
            NSIndexPath * itemIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
            UICollectionViewLayoutAttributes * itemAttributes = [self cachedLayoutAttributesForItemAtIndexPath:itemIndexPath isInvertedOrder:YES];
            [allAttributesArray addObject:itemAttributes];
            if (CGRectIntersectsRect(rect, itemAttributes.frame)) {//两个矩形相交才加入
                [visibleAttributesArr insertObject:itemAttributes atIndex:0];
            }
        }
    }
    _visibleAttributesArr = [visibleAttributesArr copy];
    FlyLog(@"%@",_cachedItemAttributes);
    return visibleAttributesArr;
}

#pragma mark - calculate positive inverted order
- (UICollectionViewLayoutAttributes *)calculateLayoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath isInvertedOrder:(BOOL)isInvertedOrder
{
    UICollectionViewLayoutAttributes *cellAttribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGRect itemFrame    = CGRectZero;
    CGSize itemSize     = [self cachedSizeForItemAtIndexPath:indexPath];
    itemFrame.size      = itemSize;
    cellAttribute.frame = itemFrame;
    
    if (_scrollDirection == UICollectionViewScrollDirectionVertical) {//竖向滑动
        [self calculateCellLayoutAttributesWhenDirectionVertical:cellAttribute indexPath:indexPath startItem:self.loopView.itemOffset isInvertedOrder:isInvertedOrder];
    } else if (_scrollDirection == UICollectionViewScrollDirectionHorizontal) {//横向滑动
        [self calculateCellLayoutAttributesWhenDirectionHorizontal:cellAttribute indexPath:indexPath startItem:self.loopView.itemOffset isInvertedOrder:isInvertedOrder];
    }
    [_cachedItemAttributes setObject:cellAttribute forKey:indexPath];
    [_indexPathsToValidate addObject:indexPath];
    return cellAttribute;
}

#pragma mark 竖向滑动 cell attributes
- (void)calculateCellLayoutAttributesWhenDirectionVertical:(UICollectionViewLayoutAttributes *)layoutAttributes indexPath:(NSIndexPath *)indexPath startItem:(NSInteger)startItem isInvertedOrder:(BOOL)isInvertedOrder
{
    CGRect  currentRect  = layoutAttributes.frame;
    CGFloat attributes_x = 0;
    CGFloat attributes_y = 0;
    
    if (indexPath.item > startItem) {
        
        NSIndexPath * lastIndexPath = [NSIndexPath indexPathForItem:indexPath.row - 1 inSection:indexPath.section];
        UICollectionViewLayoutAttributes * lastLayoutAttributes = [_cachedItemAttributes objectForKey:lastIndexPath];
        CGRect lastRect     = lastLayoutAttributes.frame;
        CGFloat itemSpacing = [self cachedInteritemSpacingForSectionAtIndex:indexPath.section];
        attributes_x += CGRectGetMinX(lastRect);
        attributes_y += CGRectGetMaxY(lastRect) + itemSpacing;
        
    } else if (indexPath.item < startItem) {
        
        NSIndexPath * lastIndexPath = [NSIndexPath indexPathForItem:self.loopView.numberOfItems - 1 inSection:indexPath.section];
        UICollectionViewLayoutAttributes * lastLayoutAttributes = [_cachedItemAttributes objectForKey:lastIndexPath];
        CGRect lastRect = lastLayoutAttributes.frame;
        
        NSIndexPath * nextIndexPath = [NSIndexPath indexPathForItem:indexPath.row + 1 inSection:indexPath.section];
        UICollectionViewLayoutAttributes * nextLayoutAttributes = [_cachedItemAttributes objectForKey:nextIndexPath];
        CGRect nextRect     = nextLayoutAttributes.frame;
        
        CGFloat itemSpacing = [self cachedInteritemSpacingForSectionAtIndex:indexPath.section];
        
        if (!_isFull && _needLoop) {
            attributes_y += CGRectGetMaxY(lastRect) - itemSpacing;
        } else {
            attributes_y += CGRectGetMinY(nextRect) - itemSpacing - currentRect.size.height;
        }
        attributes_x += CGRectGetMinX(nextRect);
    }
    
    currentRect.origin.x   = attributes_x;
    currentRect.origin.y   = attributes_y;
    layoutAttributes.frame = currentRect;
    
    if ([self delegateResponseSEL:@selector(loopViewLayout:initializeAttributes:indexPath:)]) {
        [self.delegate loopViewLayout:self initializeAttributes:layoutAttributes indexPath:indexPath];
    }
}

#pragma mark 横向滑动 cell attributes
- (void)calculateCellLayoutAttributesWhenDirectionHorizontal:(UICollectionViewLayoutAttributes *)layoutAttributes indexPath:(NSIndexPath *)indexPath startItem:(NSInteger)startItem isInvertedOrder:(BOOL)isInvertedOrder
{
    CGRect  currentRect  = layoutAttributes.frame;
    CGFloat attributes_x = 0;
    CGFloat attributes_y = _loopViewSize.height * 0.5 - currentRect.size.height * 0.5;
    NSInteger totalCount = [self.loopView numberOfItems];
    
    if (totalCount > 0) {
        if (!isInvertedOrder) {//正序，取上一个值
            NSInteger currentRow = (indexPath.row - 1 + totalCount) % totalCount;
            NSIndexPath * lastIndexPath = [NSIndexPath indexPathForItem:currentRow inSection:indexPath.section];
            UICollectionViewLayoutAttributes * lastLayoutAttributes = [_cachedItemAttributes objectForKey:lastIndexPath];
            if (lastLayoutAttributes) {
                CGRect lastRect     = lastLayoutAttributes.frame;
                CGFloat itemSpacing = [self cachedInteritemSpacingForSectionAtIndex:indexPath.section];
                attributes_x = CGRectGetMaxX(lastRect) + itemSpacing;
                attributes_y = CGRectGetMinY(lastRect);
            }
        } else {//倒序，取下一个
            NSInteger currentRow = (indexPath.row + 1 + totalCount) % totalCount;
            NSIndexPath * nextPath = [NSIndexPath indexPathForItem:currentRow inSection:indexPath.section];
            UICollectionViewLayoutAttributes * nextLayoutAttributes = [_cachedItemAttributes objectForKey:nextPath];
            if (nextLayoutAttributes) {
                CGRect  nextRect    = nextLayoutAttributes.frame;
                CGFloat itemSpacing = [self cachedInteritemSpacingForSectionAtIndex:indexPath.section];
                attributes_x = CGRectGetMinX(nextRect) - itemSpacing - currentRect.size.width;
                attributes_y = CGRectGetMinY(nextRect);
            }
        }
    }
    
    currentRect.origin.x   = attributes_x;
    currentRect.origin.y   = attributes_y;
    layoutAttributes.frame = currentRect;
    
//    if (CGRectGetMaxX(currentRect) < 0 || CGRectGetMinX(currentRect) > _loopViewSize.width) {
//        layoutAttributes.alpha  = 0;
//        layoutAttributes.hidden = YES;
//    } else {
//        layoutAttributes.alpha  = 1;
//        layoutAttributes.hidden = NO;
//    }
    
    if ([self delegateResponseSEL:@selector(loopViewLayout:initializeAttributes:indexPath:)]) {
        [self.delegate loopViewLayout:self initializeAttributes:layoutAttributes indexPath:indexPath];
    }
}

#pragma mark - cached
#pragma mark size
- (UICollectionViewLayoutAttributes *)cachedLayoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath isInvertedOrder:(BOOL)isInvertedOrder
{
    UICollectionViewLayoutAttributes * layoutAttributes = [_cachedItemAttributes objectForKey:indexPath];
    if (!layoutAttributes) {
        layoutAttributes = [self calculateLayoutAttributesForItemAtIndexPath:indexPath isInvertedOrder:isInvertedOrder];
    }
    return layoutAttributes;
}

#pragma mark size
- (CGSize)cachedSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSValue * itemSizeValue = [_cachedItemSize objectForKey:indexPath];
    CGSize itemSize = [itemSizeValue CGSizeValue];
    if (!itemSizeValue && indexPath) {
        itemSize = [self sizeForItemAtIndexPath:indexPath];
        [_cachedItemSize setObject:[NSValue valueWithCGSize:itemSize] forKey:indexPath];
    }
    return itemSize;
}

#pragma mark spacing
- (CGFloat)cachedInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    NSNumber * interitemSpacingValue = [_cachedMinItemSpacing objectForKey:@(section)];
    CGFloat interitemSpacing = [interitemSpacingValue floatValue];
    if (!interitemSpacingValue) {
        interitemSpacing = [self interitemSpacingForSectionAtIndex:section];
        [_cachedMinItemSpacing setObject:@(interitemSpacing) forKey:@(section)];
    }
    return interitemSpacing;
}

#pragma mark - delegate
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize = _itemSize;
    if ([self delegateResponseSEL:@selector(loopView:layout:sizeForItemAtIndexPath:)]) {
        itemSize = [self.delegate loopView:self.loopView layout:self sizeForItemAtIndexPath:indexPath];
    }
    return itemSize;
}

- (CGFloat)interitemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat interitemSpacing = _interitemSpacing;
    if ([self delegateResponseSEL:@selector(loopView:layout:interitemSpacingForSectionAtIndex:)]) {
        interitemSpacing = [self.delegate loopView:self.loopView layout:self interitemSpacingForSectionAtIndex:section];
    }
    return interitemSpacing;
}

#pragma mark - delegate
- (BOOL)delegateResponseSEL:(SEL)sel
{
    BOOL response = [self.delegate conformsToProtocol:@protocol(FlyLayoutDelegate)] && [self.delegate respondsToSelector:sel];
    return response;
}

#pragma mark - public
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * itemAttributes = [self cachedLayoutAttributesForItemAtIndexPath:indexPath isInvertedOrder:NO];
    return itemAttributes;
}

- (void)dealloc {
    
    NSLog(@"---->>> %@ dealloc<<<----", [self class]);
}

@end
