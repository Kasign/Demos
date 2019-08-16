//
//  FlyLayout.h
//  无限循环CollectionView
//
//  Created by mx-QS on 2019/6/10.
//  Copyright © 2019 Fly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FlyLoopView;
@interface FlyLayout : NSObject

@property (nonatomic, assign) BOOL  needLoop; //是否需要循环

@property (nullable, nonatomic) FlyLoopView * loopView;
///item spacing
@property (nonatomic) CGFloat interitemSpacing;
@property (nonatomic) CGSize  itemSize;
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;

@property (nonatomic, assign, readonly) BOOL       shouldChanged; //size 等参数是否会变

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)prepareLayout;

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect;

@end

@protocol FlyLayoutDelegate <UICollectionViewDelegateFlowLayout>

@optional

- (void)loopViewLayout:(FlyLayout *)loopViewLayout initializeAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes indexPath:(NSIndexPath *)indexPath;

- (NSInteger)loopViewLayout:(FlyLayout *)loopViewLayout willScrollDirction:(UICollectionViewScrollPosition)scrollPosition;//左或者右

///item size
- (CGSize)loopView:(FlyLoopView *)loopView layout:(FlyLayout *)loopViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
///min spacing
- (CGFloat)loopView:(FlyLoopView *)loopView layout:(FlyLayout *)loopViewLayout interitemSpacingForSectionAtIndex:(NSInteger)section;

@end


NS_ASSUME_NONNULL_END
