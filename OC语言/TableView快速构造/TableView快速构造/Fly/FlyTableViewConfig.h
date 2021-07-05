//
//  FlyTableViewConfig.h
//  SigmaTableViewModel
//
//  Created by Walg on 2021/6/21.
//  
//

#import <UIKit/UIKit.h>
#import "FlyTableViewHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlyTableViewConfig : NSObject

//定制cell
@property (nonatomic, strong) Class cellClass;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) CGFloat rowHeight;

@property (nonatomic, copy) FlyCellSelectionBlock didSelectBlock;
@property (nonatomic, copy) FlyCellSelectionBlock didDeselectBlock;

// 定制每个section的header和footer的高度
@property (nonatomic, assign) CGFloat sectionHeaderHeight;
@property (nonatomic, assign) CGFloat sectionFooterHeight;

@property (nonatomic, assign) UITableViewStyle style;

@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIView *tableFooterView;

@property (nonatomic, assign) BOOL allowsSelection;
@property (nonatomic, assign) BOOL allowsMultipleSelection;

@property (nonatomic, assign) UITableViewCellSeparatorStyle separatorStyle;

@property (nonatomic, assign) BOOL showsVerticalScrollIndicator;   // default NO
@property (nonatomic, assign) BOOL showsHorizontalScrollIndicator;  // default NO


+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

+ (instancetype)defaultConfig;

@end

NS_ASSUME_NONNULL_END
