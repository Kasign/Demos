//
//  LCTableView.h
//  leci
//
//  Created by 熊文博 on 14-7-14.
//  Copyright (c) 2014年 Leci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCTableViewDataSource.h"
#import "LCTableViewBlock.h"

@protocol LCTableViewDelegate <NSObject, UIScrollViewDelegate>

@optional
- (void)tableView:(LCTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface LCTableView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, weak) id<LCTableViewDelegate> delegate;

@property (nonatomic, weak) id<LCTableViewDataSource> dataSource;

@property (nonatomic, strong) UIView *tableHeaderView;

@property (nonatomic, assign) BOOL alwaysBounceVertical;

- (LCTableViewBlock *)dequeueReusableBlockWithIdentifier:(NSString *)identifier;

- (void)reloadData;

- (LCTableViewBlock *)blockForIndexPath:(NSIndexPath *)indexPath;

@end
