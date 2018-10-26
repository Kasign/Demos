//
//  LCTableView.m
//  leci
//
//  Created by 熊文博 on 14-7-14.
//  Copyright (c) 2014年 Leci. All rights reserved.
//

#import "LCTableView.h"
#import "LCTableViewBlock.h"

@interface LCTableView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *reuseBlocks;

@property (nonatomic, strong) NSMutableDictionary *headerViews;

@property (nonatomic, strong) NSMutableDictionary *footerViews;

@property (nonatomic, assign) CGFloat tableHeaderViewHeight;

@end

@implementation LCTableView

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:_scrollView];
        _reuseBlocks = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:_scrollView];
        _reuseBlocks = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self refreshView];
}

- (void)setAlwaysBounceVertical:(BOOL)alwaysBounceVertical
{
    _scrollView.alwaysBounceVertical = alwaysBounceVertical;
}

- (NSMutableDictionary *)headerViews
{
    if (!_headerViews) {
        _headerViews = [[NSMutableDictionary alloc] init];
    }
    return _headerViews;
}

- (NSMutableDictionary *)footerViews
{
    if (!_footerViews) {
        _footerViews = [NSMutableDictionary dictionary];
    }
    
    return _footerViews;
}

- (void)setTableHeaderView:(UIView *)tableHeaderView
{
    _tableHeaderView = tableHeaderView;
    [_scrollView addSubview:_tableHeaderView];
}

- (void)reCountScrollViewHeight
{
    if (CGRectIsNull(_scrollView.frame))
    {
        return;
    }
    
    if (CGRectIsEmpty(_scrollView.frame)) {
        _scrollView.frame = self.bounds;
    }
    
    if (!_dataSource) {
        return;
    }
    
    // count the
    if (_tableHeaderView) {
        self.tableHeaderViewHeight = CGRectGetHeight(_tableHeaderView.frame);
    }
    
    NSInteger sectionCount = [_dataSource numberOfSectionsIntableView:self];
    CGFloat totalHeight = self.tableHeaderViewHeight;
    for (int i=0; i < sectionCount; i++) {
        NSInteger blocksCount = [_dataSource tableView:self numberOfBlocksForSection:i];
        if (blocksCount == 0) {
            continue;
        }
        
        BOOL hasSectionHeader = NO;
        if ([_dataSource respondsToSelector:@selector(tableView:hasHeaderForSection:)]) {
            hasSectionHeader = [_dataSource tableView:self hasHeaderForSection:i];
        }
        
        if (hasSectionHeader) {
            totalHeight += [_dataSource tableView:self heightOfHeaderForSection:i];
        }
        
        BOOL hasSectionFooter = NO;
        if ([_dataSource respondsToSelector:@selector(tableView:hasFooterForSection:)]) {
            hasSectionFooter = [_dataSource tableView:self hasFooterForSection:i];
        }
        
        if (hasSectionFooter) {
            totalHeight += [_dataSource tableView:self heightOfFooterForSection:i];
        }
        
        NSInteger colums = [_dataSource tableView:self numberOfColumnsForSection:i];
        NSInteger rows   = ceilf(blocksCount/(float)colums);
        
        for (int j=0; j < rows; j++) {
            CGFloat rowHeight = [_dataSource tableView:self heightOfRowAtIndexPath:[NSIndexPath indexPathForRow:j*colums inSection:i]];
            totalHeight += rowHeight;
        }
    }
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame), totalHeight);
}

- (void)refreshView
{
    if (CGRectIsNull(_scrollView.frame))
    {
        return;
    }
    
    if (CGRectIsEmpty(_scrollView.frame)) {
        _scrollView.frame = self.bounds;
    }
    
    if (!_dataSource) {
        return;
    }
    
    // remove cells that are no longer visible
    for(LCTableViewBlock *block in [self blockSubviews])
    {
        // is the cell off the top of the scrollview?
        if (block.frame.origin.y + block.frame.size.height*2 < _scrollView.contentOffset.y)
        {
            [self recycleBlock:block];
        }
        
        // is the cell off the bottom of the scrollview?
        if (block.frame.origin.y > _scrollView.contentOffset.y + _scrollView.frame.size.height + block.frame.size.height)
        {
            [self recycleBlock:block];
        }
    }
    
    // ensure we have a cell for each row
    CGFloat visiableStartY = _scrollView.contentOffset.y;
    CGFloat visiableEndY = _scrollView.contentOffset.y+CGRectGetHeight(_scrollView.frame);
    
    NSInteger sectionCount = [_dataSource numberOfSectionsIntableView:self];
    CGFloat totalHeight = self.tableHeaderViewHeight;
    
    for (int i=0; i<sectionCount; i++) {
        NSInteger blocksCount = [_dataSource tableView:self numberOfBlocksForSection:i];
        if (blocksCount == 0) {
            continue;
        }
        BOOL hasSectionHeader = NO;
        if ([_dataSource respondsToSelector:@selector(tableView:hasHeaderForSection:)]) {
            hasSectionHeader = [_dataSource tableView:self hasHeaderForSection:i];
        }
        
        if (hasSectionHeader) {
            UIView *headerView = [self.headerViews objectForKey:[NSNumber numberWithInt:i]];
            if (!headerView) {
                headerView = [_dataSource tableView:self headerForSection:i];
                [self.headerViews setObject:headerView forKey:[NSNumber numberWithInt:i]];
            }
            UIEdgeInsets headerEdge = [_dataSource tableView:self edgeInsetsOfHeaderForSection:i];
            headerView.frame = CGRectMake(0+headerEdge.left, totalHeight+headerEdge.top, CGRectGetWidth(_scrollView.frame)-headerEdge.left-headerEdge.right, [_dataSource tableView:self heightOfHeaderForSection:i]-headerEdge.top-headerEdge.bottom);
            totalHeight += [_dataSource tableView:self heightOfHeaderForSection:i];
            [_scrollView addSubview:headerView];
        }
        
        NSInteger colums = [_dataSource tableView:self numberOfColumnsForSection:i];
        NSInteger rows = ceilf(blocksCount/(float)colums);
        //CGFloat rowHeight = [_dataSource tableView:self heightOfRowsForSection:i];

        for (int j=0; j<rows; j++) {
            CGFloat rowHeight = [_dataSource tableView:self heightOfRowAtIndexPath:[NSIndexPath indexPathForRow:j*colums inSection:i]];
            if (totalHeight > visiableStartY-rowHeight*2 && totalHeight < visiableEndY+rowHeight) {
                for (int m=0; m<colums; m++) {
                    if (j*colums+m >= blocksCount) {
                        break;
                    }
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j*colums+m inSection:i];
                    LCTableViewBlock *block = [self blockForIndexPath:indexPath];
                    if (!block) {
                        block = [_dataSource tableView:self blockAtIndexPath:indexPath];
                        block.indexPath = indexPath;
                        [block addTarget:self action:@selector(blockPressed:) forControlEvents:UIControlEventTouchUpInside];
                        UIEdgeInsets blockEdge = [_dataSource tableView:self edgeInsetsForBlockAtIndexPath:indexPath];
                        
                        CGFloat blockStartX = ceilf((CGRectGetWidth(_scrollView.frame)/colums)*m)+blockEdge.left;
                        CGFloat blockStartY = totalHeight+blockEdge.top;
                        CGFloat blockWidth = ceilf(CGRectGetWidth(_scrollView.frame)/colums)-blockEdge.left-blockEdge.right;
                        CGFloat blockHeight = ceilf(rowHeight-blockEdge.top-blockEdge.bottom);
                        CGRect rect = CGRectMake(0, 0, blockWidth, blockHeight);
                        if (!CGRectEqualToRect(block.bounds, rect)) {
                            block.bounds = rect;
                        }
                        block.center = CGPointMake(ceilf(blockStartX+blockWidth/2.0), ceilf(blockStartY+blockHeight/2.0));
                        [_scrollView insertSubview:block atIndex:0];
                    }
                }
            }
            totalHeight += rowHeight;
        }
        
        BOOL hasSectionFooter = NO;
        if ([_dataSource respondsToSelector:@selector(tableView:hasFooterForSection:)]) {
            hasSectionFooter = [_dataSource tableView:self hasFooterForSection:i];
        }
        
        if (hasSectionFooter) {
            UIView *footerView = [self.footerViews objectForKey:[NSNumber numberWithInt:i]];
            if (!footerView) {
                footerView = [_dataSource tableView:self FooterForSection:i];
                [self.footerViews setObject:footerView forKey:[NSNumber numberWithInt:i]];
            }
            UIEdgeInsets footerEdge = [_dataSource tableView:self edgeInsetsOfFooterForSection:i];
            footerView.frame = CGRectMake(0+footerEdge.left, 10+totalHeight+footerEdge.top, CGRectGetWidth(_scrollView.frame)-footerEdge.left-footerEdge.right, [_dataSource tableView:self heightOfFooterForSection:i]-footerEdge.top-footerEdge.bottom);
            totalHeight += [_dataSource tableView:self heightOfFooterForSection:i];
            [_scrollView addSubview:footerView];
        }
        else
        {
            UIView *footerView = [self.footerViews objectForKey:[NSNumber numberWithInt:i]];
            if (footerView) {
                totalHeight -= [_dataSource tableView:self heightOfFooterForSection:i];
                [self.footerViews removeObjectForKey:[NSNumber numberWithInt:i]];
                [footerView removeFromSuperview];
            }
        }
        
        if (totalHeight > visiableEndY) {
            break;
        }
    }
}


- (LCTableViewBlock *)blockForIndexPath:(NSIndexPath *)indexPath
{
    for(LCTableViewBlock *block in [self blockSubviews])
    {
        if (block.indexPath.section == indexPath.section && block.indexPath.row == indexPath.row) {
            return block;
        }
    }
    return nil;
}

#pragma mark
- (void)recycleBlock:(LCTableViewBlock *)block
{
    if (block) {
        NSMutableSet *reuseSet = [_reuseBlocks objectForKey:block.reuserIdentifier];
        if (reuseSet) {
            [reuseSet addObject:block];
        }else{
            reuseSet = [[NSMutableSet alloc] init];
            [reuseSet addObject:block];
            [_reuseBlocks setObject:reuseSet forKey:block.reuserIdentifier];
        }
        [block removeFromSuperview];
    }
}

- (LCTableViewBlock *)dequeueReusableBlockWithIdentifier:(NSString *)identifier
{
    NSMutableSet *reuseSet = [_reuseBlocks objectForKey:identifier];
    if (reuseSet) {
        LCTableViewBlock *block = [reuseSet anyObject];
        if (block) {
            [reuseSet removeObject:block];
            return block;
        }
    }

    return nil;
}

-(void)reloadData
{
    // remove all subviews
    [[self blockSubviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self reCountScrollViewHeight];
    [self refreshView];
    
}

-(NSArray*)blockSubviews
{
    NSMutableArray *blocks = [[NSMutableArray alloc] init];
    for(UIView *subView in _scrollView.subviews)
    {
        if ([subView isKindOfClass:[LCTableViewBlock class]]) {
            [blocks addObject:subView];   
        }
    }
    return blocks;
}

#pragma mark - action

- (void)blockPressed:(id)sender
{
    LCTableViewBlock *block = (LCTableViewBlock *)sender;
    
    if (_delegate && [_delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [_delegate tableView:self didSelectRowAtIndexPath:block.indexPath];
    }
}

#pragma mark - UIScrollViewDelegate handlers

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self refreshView];
    
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]){
        [self.delegate scrollViewDidScroll:scrollView];
    }
    
}

#pragma mark - UIScrollViewDelegate forwarding

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([self.delegate respondsToSelector:aSelector]) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
}


- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([self.delegate respondsToSelector:aSelector]) {
        return self.delegate;
    }
    return [super forwardingTargetForSelector:aSelector];
}

@end
