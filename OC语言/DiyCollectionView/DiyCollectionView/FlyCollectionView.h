//
//  FlyCollectionView.h
//  DiyCollectionView
//
//  Created by Fly. on 2018/11/29.
//  Copyright © 2018 Fly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlyCollectionViewLayout.h"
#import "FlyCollectionReusableView.h"

NS_ASSUME_NONNULL_BEGIN

@class FlyCollectionView;
@protocol FlyCollectionViewDelegate <UIScrollViewDelegate>

@optional

- (BOOL)flyCollectionView:(FlyCollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)flyCollectionView:(FlyCollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)flyCollectionView:(FlyCollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)flyCollectionView:(FlyCollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)flyCollectionView:(FlyCollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath; // called when the user taps on an already-selected item in multi-select mode
- (void)flyCollectionView:(FlyCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)flyCollectionView:(FlyCollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)flyCollectionView:(FlyCollectionView *)collectionView willDisplayCell:(FlyCollectionReusableView *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0);
- (void)flyCollectionView:(FlyCollectionView *)collectionView willDisplaySupplementaryView:(FlyCollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0);
- (void)flyCollectionView:(FlyCollectionView *)collectionView didEndDisplayingCell:(FlyCollectionReusableView *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)flyCollectionView:(FlyCollectionView *)collectionView didEndDisplayingSupplementaryView:(FlyCollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath;

// These methods provide support for copy/paste actions on cells.
// All three should be implemented if any are.
- (BOOL)flyCollectionView:(FlyCollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)flyCollectionView:(FlyCollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender;
- (void)flyCollectionView:(FlyCollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender;

// support for custom transition layout
//- (nonnull FlyCollectionViewTransitionLayout *)collectionView:(FlyCollectionView *)collectionView transitionLayoutForOldLayout:(FlyCollectionViewLayout *)fromLayout newLayout:(FlyCollectionViewLayout *)toLayout;

// Focus
- (BOOL)flyCollectionView:(FlyCollectionView *)collectionView canFocusItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0);
//- (BOOL)flyCollectionView:(FlyCollectionView *)collectionView shouldUpdateFocusInContext:(FlyCollectionViewFocusUpdateContext *)context NS_AVAILABLE_IOS(9_0);
//- (void)flyCollectionView:(FlyCollectionView *)collectionView didUpdateFocusInContext:(FlyCollectionViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator NS_AVAILABLE_IOS(9_0);
- (nullable NSIndexPath *)indexPathForPreferredFocusedViewInCollectionView:(FlyCollectionView *)collectionView NS_AVAILABLE_IOS(9_0);

- (NSIndexPath *)flyCollectionView:(FlyCollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath NS_AVAILABLE_IOS(9_0);

- (CGPoint)flyCollectionView:(FlyCollectionView *)collectionView targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset NS_AVAILABLE_IOS(9_0);

@end

@protocol FlyCollectionViewDataSource <NSObject>

@required

- (NSInteger)flyCollectionView:(FlyCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;

- (__kindof FlyCollectionReusableView *)flyCollectionView:(FlyCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (NSInteger)numberOfSectionsInFlyCollectionView:(FlyCollectionView *)collectionView;

- (FlyCollectionReusableView *)flyCollectionView:(FlyCollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;

- (BOOL)flyCollectionView:(FlyCollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0);
- (void)flyCollectionView:(FlyCollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath NS_AVAILABLE_IOS(9_0);

@end


@interface FlyCollectionView : UIScrollView

@property (nonatomic, weak) id <FlyCollectionViewDelegate>    delegate;
@property (nonatomic, weak) id <FlyCollectionViewDataSource>  dataSource;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(FlyCollectionViewLayout *)layout NS_DESIGNATED_INITIALIZER;

@property (nonatomic, strong) FlyCollectionViewLayout * collectionViewLayout;

@property (nonatomic, strong, nullable) UIView *backgroundView;

- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(nullable UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;

- (void)registerClass:(nullable Class)viewClass forSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(nullable UINib *)nib forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier;

- (__kindof FlyCollectionReusableView *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
- (__kindof FlyCollectionReusableView *)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

// These properties control whether items can be selected, and if so, whether multiple items can be simultaneously selected.
@property (nonatomic) BOOL allowsSelection; // default is YES
@property (nonatomic) BOOL allowsMultipleSelection; // default is NO

#if UIKIT_DEFINE_AS_PROPERTIES
@property (nonatomic, readonly, nullable) NSArray<NSIndexPath *> *indexPathsForSelectedItems; // returns nil or an array of selected index paths
#else
- (nullable NSArray<NSIndexPath *> *)indexPathsForSelectedItems; // returns nil or an array of selected index paths
#endif
- (void)selectItemAtIndexPath:(nullable NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition;
- (void)deselectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;

// Returns YES if the collection view is reordering or has drop placeholders.
//@property (nonatomic, readonly) BOOL hasUncommittedUpdates API_AVAILABLE(ios(11.0));


- (void)reloadData;

- (UICollectionViewTransitionLayout *)startInteractiveTransitionToCollectionViewLayout:(UICollectionViewLayout *)layout completion:(nullable UICollectionViewLayoutInteractiveTransitionCompletion)completion NS_AVAILABLE_IOS(7_0);
- (void)finishInteractiveTransition NS_AVAILABLE_IOS(7_0);
- (void)cancelInteractiveTransition NS_AVAILABLE_IOS(7_0);

// Information about the current state of the collection view.

@property (nonatomic, readonly) NSInteger numberOfSections;

- (NSInteger)numberOfItemsInSection:(NSInteger)section;

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;

- (nullable NSIndexPath *)indexPathForItemAtPoint:(CGPoint)point;
- (nullable NSIndexPath *)indexPathForCell:(UICollectionViewCell *)cell;

- (nullable FlyCollectionReusableView *)cellForItemAtIndexPath:(NSIndexPath *)indexPath;
#if UIKIT_DEFINE_AS_PROPERTIES
@property (nonatomic, readonly) NSArray<__kindof FlyCollectionReusableView *> *visibleCells;
@property (nonatomic, readonly) NSArray<NSIndexPath *> *indexPathsForVisibleItems;
#else
- (NSArray<__kindof UICollectionViewCell *> *)visibleCells;
- (NSArray<NSIndexPath *> *)indexPathsForVisibleItems;
#endif

- (nullable FlyCollectionReusableView *)supplementaryViewForElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0);
- (NSArray<FlyCollectionReusableView *> *)visibleSupplementaryViewsOfKind:(NSString *)elementKind NS_AVAILABLE_IOS(9_0);
- (NSArray<NSIndexPath *> *)indexPathsForVisibleSupplementaryElementsOfKind:(NSString *)elementKind NS_AVAILABLE_IOS(9_0);


- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated;

- (void)insertSections:(NSIndexSet *)sections;
- (void)deleteSections:(NSIndexSet *)sections;
- (void)reloadSections:(NSIndexSet *)sections;
- (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection;

- (void)insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
- (void)deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
- (void)reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath;

- (void)performBatchUpdates:(void (NS_NOESCAPE ^ _Nullable)(void))updates completion:(void (^ _Nullable)(BOOL finished))completion;

- (BOOL)beginInteractiveMovementForItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0);
- (void)updateInteractiveMovementTargetPosition:(CGPoint)targetPosition NS_AVAILABLE_IOS(9_0);
- (void)endInteractiveMovement NS_AVAILABLE_IOS(9_0);
- (void)cancelInteractiveMovement NS_AVAILABLE_IOS(9_0);


@end

NS_ASSUME_NONNULL_END
