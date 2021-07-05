//
//  FlyTableSectionModel.m
//  SigmaTableViewModel
//
//  Created by Walg on 2021/6/21.
//  
//

#import "FlyTableSectionModel.h"

@interface FlyTableSectionModel ()

@property (nonatomic, strong) NSMutableArray *cellModelArray;

@end

@implementation FlyTableSectionModel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _cellModelArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Header View & Footer View
- (UIView *)viewForSection:(NSInteger)section type:(FlyTableType)type tableView:(UITableView *)tableView {
    
    switch (type) {
        case FlyTableType_HEADER:
            return [self headerViewForSection:section tableView:tableView];
            break;
        case FlyTableType_FOOTER:
            return [self footerViewForSection:section tableView:tableView];
            break;
        case FlyTableType_CELL:
            
            break;
    }
    return nil;
}

- (UIView *)headerViewForSection:(NSInteger)section tableView:(UITableView *)tableView {
    
    if (self.headerViewRenderBlock) {
        return self.headerViewRenderBlock(section, tableView, self.headerDataObj);
    }
    return self.headerView;
}

- (UIView *)footerViewForSection:(NSInteger)section tableView:(UITableView *)tableView {
    
    if (self.footerViewRenderBlock) {
        return self.footerViewRenderBlock(section, tableView, self.footerDataObj);
    }
    return self.footerView;
}

#pragma mark - Header Height & Footer Height
- (CGFloat)heightForSection:(NSInteger)section type:(FlyTableType)type tableView:(UITableView *)tableView {
    
    switch (type) {
        case FlyTableType_HEADER:
            return [self headerHeightForSection:section tableView:tableView];
            break;
        case FlyTableType_FOOTER:
            return [self footerHeightForSection:section tableView:tableView];
            break;
        case FlyTableType_CELL:
            
            break;
    }
    return FlyTableMinHeight;
}

- (CGFloat)headerHeightForSection:(NSInteger)section tableView:(UITableView *)tableView {
    
    if (self.headerHeightBlock) {
        return self.headerHeightBlock(section, tableView, self.headerDataObj);
    }
    return self.headerHeight;
}

- (CGFloat)footerHeightForSection:(NSInteger)section tableView:(UITableView *)tableView {
    
    if (self.footerHeightBlock) {
        return self.footerHeightBlock(section, tableView, self.footerDataObj);
    }
    return self.footerHeight;
}

#pragma mark - GET
- (FlyTableCellModel *)cellModelForRow:(NSInteger)row {
    
    FlyTableCellModel *cellModel = nil;
    if (row < self.cellModelArray.count) {
        cellModel = [self.cellModelArray objectAtIndex:row];
    }
    return cellModel;
}

- (NSInteger)rowCount {
    
    return self.cellModelArray.count;
}

#pragma mark - Add & Remove
- (void)addCellModel:(FlyTableCellModel *)cellModel {
    
    if ([cellModel isKindOfClass:[FlyTableCellModel class]]) {
        [self.cellModelArray addObject:cellModel];
    }
}

- (void)insertCellModel:(FlyTableCellModel *)cellModel atIndex:(NSUInteger)index {
    
    if ([cellModel isKindOfClass:[FlyTableCellModel class]] && self.cellModelArray.count > index) {
        [self.cellModelArray insertObject:cellModel atIndex:index];
    }
}

- (void)removeCellModel:(FlyTableCellModel *)cellModel {
    
    if ([self.cellModelArray containsObject:cellModel]) {
        [self.cellModelArray removeObject:cellModel];
    }
}

- (void)removeCellModelAtIndex:(NSUInteger)index {
    
    if (self.cellModelArray.count > index) {
        [self.cellModelArray removeObjectAtIndex:index];
    }
}

@end
