//
//  LCTableViewDataSource.h
//  leci
//
//  Created by 熊文博 on 14-7-14.
//  Copyright (c) 2014年 Leci. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LCTableViewBlock;
@class LCTableView;

@protocol LCTableViewDataSource <NSObject>

@required

- (NSInteger)numberOfSectionsIntableView:(LCTableView *)tableView;

- (NSInteger)tableView:(LCTableView *)tableView numberOfBlocksForSection:(NSInteger)section;

- (NSInteger)tableView:(LCTableView *)tableView numberOfColumnsForSection:(NSInteger)section;

- (CGFloat)tableView:(LCTableView *)tableView heightOfRowAtIndexPath:(NSIndexPath *)indexPath;

- (UIEdgeInsets)tableView:(LCTableView *)tableView edgeInsetsForBlockAtIndexPath:(NSIndexPath *)indexPath;

- (LCTableViewBlock *)tableView:(LCTableView *)tableView blockAtIndexPath:(NSIndexPath *)indexPath;


@optional

- (BOOL)tableView:(LCTableView *)tableView hasHeaderForSection:(NSInteger)section;

- (CGFloat)tableView:(LCTableView *)tableView heightOfHeaderForSection:(NSInteger)section;

- (UIEdgeInsets)tableView:(LCTableView *)tableView edgeInsetsOfHeaderForSection:(NSInteger)section;

- (UIView *)tableView:(LCTableView *)tableView headerForSection:(NSInteger)section;

- (BOOL)tableView:(LCTableView *)tableView hasFooterForSection:(NSInteger)section;

- (CGFloat)tableView:(LCTableView *)tableView heightOfFooterForSection:(NSInteger)section;

- (UIEdgeInsets)tableView:(LCTableView *)tableView edgeInsetsOfFooterForSection:(NSInteger)section;

- (UIView *)tableView:(LCTableView *)tableView FooterForSection:(NSInteger)section;

@end
