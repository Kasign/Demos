//
//  LIChatCollectionViewFlowLayout.m
//  DiyCollectionView
//
//  Created by Walg on 2025/4/14.
//  Copyright © 2025 Fly. All rights reserved.
//

#import "LIChatCollectionViewFlowLayout.h"

// FLYIndexPath.h
#import <Foundation/Foundation.h>

@interface FLYIndexPath : NSObject <NSCopying>
@property (nonatomic, readonly) NSInteger section;
@property (nonatomic, readonly) NSInteger item;

+ (instancetype)indexPathForItem:(NSInteger)item inSection:(NSInteger)section;
- (instancetype)initWithItem:(NSInteger)item section:(NSInteger)section;
@end


// FLYIndexPath.m
#import "FLYIndexPath.h"

@implementation FLYIndexPath
+ (instancetype)indexPathForItem:(NSInteger)item inSection:(NSInteger)section {
    return [[self alloc] initWithItem:item section:section];
}

- (instancetype)initWithItem:(NSInteger)item section:(NSInteger)section {
    if (self = [super init]) {
        _item = item;
        _section = section;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [FLYIndexPath indexPathForItem:self.item inSection:self.section];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[FLYIndexPath class]]) return NO;
    FLYIndexPath *other = object;
    return other.section == self.section && other.item == self.item;
}

- (NSUInteger)hash {
    return self.section * 31 + self.item;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<FLYIndexPath section:%ld item:%ld>", (long)self.section, (long)self.item];
}
@end


// FLYCollectionViewReusableView.h
#import <UIKit/UIKit.h>

@interface FLYCollectionViewReusableView : UIView
@property (nonatomic, readonly) NSString *reuseIdentifier;
- (instancetype)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier;
- (void)prepareForReuse;
@end


// FLYCollectionViewReusableView.m
#import "FLYCollectionViewReusableView.h"

@implementation FLYCollectionViewReusableView
- (instancetype)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame]) {
        _reuseIdentifier = [reuseIdentifier copy];
    }
    return self;
}

- (void)prepareForReuse {
    // Subclasses override to reset content
}
@end


// FLYCollectionViewCell.h
#import "FLYCollectionViewReusableView.h"
#import "FLYIndexPath.h"

@interface FLYCollectionViewCell : FLYCollectionViewReusableView
@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, strong) FLYIndexPath *indexPath;
@end


// FLYCollectionViewCell.m
#import "FLYCollectionViewCell.h"

@implementation FLYCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_contentView];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.selected = NO;
    self.highlighted = NO;
    // Reset content
}
@end


// FLYCollectionViewLayoutInvalidationContext.h
#import <UIKit/UIKit.h>
@class FLYIndexPath;

@interface FLYCollectionViewLayoutInvalidationContext : NSObject
@property (nonatomic, strong) NSMutableIndexSet *invalidatedSections;
@property (nonatomic, strong) NSMutableArray<FLYIndexPath *> *invalidatedItems;
@property (nonatomic, strong) NSMutableIndexSet *insertedSections;
@property (nonatomic, strong) NSMutableIndexSet *deletedSections;
@property (nonatomic, strong) NSMutableArray<FLYIndexPath *> *insertedItems;
@property (nonatomic, strong) NSMutableArray<FLYIndexPath *> *deletedItems;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<FLYIndexPath *> *> *invalidatedSupplementaryItems;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<FLYIndexPath *> *> *insertedSupplementaryItems;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<FLYIndexPath *> *> *deletedSupplementaryItems;
@end


// FLYCollectionViewLayoutInvalidationContext.m
#import "FLYCollectionViewLayoutInvalidationContext.h"

@implementation FLYCollectionViewLayoutInvalidationContext
- (instancetype)init {
    if (self = [super init]) {
        _invalidatedSections = [NSMutableIndexSet indexSet];
        _invalidatedItems = [NSMutableArray array];
        _insertedSections = [NSMutableIndexSet indexSet];
        _deletedSections = [NSMutableIndexSet indexSet];
        _insertedItems = [NSMutableArray array];
        _deletedItems = [NSMutableArray array];
        _invalidatedSupplementaryItems = [NSMutableDictionary dictionary];
        _insertedSupplementaryItems = [NSMutableDictionary dictionary];
        _deletedSupplementaryItems = [NSMutableDictionary dictionary];
    }
    return self;
}
@end


// FLYCollectionViewLayout.h
#import <UIKit/UIKit.h>
#import "FLYCollectionViewLayoutInvalidationContext.h"
@class FLYCollectionView;
@class FLYIndexPath;

@interface FLYCollectionViewLayout : NSObject <NSCopying>
@property (nonatomic, weak) FLYCollectionView *collectionView;
- (void)prepareLayout;
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect;
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(FLYIndexPath *)indexPath;
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(FLYIndexPath *)indexPath;
- (CGSize)collectionViewContentSize;
+ (Class)invalidationContextClass;
- (void)invalidateLayoutWithContext:(FLYCollectionViewLayoutInvalidationContext *)context;
@end


// FLYCollectionViewLayout.m
#import "FLYCollectionViewLayout.h"

@implementation FLYCollectionViewLayout
+ (Class)invalidationContextClass {
    return [FLYCollectionViewLayoutInvalidationContext class];
}
- (void)prepareLayout {}
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect { return @[]; }
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(FLYIndexPath *)indexPath { return nil; }
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(FLYIndexPath *)indexPath { return nil; }
- (CGSize)collectionViewContentSize { return CGSizeZero; }
- (void)invalidateLayoutWithContext:(FLYCollectionViewLayoutInvalidationContext *)context {
    [self.collectionView setNeedsLayout];
}
- (id)copyWithZone:(NSZone *)zone {
    return [self.class new];
}
@end


// FLYCollectionViewFlowLayout.h
#import "FLYCollectionViewLayout.h"

@interface FLYCollectionViewFlowLayout : FLYCollectionViewLayout
@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) CGFloat minimumInteritemSpacing;
@property (nonatomic) UIEdgeInsets sectionInset;
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;
@property (nonatomic) CGSize headerReferenceSize;
@property (nonatomic) CGSize footerReferenceSize;
@end


// FLYCollectionViewFlowLayout.m
#import "FLYCollectionViewFlowLayout.h"
#import "FLYCollectionViewLayoutInvalidationContext.h"
#import "FLYIndexPath.h"

@implementation FLYCollectionViewFlowLayout {
    NSMutableArray<UICollectionViewLayoutAttributes *> *_layoutAttributes;
    CGSize _contentSize;
}

- (void)prepareLayout {
    [super prepareLayout];
    _layoutAttributes = [NSMutableArray array];
    CGRect bounds = self.collectionView.bounds;
    CGFloat x = self.sectionInset.left;
    CGFloat y = self.sectionInset.top;
    CGFloat contentWidth = 0;
    CGFloat contentHeight = 0;
    NSInteger sections = [self.collectionView numberOfSections];

    for (NSInteger section = 0; section < sections; section++) {
        // Header
        CGSize headerSize = CGSizeZero;
        if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
            headerSize = [self.collectionView.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section];
        } else {
            headerSize = self.headerReferenceSize;
        }
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            if (headerSize.height > 0) {
                FLYIndexPath *ip = [FLYIndexPath indexPathForItem:0 inSection:section];
                CGRect hf = CGRectMake(0, y, bounds.size.width, headerSize.height);
                UICollectionViewLayoutAttributes *hAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:ip];
                hAttr.frame = hf;
                [_layoutAttributes addObject:hAttr];
                y += headerSize.height + self.minimumLineSpacing;
                x = self.sectionInset.left;
            }
        } else {
            if (headerSize.width > 0) {
                FLYIndexPath *ip = [FLYIndexPath indexPathForItem:0 inSection:section];
                CGRect hf = CGRectMake(x, 0, headerSize.width, bounds.size.height);
                UICollectionViewLayoutAttributes *hAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:ip];
                hAttr.frame = hf;
                [_layoutAttributes addObject:hAttr];
                x += headerSize.width + self.minimumLineSpacing;
                y = self.sectionInset.top;
            }
        }

        // Items
        NSInteger items = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger item = 0; item < items; item++) {
            FLYIndexPath *ip = [FLYIndexPath indexPathForItem:item inSection:section];
            CGSize size = [self.collectionView.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:ip];
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                if (x + size.width > bounds.size.width - self.sectionInset.right) {
                    x = self.sectionInset.left;
                    y += size.height + self.minimumLineSpacing;
                }
                CGRect frame = CGRectMake(x, y, size.width, size.height);
                UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:ip];
                attr.frame = frame;
                [_layoutAttributes addObject:attr];
                x += size.width + self.minimumInteritemSpacing;
                contentHeight = MAX(contentHeight, CGRectGetMaxY(frame));
            } else {
                if (y + size.height > bounds.size.height - self.sectionInset.bottom) {
                    y = self.sectionInset.top;
                    x += size.width + self.minimumLineSpacing;
                }
                CGRect frame = CGRectMake(x, y, size.width, size.height);
                UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:ip];
                attr.frame = frame;
                [_layoutAttributes addObject:attr];
                y += size.height + self.minimumInteritemSpacing;
                contentWidth = MAX(contentWidth, CGRectGetMaxX(frame));
            }
        }

        // Footer
        CGSize footerSize = CGSizeZero;
        if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
            footerSize = [self.collectionView.delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:section];
        } else {
            footerSize = self.footerReferenceSize;
        }
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            y += self.sectionInset.bottom;
            if (footerSize.height > 0) {
                FLYIndexPath *ip = [FLYIndexPath indexPathForItem:0 inSection:section];
                CGRect ff = CGRectMake(0, y, bounds.size.width, footerSize.height);
                UICollectionViewLayoutAttributes *fAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:ip];
                fAttr.frame = ff;
                [_layoutAttributes addObject:fAttr];
                y += footerSize.height + self.minimumLineSpacing;
                contentHeight = MAX(contentHeight, CGRectGetMaxY(ff));
            }
        } else {
            x += self.sectionInset.right;
            if (footerSize.width > 0) {
                FLYIndexPath *ip = [FLYIndexPath indexPathForItem:0 inSection:section];
                CGRect ff = CGRectMake(x, 0, footerSize.width, bounds.size.height);
                UICollectionViewLayoutAttributes *fAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:ip];
                fAttr.frame = ff;
                [_layoutAttributes addObject:fAttr];
                x += footerSize.width + self.minimumLineSpacing;
                contentWidth = MAX(contentWidth, CGRectGetMaxX(ff));
            }
        }
    }

    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        _contentSize = CGSizeMake(bounds.size.width, contentHeight + self.sectionInset.bottom);
    } else {
        _contentSize = CGSizeMake(contentWidth + self.sectionInset.right, bounds.size.height);
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *result = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attr in _layoutAttributes) {
        if (CGRectIntersectsRect(attr.frame, rect)) {
            [result addObject:attr];
        }
    }
    return result;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(FLYIndexPath *)indexPath {
    for (UICollectionViewLayoutAttributes *attr in _layoutAttributes) {
        if (attr.representedElementCategory == UICollectionElementCategoryCell &&
            attr.indexPath.section == indexPath.section && attr.indexPath.item == indexPath.item) {
            return attr;
        }
    }
    return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(FLYIndexPath *)indexPath {
    for (UICollectionViewLayoutAttributes *attr in _layoutAttributes) {
        if ([attr.representedElementKind isEqualToString:kind] && attr.indexPath.section == indexPath.section) {
            return attr;
        }
    }
    return nil;
}

- (CGSize)collectionViewContentSize {
    return _contentSize;
}

- (void)invalidateLayoutWithContext:(FLYCollectionViewLayoutInvalidationContext *)context {
    if (context.invalidatedSections.count || context.invalidatedItems.count || context.insertedSections.count || context.deletedSections.count || context.insertedItems.count || context.deletedItems.count ||
        context.invalidatedSupplementaryItems.count || context.insertedSupplementaryItems.count || context.deletedSupplementaryItems.count) {
        [self prepareLayout];
    } else {
        [super invalidateLayoutWithContext:context];
    }
}
@end


// FLYCollectionView.h
#import <UIKit/UIKit.h>
#import "FLYCollectionViewLayout.h"
#import "FLYIndexPath.h"
@class FLYCollectionView;
@class FLYCollectionViewCell;
@class FLYCollectionViewReusableView;

@protocol FLYCollectionViewDataSource <NSObject>
@required
- (NSInteger)collectionView:(FLYCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
- (NSInteger)numberOfSectionsInCollectionView:(FLYCollectionView *)collectionView;
- (__kindof FLYCollectionViewCell *)collectionView:(FLYCollectionView *)collectionView cellForItemAtIndexPath:(FLYIndexPath *)indexPath;
@optional
- (__kindof FLYCollectionViewReusableView *)collectionView:(FLYCollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(FLYIndexPath *)indexPath;
@end

@protocol FLYCollectionViewDelegate <NSObject>
@optional
- (CGSize)collectionView:(FLYCollectionView *)collectionView layout:(FLYCollectionViewLayout *)layout sizeForItemAtIndexPath:(FLYIndexPath *)indexPath;
- (CGSize)collectionView:(FLYCollectionView *)collectionView layout:(FLYCollectionViewLayout *)layout referenceSizeForHeaderInSection:(NSInteger)section;
- (CGSize)collectionView:(FLYCollectionView *)collectionView layout:(FLYCollectionViewLayout *)layout referenceSizeForFooterInSection:(NSInteger)section;
@end

@interface FLYCollectionView : UIScrollView
@property (nonatomic, weak) id<FLYCollectionViewDataSource> dataSource;
@property (nonatomic, weak) id<FLYCollectionViewDelegate> delegate;
@property (nonatomic, strong) FLYCollectionViewLayout *collectionViewLayout;
@property (nonatomic) NSTimeInterval animationDuration;
@property (nonatomic) UIViewAnimationOptions animationOptions;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(FLYCollectionViewLayout *)layout;

// Cell
- (void)registerClass:(Class)viewClass forCellWithReuseIdentifier:(NSString *)identifier;
- (__kindof FLYCollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(FLYIndexPath *)indexPath;

// Supplementary
- (void)registerClass:(Class)viewClass forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier;
- (__kindof FLYCollectionViewReusableView *)dequeueReusableSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)identifier forIndexPath:(FLYIndexPath *)indexPath;

// Data reload
- (void)reloadData;
- (void)performBatchUpdates:(void (^)(void))updates completion:(void (^)(BOOL finished))completion;
// Overloaded to customize animation curve
- (void)performBatchUpdates:(void (^)(void))updates animationDuration:(NSTimeInterval)duration animationOptions:(UIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion;

// Updates
- (void)insertItemsAtIndexPaths:(NSArray<FLYIndexPath *> *)indexPaths;
- (void)deleteItemsAtIndexPaths:(NSArray<FLYIndexPath *> *)indexPaths;
- (void)reloadItemsAtIndexPaths:(NSArray<FLYIndexPath *> *)indexPaths;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
@end


// FLYCollectionView.m
#import "FLYCollectionView.h"
#import "FLYCollectionViewCell.h"
#import "FLYCollectionViewReusableView.h"
#import "FLYCollectionViewLayoutInvalidationContext.h"

@interface FLYCollectionView ()
@property (nonatomic, strong) NSMutableDictionary<NSString*, NSMutableSet<FLYCollectionViewReusableView*>*> *reuseQueues;
@property (nonatomic, strong) NSMutableDictionary<NSString*, NSMutableSet<FLYCollectionViewReusableView*>*> *reuseSupplementaryPool;
@property (nonatomic, strong) NSMutableArray<FLYCollectionViewCell*> *visibleCells;
@property (nonatomic, strong) NSMutableArray<FLYCollectionViewReusableView*> *visibleSupplementaryViews;
@property (nonatomic, assign) BOOL isBatchUpdating;
@property (nonatomic, strong) FLYCollectionViewLayoutInvalidationContext *batchUpdateContext;
@end

@implementation FLYCollectionView

- (instancetype)initWithFrame:(CGRect)frame layout:(FLYCollectionViewLayout *)layout {
    self = [super initWithFrame:frame];
    if (self) {
        _collectionViewLayout = layout;
        _reuseQueues = [NSMutableDictionary dictionary];
        _visibleCells = [NSMutableArray array];
        // Prepare layout
        [self.collectionViewLayout prepareLayout];
    }
    return self;
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    if (!cellClass || !identifier) return;
    _reuseQueues[identifier] = [NSMutableSet set];
}

- (FLYCollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(FLYIndexPath *)indexPath {
    NSMutableSet *queue = _reuseQueues[identifier];
    FLYCollectionViewCell *cell = [queue anyObject];
    if (cell) {
        [queue removeObject:cell];
    } else {
        cell = [[FLYCollectionViewCell alloc] initWithReuseIdentifier:identifier];
    }
    cell.indexPath = indexPath;
    return cell;
}

- (void)reloadData {
    // Remove existing
    for (FLYCollectionViewCell *cell in _visibleCells) {
        [cell removeFromSuperview];
        [cell prepareForReuse];
        [_reuseQueues[cell.reuseIdentifier] addObject:cell];
    }
    [_visibleCells removeAllObjects];
    // Invalidate and layout
    [self.collectionViewLayout invalidateLayout];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // Compute layout attributes
    NSArray<FLYCollectionViewLayoutAttributes *> *attrs = [self.collectionViewLayout layoutAttributesForElementsInRect:self.bounds];
    for (FLYCollectionViewLayoutAttributes *attr in attrs) {
        FLYIndexPath *ip = attr.indexPath;
        FLYCollectionViewCell *cell = [self dequeueReusableCellWithReuseIdentifier:attr.reuseIdentifier forIndexPath:ip];
        cell.frame = attr.frame;
        [_visibleCells addObject:cell];
        [self addSubview:cell];
    }
}

#pragma mark - Batch Update Support

- (void)performBatchUpdates:(void (^)(void))updates completion:(void (^)(BOOL))completion {
    [self beginUpdates];
    if (updates) {
        updates();
    }
    [self endUpdatesWithCompletion:completion];
}

- (void)beginUpdates {
    _pendingInsertedItems = [NSMutableArray array];
    _pendingDeletedItems = [NSMutableArray array];
    _pendingReloadedItems = [NSMutableArray array];
    _pendingInsertedSections = [NSMutableIndexSet indexSet];
    _pendingDeletedSections = [NSMutableIndexSet indexSet];
    _pendingReloadedSections = [NSMutableIndexSet indexSet];
}

- (void)insertItemsAtIndexPaths:(NSArray<FLYIndexPath *> *)indexPaths {
    [_pendingInsertedItems addObjectsFromArray:indexPaths];
}

- (void)deleteItemsAtIndexPaths:(NSArray<FLYIndexPath *> *)indexPaths {
    [_pendingDeletedItems addObjectsFromArray:indexPaths];
}

- (void)reloadItemsAtIndexPaths:(NSArray<FLYIndexPath *> *)indexPaths {
    [_pendingReloadedItems addObjectsFromArray:indexPaths];
}

- (void)insertSections:(NSIndexSet *)sections {
    [_pendingInsertedSections addIndexes:sections];
}

- (void)deleteSections:(NSIndexSet *)sections {
    [_pendingDeletedSections addIndexes:sections];
}

- (void)reloadSections:(NSIndexSet *)sections {
    [_pendingReloadedSections addIndexes:sections];
}

- (void)endUpdatesWithCompletion:(void (^)(BOOL))completion {
    FLYCollectionViewLayoutInvalidationContext *context = [[FLYCollectionViewLayoutInvalidationContext alloc] init];
    context.insertedIndexPaths = [_pendingInsertedItems copy];
    context.deletedIndexPaths = [_pendingDeletedItems copy];
    context.reloadIndexPaths = [_pendingReloadedItems copy];
    context.insertedSections = [_pendingInsertedSections copy];
    context.deletedSections = [_pendingDeletedSections copy];
    context.reloadSections = [_pendingReloadedSections copy];
    
    [self.collectionViewLayout invalidateLayoutWithContext:context];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    } completion:completion];
}

// ... (其他方法保持不变) ...

- (void)performBatchUpdates:(void (^)(void))updates animationDuration:(NSTimeInterval)duration animationOptions:(UIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion {
    NSTimeInterval oldDuration = self.animationDuration;
    UIViewAnimationOptions oldOptions = self.animationOptions;
    self.animationDuration = duration;
    self.animationOptions = options;
    [self performBatchUpdates:updates completion:^(BOOL finished) {
        self.animationDuration = oldDuration;
        self.animationOptions = oldOptions;
        if (completion) completion(finished);
    }];
}

@end
