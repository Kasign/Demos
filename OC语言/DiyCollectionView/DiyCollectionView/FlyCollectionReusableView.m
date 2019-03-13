//
//  FlyCollectionReusableView.m
//  DiyCollectionView
//
//  Created by 66-admin-qs. on 2018/11/30.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "FlyCollectionReusableView.h"

@interface FlyCollectionReusableView ()

@property (nonatomic, strong, readwrite) UIView   *   contentView;

@end

@implementation FlyCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.contentView];
    }
    return self;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
    }
    return _contentView;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.contentView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}

@end
