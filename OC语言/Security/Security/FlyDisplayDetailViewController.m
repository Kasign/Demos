//
//  FlyAddNewViewController.m
//  Security
//
//  Created by walg on 2017/1/5.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "FlyDisplayDetailViewController.h"

#import "FlyDetailTableViewCell.h"
#import "FlyDataModel.h"
#import "FlyDataManager.h"

static int basicTag = 10086;

@interface FlyDisplayDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *addNewTableVIew;

@property (nonatomic, strong) FlyDataModel *addNewModel;

@property (nonatomic, strong) NSMutableDictionary *addNewDic;

@end

@implementation FlyDisplayDetailViewController

static NSString *identifier = @"DETAIL_CELL";
static NSString *displayIdentifier = @"DISPLAY_CELL";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initViews];
    
    [self.view addSubview:self.addNewTableVIew];
    self.navigationBar.titleFont = [UIFont systemFontOfSize:FLYTITLEFONTSIZE];
}

-(void)initDatas
{
    if (!_model) {
        _model = [[FlyDataModel alloc] init];
        _addNewDic = [NSMutableDictionary dictionary];
    }else{
        _addNewDic = [_model.valueDic mutableCopy];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self initDatas];
    [self reloadViews];
}

-(void)initViews
{
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.bounds = CGRectMake(0, 0, 60, 60);
    leftBtn.backgroundColor = [UIColor clearColor];
    
    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [leftBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    self.popBackBtn = leftBtn;
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.bounds = CGRectMake(0, 0, 60, 60);
    rightBtn.backgroundColor = [UIColor clearColor];
    
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    self.navigationBar.rightBtn = rightBtn;
    
    [self reloadViews];
}

-(void)reloadViews
{
    [self.navigationBar.rightBtn removeTarget:self action:@selector(confirmClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar.rightBtn removeTarget:self action:@selector(editClickAction) forControlEvents:UIControlEventTouchUpInside];
    switch (_type) {
        case FlyAddNewType:
            self.navigationBar.title = @"添加";
            [self.popBackBtn setTitle:@"取消" forState:UIControlStateNormal];
            [self.navigationBar.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
            [self.navigationBar.rightBtn addTarget:self action:@selector(confirmClickAction) forControlEvents:UIControlEventTouchUpInside];
            break;
        case FlyEditOldType:
            self.navigationBar.title = @"编辑";
            [self.popBackBtn setTitle:@"返回" forState:UIControlStateNormal];
            [self.navigationBar.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
            [self.navigationBar.rightBtn addTarget:self action:@selector(confirmClickAction) forControlEvents:UIControlEventTouchUpInside];
            break;
        case FlyDisplayType:
            self.navigationBar.title = @"";
            [self.popBackBtn setTitle:@"返回" forState:UIControlStateNormal];
            [self.navigationBar.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
            [self.navigationBar.rightBtn addTarget:self action:@selector(editClickAction) forControlEvents:UIControlEventTouchUpInside];
            break;
    }
}


-(UITableView *)addNewTableVIew
{
    if (!_addNewTableVIew) {
        _addNewTableVIew = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-self.navigationBarHeight) style:UITableViewStyleGrouped];
        [_addNewTableVIew setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];
        _addNewTableVIew.dataSource = self;
        _addNewTableVIew.delegate = self;
        _addNewTableVIew.backgroundColor = [UIColor clearColor];
    }
    return _addNewTableVIew;
}


-(void)editClickAction
{
    _type = FlyEditOldType;
    [self reloadViews];
    [self.addNewTableVIew reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (_type) {
        case FlyAddNewType:
            return 6;
            break;
            
        default:
            return self.model.keyDic.allKeys.count-1;
            break;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger cellTag = indexPath.row + basicTag + 1;
    switch (_type) {
        case FlyAddNewType:
        {
            FlyDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[FlyDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            NSString *key = keyArray()[indexPath.row+1];
            if ([key isEqualToString:@"creatTime"]||[key isEqualToString:@"updateTime"]) {
                cell.rightField.enabled = NO;
            }
            cell.leftString = [self.model.keyDic objectForKey:key];
            [cell.rightField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            cell.tag = cellTag;
            return cell;
        }
        case FlyEditOldType:
        {
            FlyDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[FlyDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            NSString *key = keyArray()[indexPath.row+1];
            if ([key isEqualToString:@"creatTime"]||[key isEqualToString:@"updateTime"]) {
                cell.rightField.enabled = NO;
            }
            cell.leftString  = [self.model.keyDic objectForKey:key];
            cell.rightString = [self.model.valueDic objectForKey:key];
            [cell.rightField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            cell.tag = cellTag;
            return cell;
        }
        case FlyDisplayType:
        {
            FlyDisPlayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:displayIdentifier];
            if (!cell) {
                cell = [[FlyDisPlayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:displayIdentifier];
            }
            
            NSString *key = keyArray()[indexPath.row+1];
            cell.leftString = [self.model.keyDic objectForKey:key];
            cell.rightString = [self.model.valueDic objectForKey:key];
            cell.tag = cellTag;
            
            return cell;
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *keyType = keyArray()[0];
    NSString *value;
    for (NSString * key in self.model.valueDic.allKeys) {
        if ([key isEqualToString:keyType]) {
            value = [self.model.valueDic objectForKey:key];
        }
    }
    
    UILabel * headerView = (UILabel*)tableView.tableHeaderView;
    if (!headerView) {
        headerView = [[UILabel alloc] init];
    }
    if (_type == FlyAddNewType) {
        [headerView setText:_itemName];
    }else{
        [headerView setText:value];
    }
    [headerView setTextAlignment:NSTextAlignmentCenter];
    [_addNewDic setObject:headerView.text forKey:keyType];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    NSInteger tag = textField.tag - basicTag;
    NSString *key = keyArray()[tag];
    switch (_type)
    {
        case FlyAddNewType:
            [_addNewDic setObject:textField.text forKey:key];
            
            break;
            
        case FlyEditOldType:
            [_addNewDic setObject:textField.text forKey:key];
            
            break;
            
        default:
            break;
    }
    
}

-(void)confirmClickAction
{
    
    if (_type == FlyAddNewType)
    {
        _addNewModel = [[FlyDataModel alloc] initWithDataDic:_addNewDic];
        [[FlyDataManager sharedInstance] saveDataWithModel:_addNewModel];
    }
    else if (_type == FlyEditOldType)
    {
        _addNewModel = [[FlyDataModel alloc] initWithDataDic:_addNewDic];
        [[FlyDataManager sharedInstance] updateDataWithModel:_addNewModel];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

static NSArray *keyArray(){
    return @[@"dataType",@"userName",@"security",@"note",@"detail1",@"detail2",@"detail3",@"creatTime",@"updateTime"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
