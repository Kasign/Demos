//
//  FlyCollectionReusableView.h
//  DiyCollectionView
//
//  Created by 66-admin-qs. on 2018/11/30.
//  Copyright © 2018 Fly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlyCollectionReusableView : UIView

@property (nonatomic, strong, readonly) UIView   *   contentView;
@property (nonatomic, copy, nullable) NSString * reuseIdentifier;
@property (nonatomic, strong, nullable) UICollectionViewLayoutAttributes   *   layoutAttributes;

@end

NS_ASSUME_NONNULL_END
