//
//  FlyMenuController.h
//  UICollectionView+Runtime
//
//  Created by 66-admin-qs. on 2018/12/26.
//  Copyright © 2018 Fly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FlyViewDirectionType) {
    FlyViewDirectionTypeTop     = 100,
    FlyViewDirectionTypeMiddle,
    FlyViewDirectionTypeBottom,
};

@interface FlyMenuItem : NSObject

- (instancetype)initWithTitle:(NSString *)title fontSize:(CGFloat)fontSize;

@property (nonatomic, copy)    NSString * title;
@property (nonatomic, assign)  CGFloat    fontSize;

@end


@interface FlyMenuController : NSObject

+ (FlyMenuController *)sharedMenuController;

@property (nonatomic, assign) FlyViewDirectionType defaultDirection;
@property (nonatomic, assign) CGFloat       itemWidth;
@property (nonatomic, assign) CGFloat       itemHeight;
@property (nonatomic, getter=isMenuVisible) BOOL menuVisible;
@property (nonatomic, nullable, copy)  NSArray <FlyMenuItem *> * menuItems;
@property (nonatomic, readonly) CGRect menuFrame;
@property (nonatomic, copy) void(^flyMenuClickBlock)(FlyMenuItem * menuItem, UIView * relyView);

- (void)update;
- (void)setMenuVisible:(BOOL)menuVisible animated:(BOOL)animated;
- (void)showRelyView:(UIView *)relyView inView:(UIView *)inView;

@end

NS_ASSUME_NONNULL_END
