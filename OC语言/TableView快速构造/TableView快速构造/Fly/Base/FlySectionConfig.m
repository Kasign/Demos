//
//  FlySectionConfig.m
//  SigmaTableViewModel
//
//  Created by Walg on 2021/6/21.
//  
//

#import "FlySectionConfig.h"

@implementation FlySectionConfig

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _headerHeight = FlyTableMinHeight;
        _footerHeight = FlyTableMinHeight;
    }
    return self;
}

@end
