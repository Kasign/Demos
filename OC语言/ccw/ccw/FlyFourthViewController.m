//
//  FlyFourthViewController.m
//  ccw
//
//  Created by Walg on 2017/6/7.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import "FlyFourthViewController.h"
#import "FlySecurityView.h"

@interface FlyFourthViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIButton *addButton;
@property (nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation FlyFourthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的彩票";
    _dataSource = [NSMutableArray arrayWithContentsOfFile:path()];
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addButton];
    
    FlySecurityView *securityView = [[FlySecurityView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight-49)];
    [securityView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:securityView];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"warn"] style:UIBarButtonItemStylePlain target:self action:@selector(helpAction)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
}

-(void)helpAction{
    NSString *message = @"我的彩票：\n购买彩票时可点击下方“添加购彩信息”按钮，把彩票信息输入到我的彩票里，不用随时携带彩票亦可随时查看中奖信息，以免丢失，造成财产损失！";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"帮助" message:message preferredStyle:UIAlertControllerStyleAlert];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 2;
    paraStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary *attri = @{
                            NSParagraphStyleAttributeName:paraStyle,
                            NSForegroundColorAttributeName:[UIColor blackColor],
                            NSFontAttributeName:[UIFont systemFontOfSize:12]
                            };
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:message attributes:attri];
     [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(17, 6)];
    [alert setValue:attributedString forKey:@"attributedMessage"];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}

NSString *path(){
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePath =[docDir stringByAppendingPathComponent:@"zip.abc"];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!isExist) {
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
        NSArray *arr = @[@{@"000000":@"12345678"}];
        [arr writeToFile:filePath atomically:YES];
    }
    return filePath;
}

-(UIButton *)addButton{
    if (!_addButton) {
        _addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, MainHeight-100, MainWidth, 40)];
        [_addButton setBackgroundColor:[UIColor redColor]];
        [_addButton setTitle:@"添加购彩信息" forState:UIControlStateNormal];
        [_addButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_addButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addNewMessage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight-110) style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
    }
    return _tableView;
}

-(void)addNewMessage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加购彩信息" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"添加购彩期"];
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"添加购彩数字"];
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *key = alert.textFields.firstObject.text;
        NSString *value = alert.textFields.lastObject.text;
        NSDictionary *dic = @{key:value};
        [self.dataSource addObject:dic];
        if ([self.dataSource writeToFile:path() atomically:YES]) {
            [self.tableView reloadData];
        }
    }];
    [alert addAction:confirm];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    if (indexPath.row<self.dataSource.count) {
        NSDictionary *dic = self.dataSource[indexPath.row];
        [cell.textLabel setText:[NSString stringWithFormat:@"第%@期",dic.allKeys.firstObject]];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"购彩码：%@",dic.allValues.firstObject]];
    }
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
