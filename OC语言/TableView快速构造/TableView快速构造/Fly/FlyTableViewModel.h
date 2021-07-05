//
//  FlyTableViewModel.h
//  SigmaTableViewModel
//
//  Created by Walg on 2021/6/21.
//  
//

#import <UIKit/UIKit.h>
#import "FlyTableViewHeader.h"
#import "FlyTableViewConfig.h"
#import "FlyTableDelegateModel.h"
#import "FlyTableDataSourceModel.h"
#import "FlyTableSectionModel.h"
#import "FlyTableCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlyTableViewModel : NSObject <FlyTableModelDelegate>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) FlyTableViewConfig *tableViewConfig;

@property (nonatomic, strong, readonly) FlyTableDelegateModel *delegateModel;
@property (nonatomic, strong, readonly) FlyTableDataSourceModel *dataSourceModel;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

// 唯一的初始化方法
- (instancetype)initWithConfig:(FlyTableViewConfig *__nullable)tableViewConfig tableView:(UITableView *__nullable)tableView;

// 添加section, dataArr<cell datas>
- (void)addSetionWithDatas:(NSArray *)dataArr;
- (void)addSetionWithDatas:(NSArray *)dataArr block:(void(^_Nullable)(FlyTableSectionModel *sectionModel))block;

// 插入section dataArr<cell datas>
- (void)insertSectionWithDatas:(NSArray *)dataArr atIndex:(NSUInteger)index;
- (void)insertSectionWithDatas:(NSArray *)dataArr atIndex:(NSUInteger)index block:(void(^_Nullable)(FlyTableSectionModel *sectionModel))block;

// 添加cell
- (void)addItem:(id)dataObj atSection:(NSUInteger)section;
- (void)addItem:(id)dataObj atSection:(NSUInteger)section height:(CGFloat)height;
- (void)addItem:(id)dataObj atSection:(NSUInteger)section block:(void(^_Nullable)(FlyTableCellModel *cellModel))block;

// 插入cell
- (void)insertItem:(id)dataObj atIndex:(NSUInteger)index atSection:(NSUInteger)section;
- (void)insertItem:(id)dataObj atIndex:(NSUInteger)index atSection:(NSUInteger)section height:(CGFloat)height;
- (void)insertItem:(id)dataObj atIndex:(NSUInteger)index atSection:(NSUInteger)section block:(void(^_Nullable)(FlyTableCellModel *cellModel))block;

// 移除
- (void)removeSectionAtIndex:(NSUInteger)section;
- (void)removeItemAtIndex:(NSUInteger)index section:(NSUInteger)section;
- (void)removeItem:(id)dataObj section:(NSUInteger)section;

/// 清除所有数据
- (void)clearAllData;

/// 刷新
- (void)reloadData;

- (NSUInteger)sectionCount;
- (FlyTableSectionModel *)sectionModelAtSection:(NSUInteger)section;
- (FlyTableCellModel *)cellModelAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
