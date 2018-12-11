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
    [self cachedAllItemsAttributes];
    [self.collectionView setContentSize:[self collectionViewContentSize]];
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
        UICollectionViewLayoutAttributes * firstAttri = [_layoutAttributesArr firstObject];
        UICollectionViewLayoutAttributes * lastAttri  = [_layoutAttributesArr lastObject];
        contentSize.height =  CGRectGetMaxY(lastAttri.frame) - CGRectGetMinY(firstAttri.frame);
    } else if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        contentSize = CGSizeMake(0, _collectionViewSize.height);
        UICollectionViewLayoutAttributes * firstAttri = [_layoutAttributesArr firstObject];
        UICollectionViewLayoutAttributes * lastAttri  = [_layoutAttributesArr lastObject];
        contentSize.width =  CGRectGetMaxX(lastAttri.frame) - CGRectGetMaxX(firstAttri.frame);
    }
    
//    FlyLog(@"----->>>>>contentSize:%@",[NSValue valueWithCGSize:contentSize]);
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
    CGSize itemSize = [self cachedSizeForItemAtIndexPath:indexPath];
    itemFrame.size = itemSize;
    cellAttribute.frame  = itemFrame;
    cellAttribute.bounds = CGRectMake(0, 0, itemSize.width, itemSize.height);
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
    CGSize itemSize = [self referenceSizeForKind:elementKind inSection:indexPath.section];
    supplemenFrame.size = itemSize;
    supplementAttributes.frame  = supplemenFrame;
    supplementAttributes.bounds = CGRectMake(0, 0, itemSize.width, itemSize.height);
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [self calculateHeaderLayoutAttributesWhenDirectionVertical:supplementAttributes indexPath:indexPath];
        } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
            [self calculateFooterLayoutAttributesWhenDirectionVertical:supplementAttributes indexPath:indexPath];
        }
    } else if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        
    }
    return supplementAttributes;
}

- (void)calculateHeaderLayoutAttributesWhenDirectionVertical:(UICollectionViewLayoutAttributes *)layoutAttributes indexPath:(NSIndexPath *)indexPath
{
    CGRect currentRect = layoutAttributes.frame;
    CGFloat attributes_x = 0;
    CGFloat attributes_y = 0;
    CGRect lastRect = CGRectZero;
    NSIndexPath * nearestInexPath = nil;
    if (indexPath.section > 0) {
        nearestInexPath = [NSIndexPath indexPathForItem:0 inSection:indexPath.section - 1];
    }
    if (nearestInexPath) {
        UICollectionViewLayoutAttributes * lastLayoutAttributes = [_cachedFooterAttributes objectForKey:nearestInexPath];
        lastRect = lastLayoutAttributes.frame;
    }
    attributes_y = CGRectGetMaxY(lastRect);
    
    currentRect.origin.x = attributes_x;
    currentRect.origin.y = attributes_y;
    layoutAttributes.frame = currentRect;
}

- (void)calculateFooterLayoutAttributesWhenDirectionVertical:(UICollectionViewLayoutAttributes *)layoutAttributes indexPath:(NSIndexPath *)indexPath
{
    CGRect currentRect = layoutAttributes.frame;
    CGFloat attributes_x = 0;
    CGFloat attributes_y = 0;
    CGRect lastRect = CGRectZero;
    NSIndexPath * nearestInexPath = nil;
    NSInteger rowCount = [self.collectionView numberOfItemsInSection:indexPath.section];
    if (rowCount > 0) {
        nearestInexPath = [NSIndexPath indexPathForItem:rowCount - 1 inSection:indexPath.section];
    }
    UIEdgeInsets sectionInsets = [self cachedInsetForSectionAtIndex:indexPath.section];
    if (nearestInexPath) {
        UICollectionViewLayoutAttributes * lastLayoutAttributes = [_cachedItemAttributes objectForKey:nearestInexPath];
        lastRect = lastLayoutAttributes.frame;
        attributes_y = CGRectGetMaxY(lastRect) + sectionInsets.bottom;
    } else {
        UICollectionViewLayoutAttributes * lastLayoutAttributes = [_cachedHeaderAttributes objectForKey:indexPath];
        lastRect = lastLayoutAttributes.frame;
        attributes_y = CGRectGetMaxY(lastRect) + sectionInsets.bottom + sectionInsets.top;
    }
    
    currentRect.origin.x = attributes_x;
    currentRect.origin.y = attributes_y;
    layoutAttributes.frame = currentRect;
}


//竖向滑动
- (void)calculateCellLayoutAttributesWhenDirectionVertical:(UICollectionViewLayoutAttributes *)layoutAttributes indexPath:(NSIndexPath *)indexPath
{
    CGRect currentRect = layoutAttributes.frame;
    CGFloat attributes_x = 0;
    CGFloat attributes_y = 0;
    CGRect lastRect = CGRectZero;
    NSIndexPath * nearestInexPath = [self calculateNearestIndexPathWithCurrentIndexPath:indexPath];
    if (nearestInexPath) {
        UICollectionViewLayoutAttributes * lastLayoutAttributes = [_cachedItemAttributes objectForKey:nearestInexPath];
        lastRect = lastLayoutAttributes.frame;
    }
    
    CGFloat lineSpacing = [self cachedMinimumLineSpacingForSectionAtIndex:indexPath.section];
    CGFloat itemSpacing = [self cachedMinimumInteritemSpacingForSectionAtIndex:indexPath.section];
    UIEdgeInsets sectionInsets = [self cachedInsetForSectionAtIndex:indexPath.section];
    UIEdgeInsets lastSectionInsets = UIEdgeInsetsZero;
    if (indexPath.section - 1 >= 0) {
        lastSectionInsets = [self insetForSectionAtIndex:indexPath.section - 1];
    }
    if (indexPath.row == 0) {
       UICollectionViewLayoutAttributes * headerLayoutAttributes = [_cachedHeaderAttributes objectForKey:indexPath];
        attributes_x = sectionInsets.left;
        attributes_y = CGRectGetMaxY(headerLayoutAttributes.frame) + sectionInsets.top;
    } else {
        attributes_x = CGRectGetMaxX(lastRect) + itemSpacing;
        attributes_y = CGRectGetMinY(lastRect);
        if (attributes_x + CGRectGetMaxX(currentRect) + sectionInsets.right > _collectionViewSize.width) {//需要折行
            attributes_x = sectionInsets.left;
            attributes_y = CGRectGetMaxY(lastRect) + lineSpacing;
        }
    }
    
    currentRect.origin.x = attributes_x;
    currentRect.origin.y = attributes_y;
    layoutAttributes.frame = currentRect;
//    FlyLog(@"当前：%ld 最近的：%ld lastFrame : %@ frame :%@",indexPath.row,nearestInexPath.row,[NSValue valueWithCGRect:lastRect],[NSValue valueWithCGRect:currentRect]);
}

//横向滑动
- (void)calculateCellLayoutAttributesWhenDirectionHorizontal:(UICollectionViewLayoutAttributes *)layoutAttributes indexPath:(NSIndexPath *)indexPath
{
    
    
}

//上面的优先级高
- (NSIndexPath *)calculateNearestIndexPathWithCurrentIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath * targetIndexPath = nil;
    NSArray * visibleIndexPaths = [_indexPathsToValidate copy];
    
    if ([visibleIndexPaths containsObject:indexPath]) {
        NSInteger index = [visibleIndexPaths indexOfObject:indexPath];
        if (index != 0) {
            targetIndexPath = [visibleIndexPaths objectAtIndex:index - 1];
        } else {
            
        }
    } else {
        NSIndexPath * firstVisibleIndexPath = visibleIndexPaths.firstObject;
        NSIndexPath * lastVisibleIndexPath  = visibleIndexPaths.lastObject;
         if ([lastVisibleIndexPath compare:indexPath] == NSOrderedAscending) {
            targetIndexPath = lastVisibleIndexPath;
         } else if ([firstVisibleIndexPath compare:indexPath] == NSOrderedDescending) {
             targetIndexPath = firstVisibleIndexPath;
         }
    }
    
    return targetIndexPath;
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
    if (!itemSizeValue) {
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

@end
