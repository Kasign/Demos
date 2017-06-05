//
//  FlyHomeViewController.m
//  Security
//
//  Created by walg on 2017/1/4.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "FlyHomeViewController.h"

#import "FlyHomeTableViewCell.h"

#import "FlyDisplayDetailViewController.h"

#import "FlyDataManager.h"

@interface FlyHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *homeTableView;

@property (nonatomic, strong) NSMutableArray *homeListArray;


@end

@implementation FlyHomeViewController

static NSString *identifier = @"HOME_CELL";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationBar.title = @"主页";
    
    self.backBtnHidden = YES;
    
    self.navigationBar.titleFont = [UIFont systemFontOfSize:14];
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.backgroundColor = [UIColor clearColor];
    rightBtn.bounds = CGRectMake(0, 0, 40, 40);
    [rightBtn setTitle:@"添加" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [rightBtn addTarget:self action:@selector(addNewItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.rightBtn = rightBtn;
    
    _homeListArray = [NSMutableArray array];
    
    [self.view addSubview:self.homeTableView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

-(void)loadData{
     _homeListArray = [[[FlyDataManager sharedInstance] readData] copy];
}

-(void)addNewItemAction{
    
    FlyDisplayDetailViewController *addNewVC = [[FlyDisplayDetailViewController alloc] init];
    addNewVC.hidesBottomBarWhenPushed = YES;
    addNewVC.type = FlyAddNewType;
    [self.navigationController pushViewController:addNewVC animated:YES];
    
}

-(UITableView *)homeTableView{
    if (!_homeTableView) {
        _homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-self.navigationBarHeight) style:UITableViewStylePlain];
        _homeTableView.backgroundColor = [UIColor clearColor];
        _homeTableView.dataSource = self;
        _homeTableView.delegate = self;
    }
    return _homeTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _homeListArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FlyHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[FlyHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    FlyDataModel *model =_homeListArray[indexPath.row];
    cell.title = model.keyString;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FlyDisplayDetailViewController *vc = [[FlyDisplayDetailViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.model =_homeListArray[indexPath.row];
    vc.type = FlyDisplayType;
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction *deleAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [tableView setEditing:NO animated:YES];
        [_homeListArray removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
        
    }];
    
    return @[deleAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
