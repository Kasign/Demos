//
//  FlyTableViewModel.m
//  SigmaTableViewModel
//
//  Created by Walg on 2021/6/21.
//
//

#import "FlyTableViewModel.h"

@interface FlyTableViewModel ()

@property (nonatomic, strong) NSMutableArray<FlyTableSectionModel *> *sectionModelArray;

@property (nonatomic, strong, readwrite) FlyTableDelegateModel *delegateModel;
@property (nonatomic, strong, readwrite) FlyTableDataSourceModel *dataSourceModel;

@property (nonatomic, strong, readwrite) UITableView *tableView;
@property (nonatomic, strong, readwrite) FlyTableViewConfig *tableViewConfig;

@property (nonatomic, assign) BOOL isInitTable;

@end

@implementation FlyTableViewModel

- (instancetype)initWithConfig:(FlyTableViewConfig *)tableViewConfig tableView:(UITableView *)tableView {
    
    self = [super init];
    if (self) {
        _isInitTable = NO;
        _sectionModelArray = [NSMutableArray array];
        _tableViewConfig = tableViewConfig == nil ? [FlyTableViewConfig defaultConfig] : tableViewConfig;
        _tableView = tableView;
    }
    return self;
}

- (UITableView *)tableView {

    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:self.tableViewConfig.style];
    }
    [self initTableView];
    return _tableView;
}

- (void)initTableView {
    
    if (_isInitTable || _tableView == nil) {
        return;
    }
    _isInitTable = YES;
    _tableView.tableFooterView = self.tableViewConfig.tableFooterView;
    _tableView.tableHeaderView = self.tableViewConfig.tableHeaderView;
    
    _tableView.rowHeight = self.tableViewConfig.rowHeight;
    
    _tableView.separatorStyle = self.tableViewConfig.separatorStyle;
    
    _tableView.sectionHeaderHeight = self.tableViewConfig.sectionHeaderHeight;
    _tableView.sectionFooterHeight = self.tableViewConfig.sectionFooterHeight;
    
    _tableView.allowsSelection = self.tableViewConfig.allowsSelection;
    _tableView.allowsMultipleSelection = self.tableViewConfig.allowsMultipleSelection;
    
    _tableView.showsVerticalScrollIndicator = self.tableViewConfig.showsVerticalScrollIndicator;
    _tableView.showsHorizontalScrollIndicator = self.tableViewConfig.showsHorizontalScrollIndicator;
    
    _tableView.delegate = self.delegateModel;
    _tableView.dataSource = self.dataSourceModel;
}

#pragma mark - GET
- (FlyTableDelegateModel *)delegateModel {
    
    if (!_delegateModel) {
        _delegateModel = [FlyTableDelegateModel instanceWithId:self];
    }
    return _delegateModel;
}

- (FlyTableDataSourceModel *)dataSourceModel {
    
    if (!_dataSourceModel) {
        _dataSourceModel = [FlyTableDataSourceModel instanceWithId:self];
    }
    return _dataSourceModel;
}

#pragma mark - Refresh
- (void)reloadData {
    
    [self.tableView reloadData];
}

#pragma mark - Add & Remove Cell

- (void)clearAllData {
    
    [self.sectionModelArray removeAllObjects];
    [self reloadData];
}

#pragma mark Add Section
- (void)addSetionWithDatas:(NSArray *)dataArr {
    
    [self addSetionWithDatas:dataArr block:nil];
}

- (void)addSetionWithDatas:(NSArray *)dataArr block:(void(^)(FlyTableSectionModel *sectionModel))block {
    
    if ([dataArr isKindOfClass:[NSArray class]]) {
        FlyTableSectionModel *sectionModel = [self createNewSectionModelWithConfig:self.tableViewConfig];
        sectionModel.section = self.sectionCount;
        [self.sectionModelArray addObject:sectionModel];
        if (block) {
            block(sectionModel);
        }
        for (id dataObj in dataArr) {
            [self addItemWithData:dataObj inSectionModel:sectionModel block:nil];
        }
        [self reloadData];
    }
}

#pragma mark Insert Section
- (void)insertSectionWithDatas:(NSArray *)dataArr atIndex:(NSUInteger)index {
    
    [self insertSectionWithDatas:dataArr atIndex:index block:nil];
}

- (void)insertSectionWithDatas:(NSArray *)dataArr atIndex:(NSUInteger)index block:(void(^_Nullable)(FlyTableSectionModel *sectionModel))block {
    
    if ([dataArr isKindOfClass:[NSArray class]] && index < self.sectionCount) {
        FlyTableSectionModel *sectionModel = [self createNewSectionModelWithConfig:self.tableViewConfig];
        sectionModel.section = self.sectionCount;
        [self.sectionModelArray insertObject:sectionModel atIndex:index];
        if (block) {
            block(sectionModel);
        }
        for (id dataObj in dataArr) {
            [self addItemWithData:dataObj inSectionModel:sectionModel block:nil];
        }
        [self reloadData];
    }
}

#pragma mark Add Item
- (void)addItem:(id)dataObj atSection:(NSUInteger)section {
    
    [self addItem:dataObj atSection:section block:nil];
}

- (void)addItem:(id)dataObj atSection:(NSUInteger)section height:(CGFloat)height {
    
    [self addItem:dataObj atSection:section block:^(FlyTableCellModel * _Nonnull cellModel) {
        cellModel.rowHeight = height;
    }];
}

- (void)addItem:(id)dataObj atSection:(NSUInteger)section block:(void(^)(FlyTableCellModel *cellModel))block {
    
    if (dataObj && section < self.sectionCount) {
        [self addItemWithData:dataObj inSectionModel:[self sectionModelAtSection:section] block:block];
        [self reloadData];
    }
}

- (void)addItemWithData:(id)dataObj inSectionModel:(FlyTableSectionModel *)sectionModel block:(void(^)(FlyTableCellModel *cellModel))block {
    
    if (dataObj && sectionModel) {
        FlyTableCellModel *cellModel = [self createNewCellModelInSectionModel:sectionModel];
        cellModel.dataObj = dataObj;
        [sectionModel addCellModel:cellModel];
        if (block) {
            block(cellModel);
        }
    }
}

#pragma mark Insert Item
- (void)insertItem:(id)dataObj atIndex:(NSUInteger)index atSection:(NSUInteger)section {
    
    [self insertItem:dataObj atIndex:index atSection:section block:nil];
}

- (void)insertItem:(id)dataObj atIndex:(NSUInteger)index atSection:(NSUInteger)section height:(CGFloat)height {
 
    [self insertItem:dataObj atIndex:index atSection:section block:^(FlyTableCellModel * _Nonnull cellModel) {
        cellModel.rowHeight = height;
    }];
}

- (void)insertItem:(id)dataObj atIndex:(NSUInteger)index atSection:(NSUInteger)section block:(void(^_Nullable)(FlyTableCellModel *cellModel))block {
    
    if (dataObj && section < self.sectionCount) {
        FlyTableSectionModel *sectionModel = [self sectionModelAtSection:section];
        if (sectionModel) {
            [self insertItemWithData:dataObj inSectionModel:sectionModel atIndex:index block:block];
        }
    }
}

- (void)insertItemWithData:(id)dataObj inSectionModel:(FlyTableSectionModel *)sectionModel atIndex:(NSUInteger)index block:(void(^)(FlyTableCellModel *cellModel))block {
    
    if (dataObj && sectionModel && index < sectionModel.rowCount) {
        FlyTableCellModel *cellModel = [self createNewCellModelInSectionModel:sectionModel];
        cellModel.dataObj = dataObj;
        [sectionModel insertCellModel:cellModel atIndex:index];
        if (block) {
            block(cellModel);
        }
    }
}

#pragma mark Remove
- (void)removeSectionAtIndex:(NSUInteger)section {
    
    if (section < self.sectionCount) {
        [self.sectionModelArray removeObjectAtIndex:section];
        [self reloadData];
    }
}

- (void)removeItemAtIndex:(NSUInteger)index section:(NSUInteger)section {
    
    if (section < self.sectionCount) {
        FlyTableSectionModel *sectionModel = [self sectionModelAtSection:section];
        NSUInteger rowCount = [sectionModel rowCount];
        if (rowCount > index) {
            [sectionModel removeCellModelAtIndex:index];
            [self reloadData];
        }
    }
}

- (void)removeItem:(id)dataObj section:(NSUInteger)section {
    
    if (section < self.sectionCount) {
        FlyTableSectionModel *sectionModel = [self sectionModelAtSection:section];
        NSUInteger rowCount = [sectionModel rowCount];
        for (NSUInteger index = 0; index < rowCount; index ++) {
            @autoreleasepool {
                FlyTableCellModel *cellModel = [sectionModel cellModelForRow:index];
                if (cellModel.dataObj == dataObj) {
                    [sectionModel removeCellModel:cellModel];
                    [self reloadData];
                    break;
                }
            }
        }
    }
}

#pragma mark - Create
- (FlyTableSectionModel *)createNewSectionModelWithConfig:(FlyTableViewConfig *)tableConfig {
    
    FlyTableSectionModel *sectionModel = [[FlyTableSectionModel alloc] init];
    if (tableConfig) {
        sectionModel.headerHeight = tableConfig.sectionHeaderHeight;
        sectionModel.footerHeight = tableConfig.sectionFooterHeight;
        
        //cell
        sectionModel.cellClass  = tableConfig.cellClass;
        sectionModel.identifier = tableConfig.identifier;
        sectionModel.rowHeight  = tableConfig.rowHeight;
        sectionModel.didSelectBlock = tableConfig.didSelectBlock;
        sectionModel.didDeselectBlock = tableConfig.didDeselectBlock;
    }
    return sectionModel;
}

- (FlyTableCellModel *)createNewCellModelInSectionModel:(FlyTableSectionModel *)sectionModel {
    
    FlyTableCellModel *cellModel = [[FlyTableCellModel alloc] init];
    if (sectionModel) {
        cellModel.cellClass = sectionModel.cellClass;
        cellModel.identifier = sectionModel.identifier;
        cellModel.rowHeight = sectionModel.rowHeight;
        cellModel.cellHeightBlock = sectionModel.cellHeightBlock;
        cellModel.didSelectBlock = sectionModel.didSelectBlock;
        cellModel.didDeselectBlock = sectionModel.didDeselectBlock;
    }
    return cellModel;
}

#pragma mark - FlyTableModelDelegate
- (FlyTableSectionModel*)sectionModelAtSection:(NSUInteger)section {
    
    FlyTableSectionModel *sectionModel = nil;
    if (section < self.sectionModelArray.count) {
        sectionModel = self.sectionModelArray[section];
    }
    return sectionModel;
}

- (FlyTableCellModel*)cellModelAtIndexPath:(NSIndexPath *)indexPath {
    
    FlyTableCellModel *cellModel = nil;
    if ([indexPath isKindOfClass:[NSIndexPath class]]) {
        FlyTableSectionModel *sectionModel = [self sectionModelAtSection:indexPath.section];
        if (sectionModel) {
            cellModel = [sectionModel cellModelForRow:indexPath.row];
        }
    }
    return cellModel;
}

- (NSUInteger)sectionCount {
    
    return self.sectionModelArray.count;
}

@end
