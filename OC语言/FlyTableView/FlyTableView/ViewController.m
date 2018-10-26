//
//  ViewController.m
//  FlyTableView
//
//  Created by 66-admin-qs. on 2018/10/9.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "ViewController.h"
#import "LCTableView.h"

@interface ViewController ()<LCTableViewDelegate,LCTableViewDataSource>
@property (nonatomic, strong) LCTableView   *   tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (LCTableView *)tableView {
    
    if (!_tableView) {
        CGFloat width  = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        _tableView = [[LCTableView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setBackgroundColor:[UIColor redColor]];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsIntableView:(LCTableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(LCTableView *)tableView numberOfBlocksForSection:(NSInteger)section {
    
    return 20;
}

- (NSInteger)tableView:(LCTableView *)tableView numberOfColumnsForSection:(NSInteger)section {

    return 1;
}

- (CGFloat)tableView:(LCTableView *)tableView heightOfRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.f;
}

- (UIEdgeInsets)tableView:(LCTableView *)tableView edgeInsetsForBlockAtIndexPath:(NSIndexPath *)indexPath {
    
    return UIEdgeInsetsZero;
}

- (LCTableViewBlock *)tableView:(LCTableView *)tableView blockAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * identifier = @"abcdefg";
    LCTableViewBlock * block = [tableView dequeueReusableBlockWithIdentifier:identifier];
    if (!block) {
        block = [[LCTableViewBlock alloc] initWithReuseIdentifier:identifier];
//        [block setBackgroundColor:[UIColor blueColor]];
    }
    
    UILabel * label = [block viewWithTag:20180909];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:block.bounds];
        [label setBackgroundColor:[UIColor cyanColor]];
        [label setTextColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTag:20180909];
        [block addSubview:label];
    }
    [label setFrame:block.bounds];
    [label setText:[NSString stringWithFormat:@"%ld - %ld",(long)indexPath.section,(long)indexPath.row]];
    
    return block;
}

@end
