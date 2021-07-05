//
//  FlySectionConfig.h
//  SigmaTableViewModel
//
//  Created by Walg on 2021/6/21.
//  
//

#import <UIKit/UIKit.h>
#import "FlyTableViewHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlySectionConfig : NSObject

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;

@property (nonatomic, copy) FlyViewRenderBlock headerViewRenderBlock;
@property (nonatomic, copy) FlyViewRenderBlock footerViewRenderBlock;
@property (nonatomic, copy) FlyViewHeightBlock headerHeightBlock;
@property (nonatomic, copy) FlyViewHeightBlock footerHeightBlock;

@end

NS_ASSUME_NONNULL_END
