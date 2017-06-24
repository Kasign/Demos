
//
//  FlyFirstViewController.m
//  ccw
//
//  Created by Walg on 2017/5/20.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import "FlyFirstViewController.h"
#import "DetailViewController.h"

@interface FlyFirstViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation FlyFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"资讯";
    _dataSource = [NSMutableArray array];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    _tableView = tableView;
    [self.view addSubview:_tableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}

-(void)getData{
    self.tableView.allowsSelection = NO;
    self.dataSource = [[FlyDataManager sharedInstance].zixunArray mutableCopy];
    [_tableView reloadData];
    self.tableView.allowsSelection = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.row<_dataSource.count) {
        DataModel *model = _dataSource[indexPath.row];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = model.title;

    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *dv = [[DetailViewController alloc] init];
    dv.object = _dataSource[indexPath.row];
    [self.navigationController pushViewController:dv animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DataModel *model = _dataSource[indexPath.row];

    return [self cellHeightWithStr:model.title]+40;
}

-(CGFloat)cellHeightWithStr:(NSString*)str{
    
    CGFloat height = [str boundingRectWithSize:CGSizeMake(MainWidth-120, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
    
    return height;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
