//
//  FlyTableViewHeader.h
//  SigmaTableViewModel
//
//  Created by Walg on 2021/6/21.
//  
//

#ifndef FlyTableViewHeader_h
#define FlyTableViewHeader_h

NS_ASSUME_NONNULL_BEGIN

#define FlyTableMinHeight CGFLOAT_MIN


typedef NS_ENUM(NSUInteger, FlyTableType) {
    FlyTableType_HEADER,
    FlyTableType_FOOTER,
    FlyTableType_CELL,
};

typedef UIView *_Nullable(^FlyViewRenderBlock)(NSInteger section, UITableView * tableView, id dataObj);
typedef UITableViewCell *_Nonnull(^FlyCellRenderBlock)(NSIndexPath *indexPath, UITableView *tableView, id dataObj);


typedef CGFloat (^FlyViewHeightBlock)(NSInteger section, UITableView *tableView, id dataObj);
typedef CGFloat (^FlyCellHeightBlock)(NSIndexPath *indexPath, UITableView *tableView, id dataObj);
 
typedef NSIndexPath *_Nonnull(^FlyCellWillSelectBlock)(NSIndexPath *indexPath, UITableView *tableView);
typedef void (^FlyCellSelectionBlock)(NSIndexPath *indexPath, UITableView *tableView);

typedef void(^FlyCellWillDisplayBlock)(UITableViewCell *cell, NSIndexPath *indexPath, UITableView *tableView);

@class FlyRowActionsConfiguration;
typedef FlyRowActionsConfiguration *_Nullable (^FlyRowActionsConfig)(NSIndexPath *indexPath, UITableView *tableView);


@protocol FlyTableModelDelegate <NSObject>

@required
- (NSUInteger)sectionCount;
- (id)sectionModelAtSection:(NSUInteger)section;
- (id)cellModelAtIndexPath:(NSIndexPath *)indexPath;

@end


@protocol FlyTableCellDelegate <NSObject>

- (void)initConfig;
- (void)updateDataWithModel:(id)model;

@end

NS_ASSUME_NONNULL_END

#endif /* FlyTableViewHeader_h */
