//
//  FlyCollectionViewLayout.h
//  DiyCollectionView
//
//  Created by Fly. on 2018/11/29.
//  Copyright © 2018 Fly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Header.h"

NS_ASSUME_NONNULL_BEGIN

@class FlyCollectionView;
@class FlyCollectionViewLayout;
@protocol FlyCollectionViewDelegate;

@protocol FlyCollectionViewLayoutDelegate <FlyCollectionViewDelegate>

@optional

- (CGSize)flyCollectionView:(FlyCollectionView *)collectionView layout:(FlyCollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (UIEdgeInsets)flyCollectionView:(FlyCollectionView *)collectionView layout:(FlyCollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
//spacing
- (CGFloat)flyCollectionView:(FlyCollectionView *)collectionView layout:(FlyCollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
- (CGFloat)flyCollectionView:(FlyCollectionView *)collectionView layout:(FlyCollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;

- (CGSize)flyCollectionView:(FlyCollectionView *)collectionView layout:(FlyCollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
- (CGSize)flyCollectionView:(FlyCollectionView *)collectionView layout:(FlyCollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;


- (UICollectionViewLayoutAttributes *)flyCollectionView:(FlyCollectionView *)collectionView layout:(FlyCollectionViewLayout*)collectionViewLayout flyoutAttributesForItemInSection:(NSIndexPath *)indexPath;
- (UICollectionViewLayoutAttributes *)flyCollectionView:(FlyCollectionView *)collectionView layout:(FlyCollectionViewLayout*)collectionViewLayout flyoutAttributesForHeaderInSection:(NSInteger)section;
- (UICollectionViewLayoutAttributes *)flyCollectionView:(FlyCollectionView *)collectionView layout:(FlyCollectionViewLayout*)collectionViewLayout flyoutAttributesForFooterInSection:(NSInteger)section;

@end


@interface FlyCollectionViewLayout : NSObject

@property (nullable, nonatomic) FlyCollectionView *collectionView;
@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) CGFloat minimumInteritemSpacing;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGSize estimatedItemSize;
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;
@property (nonatomic) CGSize headerReferenceSize;
@property (nonatomic) CGSize footerReferenceSize;
@property (nonatomic) UIEdgeInsets sectionInset;

@property (nonatomic) BOOL sectionHeadersPinToVisibleBounds NS_AVAILABLE_IOS(9_0);
@property (nonatomic) BOOL sectionFootersPinToVisibleBounds NS_AVAILABLE_IOS(9_0);

@property (nonatomic, weak) id<FlyCollectionViewLayoutDelegate> delegate;


- (void)prepareLayout;

- (CGSize)collectionViewContentSize;

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;
- (UICollectionViewLayoutAttributes *)layoutAttributesForHeadterInSection:(NSInteger)section;
- (UICollectionViewLayoutAttributes *)layoutAttributesForFooterInSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
