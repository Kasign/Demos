//
//  FlyLookViewController.m
//  ccw
//
//  Created by walg on 2017/6/22.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import "FlyLookViewController.h"
#import "FlyPhotoEnlargeToolView.h"
#import "FlyLookTableViewCell.h"
static NSString *tupianUrl = @"http://api.laifudao.com/open/tupian.json";
@interface FlyLookViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation FlyLookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"搞笑图";
    self.hidesBottomBarWhenPushed = YES;
    _dataSource = [NSMutableArray array];
    [self getData];
}

-(void)getData{
    [[FlyHttpManager sharedInstance].manager GET:tupianUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    FlyLookTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FlyLookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    FlyJokeModel *model = _dataSource[indexPath.row];
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 290;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
