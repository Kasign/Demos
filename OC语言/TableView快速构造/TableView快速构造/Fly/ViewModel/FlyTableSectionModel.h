//
//  FlyTableSectionModel.h
//  SigmaTableViewModel
//
//  Created by Walg on 2021/6/21.
//  
//

#import "FlySectionConfig.h"
#import "FlyTableCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlyTableSectionModel : FlySectionConfig

@property (nonatomic, assign) NSInteger section;

@property (nonatomic, strong) id headerDataObj;
@property (nonatomic, strong) id footerDataObj;

/// Cell
@property (nonatomic, strong) Class cellClass;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, copy) FlyCellHeightBlock cellHeightBlock;
@property (nonatomic, copy) FlyCellSelectionBlock didSelectBlock;
@property (nonatomic, copy) FlyCellSelectionBlock didDeselectBlock;
@property (nonatomic, copy) FlyRowActionsConfig rowActionsConfig;

// Header & Footer View
- (UIView *)viewForSection:(NSInteger)section type:(FlyTableType)type tableView:(UITableView *)tableView;

// Header & Footer Height
- (CGFloat)heightForSection:(NSInteger)section type:(FlyTableType)type tableView:(UITableView *)tableView;

// Add & Remove
- (void)addCellModel:(FlyTableCellModel *)cellModel;
- (void)insertCellModel:(FlyTableCellModel *)cellModel atIndex:(NSUInteger)index;
- (void)removeCellModel:(FlyTableCellModel *)cellModel;
- (void)removeCellModelAtIndex:(NSUInteger)index;

// GET
- (NSInteger)rowCount;
- (FlyTableCellModel *)cellModelForRow:(NSInteger)row;

@end

NS_ASSUME_NONNULL_END
