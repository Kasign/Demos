//
//  FlyCellConfig.h
//  SigmaTableViewModel
//
//  Created by Walg on 2021/6/21.
//  
//

#import <UIKit/UIKit.h>
#import "FlyTableViewHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlyCellConfig : NSObject

@property (nonatomic, copy) FlyCellRenderBlock renderBlock;
@property (nonatomic, copy) FlyCellWillDisplayBlock willDisplayBlock;
@property (nonatomic, copy) FlyCellWillSelectBlock willSelectBlock;
@property (nonatomic, copy) FlyCellWillSelectBlock willDeselectBlock;
@property (nonatomic, copy) FlyCellSelectionBlock didSelectBlock;
@property (nonatomic, copy) FlyCellSelectionBlock didDeselectBlock;
@property (nonatomic, copy) FlyRowActionsConfig rowActionsConfig;
@property (nonatomic, copy) FlyCellHeightBlock cellHeightBlock;
@property (nonatomic, assign) CGFloat rowHeight;

@end

NS_ASSUME_NONNULL_END
