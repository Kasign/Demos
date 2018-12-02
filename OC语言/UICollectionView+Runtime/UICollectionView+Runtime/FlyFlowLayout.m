//
//  FlyFlowLayout.m
//  UICollectionView+Runtime
//
//  Created by Walg on 2018/12/1.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "FlyFlowLayout.h"

@implementation FlyFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray * arr = [super layoutAttributesForElementsInRect:rect];
    
    return arr;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * attri = [super layoutAttributesForItemAtIndexPath:indexPath];
    return attri;
}

@end
