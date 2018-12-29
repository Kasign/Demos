//
//  FlyCollectionViewLayout.m
//  DiyCollectionView
//
//  Created by Fly. on 2018/11/29.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "FlyCollectionViewLayout.h"
#import "FlyCollectionView.h"

@interface FlyCollectionViewLayout()

@property (nonatomic, assign) NSInteger          numberSections;
@property (nonatomic, assign) NSInteger          numberOfItems;
@property (nonatomic, assign) CGSize             collectionViewSize;
@property (nonatomic, assign) UIEdgeInsets       collectionInsets;
@property (nonatomic, strong) NSArray   *   layoutAttributesArr;
@property (nonatomic, strong) NSArray   *   visibleAttributesArr;

@property (nonatomic, strong) NSMutableDictionary  * cachedItemAttributes;
@property (nonatomic, strong) NSMutableDictionary  * cachedHeaderAttributes;
@property (nonatomic, strong) NSMutableDictionary  * cachedFooterAttributes;

@property (nonatomic, strong) NSMutableArray  * indexPathsToValidate;

@property (nonatomic, strong) NSMutableDictionary  * cachedItemSize;
@property (nonatomic, strong) NSMutableDictionary  * cachedHeaderSize;
@property (nonatomic, strong) NSMutableDictionary  * cachedFooterSize;
@property (nonatomic, strong) NSMutableDictionary  * cachedSectionInset;
@property (nonatomic, strong) NSMutableDictionary  * cachedMinItemSpacing;
@property (nonatomic, strong) NSMutableDictionary  * cachedMinLineSpacing;


//"_insertedItemsAttributesDict",
//"_insertedSectionHeadersAttributesDict",
//"_insertedSectionFootersAttributesDict",
//"_deletedItemsAttributesDict",
//"_deletedSectionHeadersAttributesDict",
//"_deletedSectionFootersAttributesDict",

@end


@implementation FlyCollectionViewLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        _scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}

- (void)prepareLayout
{
    _cachedItemAttributes   = [NSMutableDictionary dictionary];
    _cachedHeaderAttributes = [NSMutableDictionary dictionary];
    _cachedFooterAttributes = [NSMutableDictionary dictionary];
    
    _cachedItemSize   = [NSMutableDictionary dictionary];
    _cachedHeaderSize = [NSMutableDictionary dictionary];
    _cachedFooterSize = [NSMutableDictionary dictionary];
    _cachedSectionInset   = [NSMutableDictionary dictionary];
    _cachedMinItemSpacing = [NSMutableDictionary dictionary];
    _cachedMinLineSpacing = [NSMutableDictionary dictionary];
    
    _indexPathsToValidate = [NSMutableArray array];
    _collectionViewSize   = self.collectionView.bounds.size;
    _collectionInsets     = self.collectionView.contentInset;
    _collectionViewSize.width  = _collectionViewSize.width - _collectionInsets.left - _collectionInsets.right;
    _collectionViewSize.height = _collectionViewSize.height - _collectionInsets.top - _collectionInsets.bottom;
    [self cachedAllItemsAttributes];
    [self.collectionView setContentSize:[self collectionViewContentSize]];
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    if (_scrollDirection != scrollDirection) {
        _scrollDirection = scrollDirection;
        [self.collectionView setContentOffset:CGPointZero];
        [self.collectionView reloadData];
    }
}

- (id)delegate
{
    return self.collectionView.delegate;
}

- (CGSize)collectionViewContentSize
{
    CGSize contentSize = CGSizeZero;
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        contentSize = CGSizeMake(_collectionViewSize.width, 0);
        NSInteger lastSection = _collectionView.numberOfSections - 1;
        if (lastSection <= 0) {
            lastSection = 0;
        }
        UICollectionViewLayoutAttributes * lastFooterAttributes = [self cachedLayoutAttributesForFooterInSection:lastSection];
        if ([lastFooterAttributes isKindOfClass:[UICollectionViewLayoutAttributes class]]) {
            contentSize.height = CGRectGetMaxY(lastFooterAttributes.frame);
        } else {
            CGRect lastRect    = [self support_rectForSection:lastSection currentRow:-1];
            contentSize.height = CGRectGetMaxY(lastRect);
        }
    } else if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        contentSize = CGSizeMake(0, _collectionViewSize.height);
        NSInteger lastSection = _collectionView.numberOfSections - 1;
        if (lastSection <= 0) {
            lastSection = 0;
        }
        UICollectionViewLayoutAttributes * lastFooterAttributes = [self cachedLayoutAttributesForFooterInSection:lastSection];
        if ([lastFooterAttributes isKindOfClass:[UICollectionViewLayoutAttributes class]]) {
            contentSize.width = CGRectGetMaxX(lastFooterAttributes.frame);
        } else {
            CGRect lastRect   = [self support_rectForSection:lastSection currentRow:-1];
            contentSize.width = CGRectGetMaxX(lastRect);
        }
    }
    
    return contentSize;
}

- (void)cachedAllItemsAttributes
{
    NSMutableArray * allAttributesArray = [NSMutableArray array];
    NSInteger totalSections = self.collectionView.numberOfSections;
    for (NSInteger section = 0; section < totalSections; section++) {
        NSIndexPath * supplementIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        NSInteger numberOfCellsInSection = [self.collectionView numberOfItemsInSection:section];
        UICollectionViewLayoutAttributes * headerAttributes = [self cachedLayoutAttributesForHeaderInSection:supplementIndexPath.section];
        [allAttributesArray addObject:headerAttributes];
        for (NSInteger item = 0; item < numberOfCellsInSection; item++) {
            NSIndexPath * itemIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes * itemAttributes = [self cachedLayoutAttributesForItemAtIndexPath:itemIndexPath];
            [allAttributesArray addObject:itemAttributes];
        }
        UICollectionViewLayoutAttributes * footerAttributes = [self cachedLayoutAttributesForFooterInSection:supplementIndexPath.section];
        [allAttributesArray addObject:footerAttributes];
    }
    _layoutAttributesArr = [allAttributesArray copy];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray * visibleAttributesArr = [NSMutableArray array];
    NSMutableArray * allAttributesArray = [NSMutableArray array];
    for (NSInteger section = 0; section < self.collectionView.numberOfSections; section++) {
        NSIndexPath * supplementIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        NSInteger numberOfCellsInSection = [self.collectionView numberOfItemsInSection:section];
        UICollectionViewLayoutAttributes * headerAttributes = [self cachedLayoutAttributesForHeaderInSection:supplementIndexPath.section];
        UICollectionViewLayoutAttributes * footerAttributes = [self cachedLayoutAttributesForFooterInSection:supplementIndexPath.section];
        if (CGRectIntersectsRect(rect, headerAttributes.frame)) {//两个矩形相交才加入
            [visibleAttributesArr addObject:headerAttributes];
        }
        if (CGRectIntersectsRect(rect, footerAttributes.frame)) {//两个矩形相交才加入
            [visibleAttributesArr addObject:footerAttributes];
        }
        [allAttributesArray addObject:headerAttributes];
        [allAttributesArray addObject:footerAttributes];
        for (NSInteger item = 0; item < numberOfCellsInSection; item++) {
            NSIndexPath * itemIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes * itemAttributes = [self cachedLayoutAttributesForItemAtIndexPath:itemIndexPath];
            [allAttributesArray addObject:itemAttributes];
            if (CGRectIntersectsRect(rect, itemAttributes.frame)) {//两个矩形相交才加入
                [visibleAttributesArr addObject:itemAttributes];
            }
        }
    }
    _visibleAttributesArr = [visibleAttributesArr copy];
    return  visibleAttributesArr;
}

#pragma mark - calculate
- (UICollectionViewLayoutAttributes *)calculateLayoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *cellAttribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGRect itemFrame = CGRectZero;
    CGSize itemSize  = [self cachedSizeForItemAtIndexPath:indexPath];
    itemFrame.size   = itemSize;
    cellAttribute.frame  = itemFrame;
    
    if (_scrollDirection == UICollectionViewScrollDirectionVertical) {//竖向滑动
        [self calculateCellLayoutAttributesWhenDirectionVertical:cellAttribute indexPath:indexPath];
    } else if (_scrollDirection == UICollectionViewScrollDirectionHorizontal) {//横向滑动
        [self calculateCellLayoutAttributesWhenDirectionHorizontal:cellAttribute indexPath:indexPath];
    }
    [_cachedItemAttributes setObject:cellAttribute forKey:indexPath];
    [_indexPathsToValidate addObject:indexPath];
    return cellAttribute;
}

- (UICollectionViewLayoutAttributes *)calculateLayoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes * supplementAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    
    CGRect supplemenFrame = CGRectZero;
    CGSize supplemenSize  = [self referenceSizeForKind:elementKind inSection:indexPath.section];
    supplemenFrame.size = supplemenSize;
    supplementAttributes.frame  = supplemenFrame;
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [self calculateHeaderLayoutAttributesWhenDirectionVertical:supplementAttributes indexPath:indexPath];
        } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
            [self calculateFooterLayoutAttributesWhenDirectionVertical:supplementAttributes indexPath:indexPath];
        }
    } else if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [self calculateHeaderLayoutAttributesWhenDirectionHorizontal:supplementAttributes indexPath:indexPath];
        } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
            [self calculateFooterLayoutAttributesWhenDirectionHorizontal:supplementAttributes indexPath:indexPath];
        }
    }
    
//    FlyLog(@"calculateLayoutAttributesForSupplementaryViewOfKind :%@ %@ %@",indexPath,elementKind,[NSValue valueWithCGRect:supplementAttributes.frame]);
    return supplementAttributes;
}

#pragma mark 竖向滑动 cell attributes
- (void)calculateCellLayoutAttributesWhenDirectionVertical:(UICollectionViewLayoutAttributes *)layoutAttributes indexPath:(NSIndexPath *)indexPath
{
    CGRect  currentRect  = layoutAttributes.frame;
    CGFloat attributes_x = 0;
    CGFloat attributes_y = 0;
    
    CGFloat lineSpacing = [self cachedMinimumLineSpacingForSectionAtIndex:indexPath.section];
    CGFloat itemSpacing = [self cachedMinimumInteritemSpacingForSectionAtIndex:indexPath.section];
    UIEdgeInsets sectionInsets = [self cachedInsetForSectionAtIndex:indexPath.section];
    
    if (indexPath.row == 0) {
       UICollectionViewLayoutAttributes * headerLayoutAttributes = [_cachedHeaderAttributes objectForKey:indexPath];
        attributes_x = sectionInsets.left;
        attributes_y = CGRectGetMaxY(headerLayoutAttributes.frame) + sectionInsets.top;
    } else {
        
        CGRect lastRect = CGRectZero;
        CGRect upRect = [self support_rectForSection:indexPath.section currentRow:indexPath.row];
        NSIndexPath * lastIndexPath = [NSIndexPath indexPathForItem:indexPath.row - 1 inSection:indexPath.section];
        UICollectionViewLayoutAttributes * lastLayoutAttributes = [_cachedItemAttributes objectForKey:lastIndexPath];
        lastRect = lastLayoutAttributes.frame;
        
        attributes_x = CGRectGetMaxX(lastRect) + itemSpacing;
        attributes_y = CGRectGetMinY(lastRect);
        if (attributes_x + CGRectGetMaxX(currentRect) + sectionInsets.right > _collectionViewSize.width) {//需要折行
            attributes_x = sectionInsets.left;
            attributes_y = CGRectGetMaxY(upRect) + lineSpacing;
        }
    }
    
    currentRect.origin.x = attributes_x;
    currentRect.origin.y = attributes_y;
    layoutAttributes.frame = currentRect;
//    FlyLog(@"当前：%ld - %ld frame :%@",indexPath.section, indexPath.row, [NSValue valueWithCGRect:currentRect]);
}

#pragma mark 横向滑动 cell attributes
- (void)calculateCellLayoutAttributesWhenDirectionHorizontal:(UICollectionViewLayoutAttributes *)layoutAttributes indexPath:(NSIndexPath *)indexPath
{
    CGRect  currentRect  = layoutAttributes.frame;
    CGFloat attributes_x = 0;
    CGFloat attributes_y = 0;
    
    CGFloat lineSpacing = [self cachedMinimumLineSpacingForSectionAtIndex:indexPath.section];
    CGFloat itemSpacing = [self cachedMinimumInteritemSpacingForSectionAtIndex:indexPath.section];
    UIEdgeInsets sectionInsets = [self cachedInsetForSectionAtIndex:indexPath.section];
    
    if (indexPath.row == 0) {
        UICollectionViewLayoutAttributes * headerLayoutAttributes = [_cachedHeaderAttributes objectForKey:indexPath];
        attributes_x = CGRectGetMaxX(headerLayoutAttributes.frame) + sectionInsets.left;
        attributes_y = sectionInsets.top;
    } else {
        CGRect lastRect = CGRectZero;
        CGRect upRect = [self support_rectForSection:indexPath.section currentRow:indexPath.row];
        NSIndexPath * lastIndexPath = [NSIndexPath indexPathForItem:indexPath.row - 1 inSection:indexPath.section];
        UICollectionViewLayoutAttributes * lastLayoutAttributes = [_cachedItemAttributes objectForKey:lastIndexPath];
        lastRect = lastLayoutAttributes.frame;
        attributes_x = CGRectGetMinX(lastRect);
        attributes_y = CGRectGetMaxY(lastRect) + itemSpacing;;
        if (attributes_y + CGRectGetMaxY(currentRect) + sectionInsets.bottom > _collectionViewSize.height) {//需要折行
            attributes_x = CGRectGetMaxX(upRect) + lineSpacing;
            attributes_y = sectionInsets.top;
        }
    }
    
    currentRect.origin.x = attributes_x;
    currentRect.origin.y = attributes_y;
    layoutAttributes.frame = currentRect;
}


#pragma mark 竖向滑动 header attributes
- (void)calculateHeaderLayoutAttributesWhenDirectionVertical:(UICollectionViewLayoutAttributes *)layoutAttributes indexPath:(NSIndexPath *)indexPath
{
    CGRect currentRect   = layoutAttributes.frame;
    CGFloat attributes_x = 0;
    CGFloat attributes_y = 0;
    CGRect lastRect   = CGRectZero;
    
    NSIndexPath * lastInexPath = nil;
    if (indexPath.section > 0) {
        lastInexPath = [NSIndexPath indexPathForItem:0 inSection:indexPath.section - 1];
        UICollectionViewLayoutAttributes * lastLayoutAttributes = [_cachedFooterAttributes objectForKey:lastInexPath];
        lastRect = lastLayoutAttributes.frame;
    }
    
    attributes_y = CGRectGetMaxY(lastRect);
    
    currentRect.origin.x = attributes_x;
    currentRect.origin.y = attributes_y;
    layoutAttributes.frame = currentRect;
}

#pragma mark 横向滑动 header attributes
- (void)calculateHeaderLayoutAttributesWhenDirectionHorizontal:(UICollectionViewLayoutAttributes *)layoutAttributes indexPath:(NSIndexPath *)indexPath
{
    CGRect currentRect   = layoutAttributes.frame;
    CGFloat attributes_x = 0;
    CGFloat attributes_y = 0;
    CGRect lastRect   = CGRectZero;
    
    NSIndexPath * lastInexPath = nil;
    if (indexPath.section > 0) {
        lastInexPath = [NSIndexPath indexPathForItem:0 inSection:indexPath.section - 1];
        UICollectionViewLayoutAttributes * lastLayoutAttributes = [_cachedFooterAttributes objectForKey:lastInexPath];
        lastRect = lastLayoutAttributes.frame;
    }
    
    attributes_x = CGRectGetMaxX(lastRect);
    
    currentRect.origin.x = attributes_x;
    currentRect.origin.y = attributes_y;
    layoutAttributes.frame = currentRect;
}

#pragma mark 竖向滑动 footer attributes
- (void)calculateFooterLayoutAttributesWhenDirectionVertical:(UICollectionViewLayoutAttributes *)layoutAttributes indexPath:(NSIndexPath *)indexPath
{
    CGRect currentRect = layoutAttributes.frame;
    CGFloat attributes_x = 0;
    CGFloat attributes_y = 0;
    NSInteger rowCount = [self.collectionView numberOfItemsInSection:indexPath.section];
    UIEdgeInsets sectionInsets = [self cachedInsetForSectionAtIndex:indexPath.section];
    
    if (rowCount > 0) {
        CGRect sectionRect = [self support_rectForSection:indexPath.section currentRow:rowCount];
        attributes_y = CGRectGetMaxY(sectionRect) + sectionInsets.top;
    } else { //item数为0
        UICollectionViewLayoutAttributes * lastLayoutAttributes = [_cachedHeaderAttributes objectForKey:indexPath];
        attributes_y = CGRectGetMaxY(lastLayoutAttributes.frame) + sectionInsets.bottom + sectionInsets.top;
    }
    
    currentRect.origin.x = attributes_x;
    currentRect.origin.y = attributes_y;
    layoutAttributes.frame = currentRect;
}

#pragma mark 横向滑动 footer attributes
- (void)calculateFooterLayoutAttributesWhenDirectionHorizontal:(UICollectionViewLayoutAttributes *)layoutAttributes indexPath:(NSIndexPath *)indexPath
{
    CGRect currentRect = layoutAttributes.frame;
    CGFloat attributes_x = 0;
    CGFloat attributes_y = 0;
    NSInteger rowCount = [self.collectionView numberOfItemsInSection:indexPath.section];
    UIEdgeInsets sectionInsets = [self cachedInsetForSectionAtIndex:indexPath.section];
    
    if (rowCount > 0) {
        CGRect sectionRect = [self support_rectForSection:indexPath.section currentRow:rowCount];
        attributes_x = CGRectGetMaxX(sectionRect) + sectionInsets.left;
    } else { //item数为0
        UICollectionViewLayoutAttributes * lastLayoutAttributes = [_cachedHeaderAttributes objectForKey:indexPath];
        attributes_x = CGRectGetMaxX(lastLayoutAttributes.frame) + sectionInsets.left + sectionInsets.right;
    }
    
    currentRect.origin.x = attributes_x;
    currentRect.origin.y = attributes_y;
    layoutAttributes.frame = currentRect;
}

- (CGSize)referenceSizeForKind:(NSString *)kind inSection:(NSInteger)section
{
    CGSize referenceSize = CGSizeZero;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        referenceSize = [self cachedReferenceSizeForHeaderInSection:section];
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        referenceSize = [self cachedReferenceSizeForFooterInSection:section];
    }
    return referenceSize;
}

#pragma mark - support method

- (CGRect)support_rectForSection:(NSInteger)section currentRow:(NSInteger)currentRow
{
    CGRect sectionRect = CGRectZero;
    
    CGFloat minX = CGFLOAT_MAX;
    CGFloat minY = CGFLOAT_MAX;
    CGFloat maxX = CGFLOAT_MIN;
    CGFloat maxY = CGFLOAT_MIN;
    if (currentRow < 0) {
        NSInteger rowCount = [self.collectionView numberOfItemsInSection:section];
        currentRow = rowCount;
    }
    
    for (NSInteger row = 0; row < currentRow; row ++) {
        NSIndexPath * loopIndexPath = [NSIndexPath indexPathForItem:row inSection:section];
        UICollectionViewLayoutAttributes * loopLayoutAttributes = [_cachedItemAttributes objectForKey:loopIndexPath];
        if ([loopLayoutAttributes isKindOfClass:[UICollectionViewLayoutAttributes class]]) {
            minX = MIN(minX, CGRectGetMinX(loopLayoutAttributes.frame));
            minY = MIN(minY, CGRectGetMinY(loopLayoutAttributes.frame));
            maxX = MAX(maxX, CGRectGetMaxX(loopLayoutAttributes.frame));
            maxY = MAX(maxY, CGRectGetMaxY(loopLayoutAttributes.frame));
        }
    }
    sectionRect = CGRectMake(minX, minY, maxX - minX, maxY - minY);
    return sectionRect;
}

#pragma mark - cached
#pragma mark size
- (UICollectionViewLayoutAttributes *)cachedLayoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * layoutAttributes = [_cachedItemAttributes objectForKey:indexPath];
    if (!layoutAttributes) {
        layoutAttributes = [self calculateLayoutAttributesForItemAtIndexPath:indexPath];
        [_cachedItemAttributes setObject:layoutAttributes forKey:indexPath];
    }
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)cachedLayoutAttributesForHeaderInSection:(NSInteger)section
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    UICollectionViewLayoutAttributes * layoutAttributes = [_cachedHeaderAttributes objectForKey:indexPath];
    if (!layoutAttributes) {
        layoutAttributes = [self calculateLayoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        [_cachedHeaderAttributes setObject:layoutAttributes forKey:indexPath];
    }
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)cachedLayoutAttributesForFooterInSection:(NSInteger)section
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    UICollectionViewLayoutAttributes * layoutAttributes = [_cachedFooterAttributes objectForKey:indexPath];
    if (!layoutAttributes) {
        layoutAttributes = [self calculateLayoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:indexPath];
        [_cachedFooterAttributes setObject:layoutAttributes forKey:indexPath];
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

- (CGSize)cachedReferenceSizeForHeaderInSection:(NSInteger)section
{
    NSValue * headerReferenceSizeValue = [_cachedHeaderSize objectForKey:@(section)];
    CGSize headerReferenceSize = [headerReferenceSizeValue CGSizeValue];
    if (!headerReferenceSizeValue) {
        headerReferenceSize = [self referenceSizeForHeaderInSection:section];
        [_cachedHeaderSize setObject:[NSValue valueWithCGSize:headerReferenceSize] forKey:@(section)];
    }
    return headerReferenceSize;
}

- (CGSize)cachedReferenceSizeForFooterInSection:(NSInteger)section
{
    NSValue * footerReferenceSizeSizeValue = [_cachedFooterSize objectForKey:@(section)];
    CGSize footerReferenceSize = [footerReferenceSizeSizeValue CGSizeValue];
    if (!footerReferenceSizeSizeValue) {
        footerReferenceSize = [self referenceSizeForFooterInSection:section];
        [_cachedFooterSize setObject:[NSValue valueWithCGSize:footerReferenceSize] forKey:@(section)];
    }
    return footerReferenceSize;
}

#pragma mark inset
- (UIEdgeInsets)cachedInsetForSectionAtIndex:(NSInteger)section
{
    NSValue * sectionInsetValue = [_cachedSectionInset objectForKey:@(section)];
    UIEdgeInsets sectionInset = [sectionInsetValue UIEdgeInsetsValue];
    if (!sectionInsetValue) {
        sectionInset = [self insetForSectionAtIndex:section];
        [_cachedSectionInset setObject:[NSValue valueWithUIEdgeInsets:sectionInset] forKey:@(section)];
    }
    return sectionInset;
}

#pragma mark spacing
- (CGFloat)cachedMinimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    NSNumber * minimunLineSpacingValue = [_cachedMinLineSpacing objectForKey:@(section)];
    CGFloat minimunLineSpacing = [minimunLineSpacingValue floatValue];
    if (!minimunLineSpacingValue) {
        minimunLineSpacing = [self minimumLineSpacingForSectionAtIndex:section];
        [_cachedMinLineSpacing setObject:@(minimunLineSpacing) forKey:@(section)];
    }
    return minimunLineSpacing;
}

- (CGFloat)cachedMinimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    NSNumber * minimumInteritemSpacingValue = [_cachedMinItemSpacing objectForKey:@(section)];
    CGFloat minimumInteritemSpacing = [minimumInteritemSpacingValue floatValue];
    if (!minimumInteritemSpacingValue) {
        minimumInteritemSpacing = [self minimumInteritemSpacingForSectionAtIndex:section];
        [_cachedMinItemSpacing setObject:@(minimumInteritemSpacing) forKey:@(section)];
    }
    return minimumInteritemSpacing;
}

#pragma mark - delegate
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize = _itemSize;
    if ([self delegateResponseSEL:@selector(flyCollectionView:layout:sizeForItemAtIndexPath:)]) {
        itemSize = [self.delegate flyCollectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    }
    return itemSize;
}

- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets sectionInset = _sectionInset;
    if ([self delegateResponseSEL:@selector(flyCollectionView:layout:insetForSectionAtIndex:)]) {
        sectionInset = [self.delegate flyCollectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }
    return sectionInset;
}

- (CGFloat)minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat minimunLineSpacing = _minimumLineSpacing;
    if ([self delegateResponseSEL:@selector(flyCollectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        minimunLineSpacing = [self.delegate flyCollectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
    }
    return minimunLineSpacing;
}

- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat minimumInteritemSpacing = _minimumInteritemSpacing;
    if ([self delegateResponseSEL:@selector(flyCollectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        minimumInteritemSpacing = [self.delegate flyCollectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    }
    return minimumInteritemSpacing;
}

- (CGSize)referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize headerReferenceSize = _headerReferenceSize;
    if ([self delegateResponseSEL:@selector(flyCollectionView:layout:referenceSizeForHeaderInSection:)]) {
        headerReferenceSize = [self.delegate flyCollectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section];
    }
    if (_scrollDirection == UICollectionViewScrollDirectionVertical) {
        headerReferenceSize.width = _collectionViewSize.width;
    } else if (_scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        headerReferenceSize.height = _collectionViewSize.height;
    }
    return headerReferenceSize;
}

- (CGSize)referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize footerReferenceSize = _footerReferenceSize;
    if ([self delegateResponseSEL:@selector(flyCollectionView:layout:referenceSizeForFooterInSection:)]) {
        footerReferenceSize = [self.delegate flyCollectionView:self.collectionView layout:self referenceSizeForFooterInSection:section];
    }
    if (_scrollDirection == UICollectionViewScrollDirectionVertical) {
        footerReferenceSize.width = _collectionViewSize.width;
    } else if (_scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        footerReferenceSize.height = _collectionViewSize.height;
    }
    return footerReferenceSize;
}

#pragma mark - delegate
- (BOOL)delegateResponseSEL:(SEL)sel
{
    BOOL response = [self.delegate conformsToProtocol:@protocol(FlyCollectionViewLayoutDelegate)] && [self.delegate respondsToSelector:sel];
    return response;
}

#pragma mark - public
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * itemAttributes = [self cachedLayoutAttributesForItemAtIndexPath:indexPath];
    return itemAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForHeaderInSection:(NSInteger)section
{
    UICollectionViewLayoutAttributes * headerAttributes = [self cachedLayoutAttributesForHeaderInSection:section];
    return headerAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForFooterInSection:(NSInteger)section
{
    UICollectionViewLayoutAttributes * footerAttributes = [self cachedLayoutAttributesForFooterInSection:section];
    return footerAttributes;
}

- (CGRect)rectForSection:(NSInteger)section
{
    return [self support_rectForSection:section currentRow:-1];
}

@end
