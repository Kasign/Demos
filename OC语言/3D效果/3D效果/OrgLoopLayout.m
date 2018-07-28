//
//  OrgLoopLayout.m
//  3D效果
//
//  Created by Q on 2018/5/8.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "OrgLoopLayout.h"

@interface OrgLoopLayout ()

@property (nonatomic, strong) NSMutableArray  *  cellLayoutList;

@end

@implementation OrgLoopLayout

- (instancetype)init {
    
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _cellLayoutList      = [NSMutableArray array];
    }
    return self;
}

//- (CGSize)collectionViewContentSize {
//
//    CGSize contentSize = [super collectionViewContentSize];
//    if (contentSize.width <= CGRectGetWidth(self.collectionView.frame)) {
//        contentSize.width = CGRectGetWidth(self.collectionView.frame) + 1.0f;//为了让不能滑变可滑
//    }
//    return contentSize;
//}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}

- (void)prepareLayout {
    
    [super prepareLayout];
    [self.cellLayoutList removeAllObjects];
    
    NSInteger rowCount = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger row = 0 ; row < rowCount; row ++) {
        UICollectionViewLayoutAttributes * attribute = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:row inSection:0]];
        [self.cellLayoutList addObject:attribute];
    }
}

//- (CGSize)collectionViewContentSize {
//
//    return self.collectionView.bounds.size;
//}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *array = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes * attribute in self.cellLayoutList) {
        if (CGRectIntersectsRect(attribute.frame, rect)) {
            [array addObject:attribute];
        }
    }
    return array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes * layoutAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
//    CGFloat cellAlpha = 1.0f;
//    CGFloat cellWidth = layoutAttributes.frame.size.width;//cell宽度
//    CGFloat maxX      = layoutAttributes.frame.origin.x + cellWidth;//cell右顶点
//    CGFloat startdisappearX = self.collectionView.contentOffset.x + self.sectionInset.left - self.minimumLineSpacing;//完全消失位置坐标:x
    
    CGFloat centerX = self.collectionView.center.x;
    CGFloat cellCenterX = layoutAttributes.center.x - self.collectionView.contentOffset.x;
    
    NSLog(@" &&&&&/n** row:%ld ** cell.center.x:%f **",indexPath.row,cellCenterX);
    
    CGFloat dis = cellCenterX - centerX;
    CGFloat width = layoutAttributes.size.width;
    
    if (dis < 0 && dis > - width) {
        layoutAttributes.center = CGPointMake(centerX + dis/2.0, layoutAttributes.center.y);
    } else if (dis > 0 && dis < width) {
        layoutAttributes.center = CGPointMake(centerX + dis/2.0, layoutAttributes.center.y);
    } else {
        layoutAttributes.center = CGPointMake(-1000, layoutAttributes.center.y);
    }
    NSLog(@" ** row:%ld ** dis:%f ** Xcell.center.x:%f **",indexPath.row,dis,layoutAttributes.center.x);
    
    CATransform3D trans = CATransform3DIdentity;
    trans.m34 = -1/100.f;
    trans = CATransform3DRotate(trans, M_PI/80.f, 0, -1, 0);
    trans.m43 = 10 * ABS(centerX - cellCenterX)/centerX;
    layoutAttributes.transform3D = trans;
    
    return layoutAttributes;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
//    //1. 获取UICollectionView停止的时候的可视范围
//    CGRect contentFrame;
//
//    contentFrame.size   = self.collectionView.frame.size;
//    contentFrame.origin = proposedContentOffset;
//
//    NSArray * array = [self layoutAttributesForElementsInRect:contentFrame];//可视范围内个item属性
//
//    //2. 计算在可视范围的距离左边距最近的Item
//    CGFloat minDistanceX        = CGFLOAT_MAX;
//    CGFloat nearestCellWidth    = 0.f;
//    CGFloat collectionViewLeftX = proposedContentOffset.x + self.sectionInset.left; //要对齐的基准点
//    for (UICollectionViewLayoutAttributes * attrs in array) {
//        if (ABS(attrs.frame.origin.x - collectionViewLeftX) < ABS(minDistanceX)) {
//            minDistanceX     = attrs.frame.origin.x - collectionViewLeftX;
//            nearestCellWidth = attrs.frame.size.width;
//        }
//    }
//
//    CGFloat newOffsetX = minDistanceX;//最后要加的偏移量
//    if (velocity.x < 0.01) {//防止抖动
//        [self.collectionView setContentOffset:CGPointMake(proposedContentOffset.x + newOffsetX, proposedContentOffset.y) animated:YES];
//    }
//
    //3. 补回ContentOffset，则正好将Item居左边
//    return CGPointMake(proposedContentOffset.x + newOffsetX, proposedContentOffset.y);
    return CGPointMake(proposedContentOffset.x, proposedContentOffset.y);
}

@end
