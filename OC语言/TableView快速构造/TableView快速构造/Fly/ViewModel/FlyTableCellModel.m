//
//  FlyTableCellModel.m
//  SigmaTableViewModel
//
//  Created by Walg on 2021/6/21.
//  
//

#import "FlyTableCellModel.h"

@implementation FlyTableCellModel

#pragma mark - Cell
- (UITableViewCell *)cellForIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    
    UITableViewCell *cell = nil;
    if (self.renderBlock) {
        cell = self.renderBlock(indexPath, tableView, self.dataObj);
    }
    if (cell == nil && self.cellClass && self.identifier) {
        cell = [tableView dequeueReusableCellWithIdentifier:self.identifier];
        if (!cell) {
            cell = [[self.cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.identifier];
            if ([cell respondsToSelector:@selector(initConfig)]) {
                [(id<FlyTableCellDelegate>)cell initConfig];
            }
        }
        if ([cell respondsToSelector:@selector(updateDataWithModel:)]) {
            [(id<FlyTableCellDelegate>)cell updateDataWithModel:self.dataObj];
        }
    }
    return cell;
}

#pragma mark - Height
- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    
    if (self.cellHeightBlock) {
        return self.cellHeightBlock(indexPath, tableView, self.dataObj);
    }
    return self.rowHeight;
}

#pragma mark - GET
- (NSString *)identifier {
    
    if (!_identifier && self.cellClass) {
        return NSStringFromClass(self.cellClass);
    }
    return _identifier;
}

@end
