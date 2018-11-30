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

@end


@implementation FlyCollectionViewLayout

- (void)prepareLayout
{
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

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray * visibleAttributesArr = [NSMutableArray array];
    NSMutableArray * allAttributesArray = [NSMutableArray array];
    for (NSInteger i = 0; i < self.collectionView.numberOfSections; i++) {
        NSInteger numberOfCellsInSection = [self.collectionView numberOfItemsInSection:i];
        UICollectionViewLayoutAttributes * headerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        UICollectionViewLayoutAttributes * footerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        if (CGRectIntersectsRect(rect, headerAttributes.frame)) {//两个矩形相交才加入
            [visibleAttributesArr addObject:headerAttributes];
        }
        if (CGRectIntersectsRect(rect, footerAttributes.frame)) {//两个矩形相交才加入
            [visibleAttributesArr addObject:footerAttributes];
        }
        [allAttributesArray addObject:headerAttributes];
        [allAttributesArray addObject:footerAttributes];
        for (NSInteger j = 0; j < numberOfCellsInSection; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes * cellAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [allAttributesArray addObject:cellAttributes];
            if (CGRectIntersectsRect(rect, cellAttributes.frame)) {//两个矩形相交才加入
                [visibleAttributesArr addObject:cellAttributes];
            }
        }
    }
    _visibleAttributesArr = [visibleAttributesArr copy];
    _layoutAttributesArr = [allAttributesArray copy];
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
    CGFloat lineSpacing = [self minimumLineSpacing];
    CGFloat itemSpacing = [self minimumInteritemSpacing];
    UIEdgeInsets sectionInsets = [self insetForSectionAtIndex:indexPath.section];
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
        referenceSize = [self referenceSizeForHeaderInSection:section];
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        referenceSize = [self referenceSizeForFooterInSection:section];
    }
    return referenceSize;
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

@end
