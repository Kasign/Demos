//
//  FlyCellConfig.m
//  SigmaTableViewModel
//
//  Created by Walg on 2021/6/21.
//  
//

#import "FlyCellConfig.h"

@implementation FlyCellConfig

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _rowHeight = FlyTableMinHeight;
    }
    return self;
}

@end
