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

- (void)prepareLayout
{
    _cachedItemAttributes = [NSMutableDictionary dictionary];
    _cachedHeaderAttributes = [NSMutableDictionary dictionary];
    _cachedFooterAttributes = [NSMutableDictionary dictionary];
    
    _cachedItemSize = [NSMutableDictionary dictionary];
    _cachedHeaderSize = [NSMutableDictionary dictionary];
    _cachedFooterSize = [NSMutableDictionary dictionary];
    _cachedSectionInset = [NSMutableDictionary dictionary];
    _cachedMinItemSpacing = [NSMutableDictionary dictionary];
    _cachedMinLineSpacing = [NSMutableDictionary dictionary];
    
    _indexPathsToValidate = [NSMutableArray array];
    _collectionViewSize = self.collectionView.bounds.size;
    _collectionInsets = self.collectionView.contentInset;
}

- (void)setDelegate:(id)delegate
{
    self.collectionView.delegate = delegate;
}

- (id)delegate
{
    return self.collectionView.delegate;
}

- (CGSize)collectionViewContentSize
{
    CGSize contentSize = CGSizeMake(_collectionViewSize.width, 0);
    
    return contentSize;
}

- (void)cachedAllItemsAttributes
{
    NSMutableArray * allAttributesArray = [NSMutableArray array];
    for (NSInteger section = 0; section < self.collectionView.numberOfSections; section++) {
        NSIndexPath * supplementIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        NSInteger numberOfCellsInSection = [self.collectionView numberOfItemsInSection:section];
        UICollectionViewLayoutAttributes * headerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:supplementIndexPath];
        UICollectionViewLayoutAttributes * footerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:supplementIndexPath];
        [allAttributesArray addObject:headerAttributes];
        [allAttributesArray addObject:footerAttributes];
        for (NSInteger item = 0; item < numberOfCellsInSection; item++) {
            NSIndexPath * itemIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes * itemAttributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
            [allAttributesArray addObject:itemAttributes];
        }
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
        UICollectionViewLayoutAttributes * headerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:supplementIndexPath];
        UICollectionViewLayoutAttributes * footerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:supplementIndexPath];
        if (CGRectIntersectsRect(rect, headerAttributes.frame)) {//两个矩形相交才加入
            [visibleAttributesArr addObject:headerAttributes];
            [_cachedHeaderAttributes setObject:headerAttributes forKey:supplementIndexPath];
        }
        if (CGRectIntersectsRect(rect, footerAttributes.frame)) {//两个矩形相交才加入
            [visibleAttributesArr addObject:footerAttributes];
            [_cachedFooterAttributes setObject:footerAttributes forKey:supplementIndexPath];
        }
        [allAttributesArray addObject:headerAttributes];
        [allAttributesArray addObject:footerAttributes];
        for (NSInteger item = 0; item < numberOfCellsInSection; item++) {
            NSIndexPath * itemIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes * itemAttributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
            [allAttributesArray addObject:itemAttributes];
            if (CGRectIntersectsRect(rect, itemAttributes.frame)) {//两个矩形相交才加入
                [visibleAttributesArr addObject:itemAttributes];
                [_cachedItemAttributes setObject:itemAttributes forKey:itemIndexPath];
            }
        }
    }
    _visibleAttributesArr = [visibleAttributesArr copy];
    _layoutAttributesArr  = [allAttributesArray copy];
    return  visibleAttributesArr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *cellAttribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGRect itemFrame = CGRectZero;
    CGSize itemSize = [self sizeForItemAtIndexPath:indexPath];
    itemFrame.size = itemSize;
    cellAttribute.frame  = itemFrame;
    cellAttribute.bounds = CGRectMake(0, 0, itemSize.width, itemSize.height);
    if (_scrollDirection == UICollectionViewScrollDirectionVertical) {//竖向滑动
        [self calculateCellLayoutAttributesWhenDirectionVertical:cellAttribute indexPath:indexPath];
    } else if (_scrollDirection == UICollectionViewScrollDirectionHorizontal) {//横向滑动
        [self calculateCellLayoutAttributesWhenDirectionHorizontal:cellAttribute indexPath:indexPath];
    }
    
    return cellAttribute;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes * supplementAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    
    CGRect supplemenFrame = CGRectZero;
    CGSize itemSize = [self referenceSizeForKind:elementKind inSection:indexPath.section];
    supplemenFrame.size = itemSize;
    supplementAttributes.frame  = supplemenFrame;
    supplementAttributes.bounds = CGRectMake(0, 0, itemSize.width, itemSize.height);
    
    
    
    return supplementAttributes;
}


//竖向滑动
- (void)calculateCellLayoutAttributesWhenDirectionVertical:(UICollectionViewLayoutAttributes *)layoutAttributes indexPath:(NSIndexPath *)indexPath
{
    CGRect currentRect = layoutAttributes.frame;
    CGFloat attributes_x = 0;
    CGFloat attributes_y = 0;
    UICollectionViewLayoutAttributes * lastLayoutAttributes = _layoutAttributesArr.lastObject;
    CGRect lastRect = lastLayoutAttributes.frame;
    CGFloat lineSpacing = [self cachedMinimumLineSpacingForSectionAtIndex:indexPath.section];
    CGFloat itemSpacing = [self cachedMinimumInteritemSpacingForSectionAtIndex:indexPath.section];
    UIEdgeInsets sectionInsets = [self cachedInsetForSectionAtIndex:indexPath.section];
    UIEdgeInsets lastSectionInsets = UIEdgeInsetsZero;
    if (indexPath.section - 1 >= 0) {
        lastSectionInsets = [self insetForSectionAtIndex:indexPath.section - 1];
    }
    if (indexPath.row == 0) {
        attributes_x = sectionInsets.left;
        attributes_y = CGRectGetMaxY(lastRect) + lastSectionInsets.bottom + sectionInsets.top;
    } else {
        attributes_x = CGRectGetMaxX(lastRect) + itemSpacing;
        attributes_y = CGRectGetMinY(lastRect);
        if (attributes_x + CGRectGetMaxX(currentRect) + sectionInsets.right > _collectionViewSize.width) {//需要折行
            attributes_x = sectionInsets.left;
            attributes_y = CGRectGetMaxY(lastRect) + lineSpacing;
        }
    }
}

//横向滑动
- (void)calculateCellLayoutAttributesWhenDirectionHorizontal:(UICollectionViewLayoutAttributes *)layoutAttributes indexPath:(NSIndexPath *)indexPath
{
    
    
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

#pragma mark - cached
- (CGSize)cachedSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSValue * itemSizeValue = [_cachedItemSize objectForKey:indexPath];
    CGSize itemSize = [itemSizeValue CGSizeValue];
    if (!itemSizeValue) {
        itemSize = [self sizeForItemAtIndexPath:indexPath];
        [_cachedItemSize setObject:[NSValue valueWithCGSize:itemSize] forKey:indexPath];
    }
    return itemSize;
}

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
    return headerReferenceSize;
}

- (CGSize)referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize footerReferenceSize = _footerReferenceSize;
    if ([self delegateResponseSEL:@selector(flyCollectionView:layout:referenceSizeForFooterInSection:)]) {
        footerReferenceSize = [self.delegate flyCollectionView:self.collectionView layout:self referenceSizeForFooterInSection:section];
    }
    return footerReferenceSize;
}

#pragma mark - delegate
- (BOOL)delegateResponseSEL:(SEL)sel
{
    BOOL response = [self.delegate conformsToProtocol:@protocol(FlyCollectionViewLayoutDelegate)] && [self.delegate respondsToSelector:sel];
    return response;
}

#pragma mark - publick

//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewLayoutAttributes * footerAttributes = nil;
//
//    return footerAttributes;
//}


- (UICollectionViewLayoutAttributes *)layoutAttributesForHeadterInSection:(NSInteger)section
{
    UICollectionViewLayoutAttributes * footerAttributes = nil;
    
    return footerAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForFooterInSection:(NSInteger)section
{
    UICollectionViewLayoutAttributes * footerAttributes = nil;
    
    return footerAttributes;
}


@end
