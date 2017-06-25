//
//  FlyJokeViewController.m
//  ccw
//
//  Created by Walg on 2017/6/25.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import "FlyJokeViewController.h"
#import "FlyJokeTableViewCell.h"
static NSString *jokeUrl = @"http://api.laifudao.com/open/xiaohua.json";

@interface FlyJokeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation FlyJokeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    _dataSource = [NSMutableArray array];
    self.navigationItem.title = @"笑话";
    [self getData];
    
}
-(void)getData{
    [[FlyHttpManager sharedInstance].manager GET:jokeUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in responseObject) {
                FlyJokeModel *model = [[FlyJokeModel alloc] initWithDic:dic];
                [self.dataSource addObject:model];
            }
            [self.view addSubview:self.tableView];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UILabel *label = [[UILabel alloc]initWithFrame:self.view.bounds];
        [label setText:@"网络请求失败，退出重新加载。。。"];
        [self.view addSubview:label];
    }];
}

-(UITableView *)tableView{
    if (!_tableView) {
        CGRect frame = CGRectMake(0,0, MainWidth, MainHeight);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"jokeCell";
    FlyJokeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[FlyJokeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    FlyJokeModel *model = _dataSource[indexPath.row];
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FlyJokeModel *model = _dataSource[indexPath.row];
    return [FlyJokeTableViewCell heightForCellWithContent:model.content]+60;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
