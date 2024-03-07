//
//  ViewController.m
//  算法+链表
//
//  Created by mx-QS on 2019/8/16.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "ViewController.h"
#import "FlyCellModel.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"试验田";
    self.dataArr = [NSMutableArray array];
    int i = 0;
    while (1) {
        FlyCellModel *cellModel = [FlyCellModel instanceWithIndex:i];
        if (cellModel) {
            [self.dataArr addObject:cellModel];
            i++;
        } else {
            break;
        }
    }
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"xxx"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"xxx"];
    }
    FlyCellModel *cellModel = [_dataArr objectAtIndex:indexPath.row];
    cell.textLabel.text = [cellModel cellTitle];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FlyCellModel *cellModel = [_dataArr objectAtIndex:indexPath.row];
    if (cellModel.vcClass) {
        UIViewController *vc = [[cellModel.vcClass alloc] init];
        if (vc) {
            [vc setTitle:[NSString stringWithFormat:@"%@", cellModel.vcTitle]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end
