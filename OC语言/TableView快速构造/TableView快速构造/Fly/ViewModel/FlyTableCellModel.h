//
//  FlyTableCellModel.h
//  SigmaTableViewModel
//
//  Created by Walg on 2021/6/21.
//  
//

#import "FlyCellConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlyTableCellModel : FlyCellConfig

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) id dataObj;

@property (nonatomic, strong) Class cellClass;
@property (nonatomic, copy) NSString *identifier;

- (UITableViewCell *)cellForIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;
- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
