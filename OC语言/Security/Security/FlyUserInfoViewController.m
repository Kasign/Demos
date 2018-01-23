//
//  FlyUserInfoViewController.m
//  Security
//
//  Created by walg on 2017/1/4.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "FlyUserInfoViewController.h"

#import "FlyUserInfoTableViewCell.h"

@interface FlyUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *userTableView;

@end

@implementation FlyUserInfoViewController

static NSString *identifier = @"USERINFO_CELL";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.title = @"个人设置";
    self.backBtnHidden = YES;
    self.navigationBar.titleFont = [UIFont systemFontOfSize:FLYTITLEFONTSIZE];
    
    
    _userTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight,SCREEN_WIDTH, SCREEN_HEIGHT-self.navigationBarHeight) style:UITableViewStyleGrouped];
    _userTableView.backgroundColor = [UIColor clearColor];
    _userTableView.dataSource = self;
    _userTableView.delegate   = self;
    [self.view addSubview:_userTableView];
}

static inline NSArray *cellM()
{
    return @[@"密码解锁",@"指纹解锁",@"退出时自动清空粘贴板"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cellM().count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FlyUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FlyUserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = cellM()[indexPath.row];
    
    switch (indexPath.row) {
        case 0:
            cell.isOn = [[FlyUserSettingManager sharedInstance].passWord boolValue];
            break;
        case 1:
            cell.isOn = [FlyUserSettingManager sharedInstance].useTouchID;
            break;
        case 2:
            cell.isOn = [FlyUserSettingManager sharedInstance].clearPasteboard;
            break;
            
        default:
            break;
    }
    
    cell.clickBlock = ^(BOOL isYes){
        switch (indexPath.row) {
            case 0:
            {
                if (isYes) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"输入密码" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                        textField.secureTextEntry = YES;
                        textField.placeholder = @"密码";
                        [textField setKeyboardType:UIKeyboardTypeNumberPad];
                    }];
                    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [[FlyUserSettingManager sharedInstance] setPassWord:alert.textFields.firstObject.text];
                    }]];
                    [self presentViewController:alert animated:YES completion:nil];
                }else{
                    [[FlyUserSettingManager sharedInstance] setPassWord:nil];
                }
                
            }
                break;
                
            case 1:
                [[FlyUserSettingManager sharedInstance] setUseTouchID:isYes];
                break;
            case 2:
                [[FlyUserSettingManager sharedInstance] setClearPasteboard:isYes];
                break;
                
            default:
                break;
        }
        
    };
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
