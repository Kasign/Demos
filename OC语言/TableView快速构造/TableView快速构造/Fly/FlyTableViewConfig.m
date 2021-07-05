//
//  FlyTableViewConfig.m
//  SigmaTableViewModel
//
//  Created by Walg on 2021/6/21.
//  
//

#import "FlyTableViewConfig.h"
#import "FlyTableViewHeader.h"

@implementation FlyTableViewConfig

+ (instancetype)defaultConfig {
    
    return [[self alloc] init];
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _rowHeight = FlyTableMinHeight;
        _sectionHeaderHeight = FlyTableMinHeight;
        _sectionFooterHeight = FlyTableMinHeight;
        _style = UITableViewStylePlain;
        _allowsMultipleSelection = NO;
        _allowsSelection = YES;
        _showsVerticalScrollIndicator = NO;
        _showsHorizontalScrollIndicator = NO;
        _separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

@end
