//
//  FlyCollectionViewLayout.h
//  DiyCollectionView
//
//  Created by Fly. on 2018/11/29.
//  Copyright © 2018 Fly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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
@property (nonatomic) CGSize estimatedItemSize NS_AVAILABLE_IOS(8_0); // defaults to CGSizeZero - setting a non-zero size enables cells that self-size via -preferredLayoutAttributesFittingAttributes:
@property (nonatomic) UICollectionViewScrollDirection scrollDirection; // default is UICollectionViewScrollDirectionVertical
@property (nonatomic) CGSize headerReferenceSize;
@property (nonatomic) CGSize footerReferenceSize;
@property (nonatomic) UIEdgeInsets sectionInset;


// Set these properties to YES to get headers that pin to the top of the screen and footers that pin to the bottom while scrolling (similar to UITableView).
@property (nonatomic) BOOL sectionHeadersPinToVisibleBounds NS_AVAILABLE_IOS(9_0);
@property (nonatomic) BOOL sectionFootersPinToVisibleBounds NS_AVAILABLE_IOS(9_0);

//UICollectionViewLayoutAttributes
@property (nonatomic, weak) id<FlyCollectionViewLayoutDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
