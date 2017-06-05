//
//  FlyAddNewViewController.m
//  Security
//
//  Created by walg on 2017/1/5.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "FlyDisplayDetailViewController.h"

#import "FlyDetailTableViewCell.h"

#import "FlyDataManager.h"

@interface FlyDisplayDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *addNewTableVIew;

@property (nonatomic, strong) FlyDataModel *addNewModel;

@end

@implementation FlyDisplayDetailViewController

static NSString *identifier = @"DETAIL_CELL";

static NSString *displayIdentifier = @"DISPLAY_CELL";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
    
    [self.view addSubview:self.addNewTableVIew];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    self.navigationBar.titleFont = [UIFont systemFontOfSize:14];
    [self reloadViews];
}

-(void)initViews{
    
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

-(void)reloadViews{
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
            self.navigationBar.title = _model.keyString;
            [self.popBackBtn setTitle:@"返回" forState:UIControlStateNormal];
            [self.navigationBar.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
            [self.navigationBar.rightBtn addTarget:self action:@selector(editClickAction) forControlEvents:UIControlEventTouchUpInside];
            break;
    }
}


-(UITableView *)addNewTableVIew{
    if (!_addNewTableVIew) {
        _addNewTableVIew = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-self.navigationBarHeight) style:UITableViewStyleGrouped];
        _addNewTableVIew.dataSource = self;
        _addNewTableVIew.delegate = self;
        _addNewTableVIew.backgroundColor = [UIColor clearColor];
    }
    return _addNewTableVIew;
}

-(void)confirmClickAction
{
    if (_type == FlyAddNewType)
    {
          [[FlyDataManager sharedInstance] saveDataWithModel:_addNewModel];
    }
    else if (_type == FlyEditOldType)
    {
          [[FlyDataManager sharedInstance] updateDataWithModel:_addNewModel];
    }

    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)editClickAction
{
    _type = FlyEditOldType;
    [self reloadViews];
    [self.addNewTableVIew reloadData];
}

static inline NSArray *editCellM(){
    return @[@"用户名",@"密码",@"注释"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (_type)
    {
            
        case FlyAddNewType:
            return editCellM().count;
            
        case FlyEditOldType:
            return _model.keyArray.count;
            
        case FlyDisplayType:
            return _model.keyArray.count;
            
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (_type) {
        case FlyAddNewType:
        {
            FlyDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[FlyDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.leftString = editCellM()[indexPath.row];
            cell.leftField.delegate = self;
            cell.rightField.delegate = self;
            return cell;
        }
        case FlyEditOldType:
        {
            FlyDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[FlyDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.leftString = self.model.keyArray[indexPath.row];
            cell.rightString = self.model.valueArray[indexPath.row];
            cell.leftField.delegate = self;
            cell.rightField.delegate = self;
            return cell;
        }
        case FlyDisplayType:
        {
            FlyDisPlayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:displayIdentifier];
            if (!cell) {
                cell = [[FlyDisPlayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:displayIdentifier];
            }
            cell.leftString = self.model.keyArray[indexPath.row];
            cell.rightString = self.model.valueArray[indexPath.row];
            return cell;
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    switch (_type)
    {
        case FlyAddNewType:
            
            NSLog(@"%@",textField.text);
            
            break;
            
        case FlyEditOldType:
            
             NSLog(@"%@",textField.text);
            
            break;
            
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
