//
//  LCTableViewBlock.m
//  leci
//
//  Created by 熊文博 on 14-7-14.
//  Copyright (c) 2014年 Leci. All rights reserved.
//

#import "LCTableViewBlock.h"

@implementation LCTableViewBlock

- (id)initWithReuseIdentifier:(NSString *)identifier
{
    self = [self init];
    if (self) {
        _reuserIdentifier = identifier;
    }
    return self;
}

@end
