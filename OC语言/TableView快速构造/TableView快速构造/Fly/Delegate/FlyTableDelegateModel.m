//
//  FlyTableDelageteModel.m
//  SigmaTableViewModel
//
//  Created by Walg on 2021/6/21.
//  
//

#import "FlyTableDelegateModel.h"
#import "FlyTableViewHeader.h"
#import "FlyTableSectionModel.h"
#import "FlyTableCellModel.h"
#import "FlyTableViewRowAction.h"

@interface FlyTableDelegateModel ()

@property (nonatomic, weak) id <FlyTableModelDelegate> delegate;

@end


@implementation FlyTableDelegateModel

+ (instancetype)instanceWithId:(id)delegate {
    
    FlyTableDelegateModel *delegateModel = [[FlyTableDelegateModel alloc] init];
    delegateModel.delegate = delegate;
    return delegateModel;
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
    
    return [self.delegate sectionCount];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FlyTableCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    if (cellModel) {
        return [cellModel cellHeightForIndexPath:indexPath tableView:tableView];
    }
    return FlyTableMinHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    FlyTableSectionModel *sectionModel = [self sectionModelAtSection:section];
    if (sectionModel) {
        return [sectionModel heightForSection:section type:FlyTableType_HEADER tableView:tableView];
    }
    return FlyTableMinHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    FlyTableSectionModel *sectionModel = [self sectionModelAtSection:section];
    if (sectionModel) {
        return [sectionModel heightForSection:section type:FlyTableType_FOOTER tableView:tableView];
    }
    return FlyTableMinHeight;
}

#pragma mark - Header & Footer View
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    FlyTableSectionModel *sectionModel = [self sectionModelAtSection:section];
    if (section) {
        return [sectionModel viewForSection:section type:FlyTableType_HEADER tableView:tableView];
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    FlyTableSectionModel *sectionModel = [self sectionModelAtSection:section];
    if (section) {
        return [sectionModel viewForSection:section type:FlyTableType_FOOTER tableView:tableView];
    }
    return nil;
}

#pragma mark - Select
- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FlyTableCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    if (cellModel && cellModel.willSelectBlock) {
        return cellModel.willSelectBlock(indexPath, tableView);
    }
    return indexPath;
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FlyTableCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    if (cellModel && cellModel.willDeselectBlock) {
        return cellModel.willDeselectBlock(indexPath, tableView);
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FlyTableCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    if (cellModel && cellModel.didSelectBlock) {
        cellModel.didSelectBlock(indexPath, tableView);
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FlyTableCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    if (cellModel && cellModel.didDeselectBlock) {
        cellModel.didDeselectBlock(indexPath, tableView);
    }
}

#pragma mark - Display
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FlyTableCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    if (cellModel && cellModel.willDisplayBlock) {
        cellModel.willDisplayBlock(cell, indexPath, tableView);
    }
}


//- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return nil;
//}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {

    FlyTableCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    FlyRowActionsConfiguration *config = nil;
    if (cellModel.rowActionsConfig) {
        config = cellModel.rowActionsConfig(indexPath, tableView);
    } else {
        FlyTableSectionModel *sectionModel = [self sectionModelAtSection:indexPath.section];
        if (sectionModel.rowActionsConfig) {
            config = sectionModel.rowActionsConfig(indexPath, tableView);
        }
    }
    NSMutableArray *actionsArr = nil;
    if ([config isKindOfClass:[FlyRowActionsConfiguration class]]) {
        if ([config.actions isKindOfClass:[NSArray class]] && config.actions.count > 0) {
            actionsArr = [NSMutableArray arrayWithCapacity:config.actions.count];
            for (FlyTableViewRowAction *subAction in config.actions) {
                UITableViewRowActionStyle actionStyle = subAction.style == FlyRowActionStyle_Normal ? UITableViewRowActionStyleNormal : UITableViewRowActionStyleDestructive;
                UITableViewRowAction * rowAction = [UITableViewRowAction rowActionWithStyle:actionStyle title:subAction.title handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                    if (subAction.handler) {
                        subAction.handler(subAction, nil
                                          , ^(BOOL actionPerformed) {
                        });
                    }
                }];
                rowAction.backgroundColor = subAction.backgroundColor;
                [actionsArr addObject:rowAction];
            }
        }
    }
    return actionsArr;
}

- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {

    FlyTableCellModel *cellModel = [self cellModelAtIndexPath:indexPath];
    FlyRowActionsConfiguration *config = nil;
    if (cellModel.rowActionsConfig) {
        config = cellModel.rowActionsConfig(indexPath, tableView);
    } else {
        FlyTableSectionModel *sectionModel = [self sectionModelAtSection:indexPath.section];
        if (sectionModel.rowActionsConfig) {
            config = sectionModel.rowActionsConfig(indexPath, tableView);
        }
    }
    UISwipeActionsConfiguration *configuration = nil;
    if ([config isKindOfClass:[FlyRowActionsConfiguration class]]) {
        if ([config.actions isKindOfClass:[NSArray class]] && config.actions.count > 0) {
            NSMutableArray *actionsArr = [NSMutableArray arrayWithCapacity:config.actions.count];
            for (FlyTableViewRowAction * subAction in config.actions) {
                UIContextualAction *rowAction = [UIContextualAction contextualActionWithStyle:subAction.style title:subAction.title handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
                    if (subAction.handler) {
                        subAction.handler(subAction, sourceView, completionHandler);
                    }
                }];
                rowAction.backgroundColor = subAction.backgroundColor;
                rowAction.image = subAction.image;
                [actionsArr addObject:rowAction];
            }
            configuration = [UISwipeActionsConfiguration configurationWithActions:actionsArr];
            configuration.performsFirstActionWithFullSwipe = config.performsFirstActionWithFullSwipe;
        }
    }
    return configuration;
}

@end
