//
//  FlyTableDataSourceModel.m
//  SigmaTableViewModel
//
//  Created by Walg on 2021/6/21.
//  
//

#import "FlyTableDataSourceModel.h"
#import "FlyTableViewHeader.h"
#import "FlyTableSectionModel.h"
#import "FlyTableCellModel.h"

@interface FlyTableDataSourceModel ()

@property (nonatomic, weak) id <FlyTableModelDelegate> delegate;

@end

@implementation FlyTableDataSourceModel

+ (instancetype)instanceWithId:(id)delegate {
    
    FlyTableDataSourceModel *dataSourceModel = [[FlyTableDataSourceModel alloc] init];
    dataSourceModel.delegate = delegate;
    return dataSourceModel;
}

#pragma mark - GET
- (FlyTableSectionModel *)sectionModelAtSection:(NSInteger)section {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionModelAtSection:)]) {
        return [self.delegate sectionModelAtSection:section];
    }
    return nil;
}

- (FlyTableCellModel *)cellModelAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellModelAtIndexPath:)]) {
        return [self.delegate cellModelAtIndexPath:indexPath];
    }
    return nil;
}

- (NSInteger)sectionCount {
    
    if (self.delegate) {
        return [self.delegate sectionCount];
    }
    return 1;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self sectionCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    FlyTableSectionModel *sectionModel = [self sectionModelAtSection:section];
    sectionModel.section = section;
    return sectionModel.rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    FlyTableCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    if (cellModel) {
        cellModel.row = indexPath.row;
        cell = [cellModel cellForIndexPath:indexPath tableView:tableView];
    }
    return cell;
}

@end
