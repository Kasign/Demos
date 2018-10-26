//
//  LCTableViewBlock.h
//  leci
//
//  Created by 熊文博 on 14-7-14.
//  Copyright (c) 2014年 Leci. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCTableViewBlock : UIControl

@property (nonatomic, strong, readonly) NSString *reuserIdentifier;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (id)initWithReuseIdentifier:(NSString *)identifier;

@end
