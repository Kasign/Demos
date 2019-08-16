//
//  FlyLoopView.h
//  无限循环CollectionView
//
//  Created by mx-QS on 2019/6/12.
//  Copyright © 2019 Fly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlyLayout.h"

NS_ASSUME_NONNULL_BEGIN

@class FlyLoopView;

@protocol FlyLoopViewDelegate <UIScrollViewDelegate>

@optional

- (void)flyLoopView:(FlyLoopView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)flyLoopView:(FlyLoopView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath;

- (NSIndexPath *)flyLoopView:(FlyLoopView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath;

- (CGPoint)flyLoopView:(FlyLoopView *)collectionView targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset;

@end

@protocol FlyLoopViewDataSource <NSObject>

@required

- (NSInteger)flyLoopViewNumberOfItems;

- (__kindof UICollectionReusableView *)flyLoopView:(FlyLoopView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface FlyLoopView : UIView

@property (nonatomic, strong) FlyLayout                 *   collectionViewLayout;
@property (nonatomic, weak)   id <FlyLoopViewDelegate>      delegate;
@property (nonatomic, weak)   id <FlyLoopViewDataSource>    dataSource;

@property (nonatomic, assign) BOOL       isLoop;
@property (nonatomic, assign) BOOL       isPage;

///最左边的item
@property (nonatomic, assign) NSInteger       itemOffset;

- (NSInteger)numberOfItems;

- (void)reloadData;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(FlyLayout *)layout;

- (__kindof UICollectionViewCell *)dequeueReusableCellWithIndexPath:(NSIndexPath *)indexPath cellClass:(Class)cellClass;

- (void)setItemOffset:(NSInteger)item animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
