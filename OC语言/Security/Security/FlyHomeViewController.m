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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.title = @"主页";
    
    self.backBtnHidden = YES;
    
    self.navigationBar.titleFont = [UIFont systemFontOfSize:FLYTITLEFONTSIZE];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

-(void)loadData
{
     _homeListArray = [[[FlyDataManager sharedInstance] readData] mutableCopy];
    [self.homeTableView reloadData];
}

-(void)addNewItemAction
{
    NSString * placeholderStr = @"必须输入，否则不能添加";
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"输入账号平台" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = placeholderStr;
    }];
    
    UIAlertAction * concelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    __block typeof(self) weakSelf = self;
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
        UITextField * textFiled = alertController.textFields.lastObject;
        if (textFiled.text.length && ![textFiled.text isEqualToString:placeholderStr]) {
            [weakSelf pushToDisPalyViewControllerWithName:textFiled.text];
        }
    }];
    
    [alertController addAction:concelAction];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)pushToDisPalyViewControllerWithName:(NSString *)name
{
    FlyDisplayDetailViewController *addNewVC = [[FlyDisplayDetailViewController alloc] init];
    addNewVC.hidesBottomBarWhenPushed = YES;
    addNewVC.type = FlyAddNewType;
    addNewVC.itemName = name;
    [self.navigationController pushViewController:addNewVC animated:YES];
}

-(UITableView *)homeTableView
{
    if (!_homeTableView) {
        _homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-self.navigationBarHeight) style:UITableViewStyleGrouped];
        _homeTableView.backgroundColor = [UIColor clearColor];
        _homeTableView.dataSource = self;
        _homeTableView.delegate   = self;
        [_homeTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    }
    return _homeTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _homeListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FlyHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[FlyHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    FlyDataModel *model =_homeListArray[indexPath.row];
    cell.title = model.dataType;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FlyDataModel *model =_homeListArray[indexPath.row];
    FlyDisplayDetailViewController *vc = [[FlyDisplayDetailViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.model = model;
    vc.type = FlyDisplayType;
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __block typeof(self) weakSelf = self;
    UITableViewRowAction *deleAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        FlyDataModel *model =weakSelf.homeListArray[indexPath.row];
        [weakSelf.homeListArray removeObject:model];
        [[FlyDataManager sharedInstance] deleDataWithModel:model];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [weakSelf loadData];
        
    }];
    
    return @[deleAction];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = tableView.tableHeaderView;
    if (!headerView) {
        headerView = [UIView new];
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerView = tableView.tableFooterView;
    if (!footerView) {
        footerView = [UIView new];
    }
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2.5f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 14.f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
