//
//  ViewController.m
//  算法+链表
//
//  Created by mx-QS on 2019/8/16.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray       *   dataArr;
@property (nonatomic, strong) UITableView   *   tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好的试验田";
    _dataArr = @[@"1.😝", @"2.链表", @"3.排序算法", @"4.锁+多线程", @"5.View控件", @"6.黑科技", @"7.通知", @"8.runtime", @"9.runloop", @"10.重写KVO", @"11.沙盒深入理解", @"12.绘制", @"13.类簇", @"14.Block", @"xxx"];
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
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
    cell.textLabel.text = [_dataArr objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * vcNum = nil;
    switch (indexPath.row) {
        case 0:
            vcNum = @"First";
            break;
        case 1:
            vcNum = @"Second";
            break;
        case 2:
            vcNum = @"Third";
            break;
        case 3:
            vcNum = @"Forth";
            break;
        case 4:
            vcNum = @"Fifth";
            break;
        case 5:
            vcNum = @"Sixth";
            break;
        case 6:
            vcNum = @"Seventh";
            break;
        case 7:
            vcNum = @"Eighth";
            break;
        case 8:
            vcNum = @"Ninth";
            break;
        case 9:
            vcNum = @"Tenth";
            break;
        case 10:
            vcNum = @"Eleventh";
            break;
        case 11:
            vcNum = @"Twelfth";
            break;
        case 12:
            vcNum = @"Thirteen";
            break;
        case 13:
            vcNum = @"Fourteen";
            break;
        case 14:
            vcNum = @"Fifteen";
            break;
        case 15:
            vcNum = @"Sixteen";
            break;
        case 16:
            vcNum = @"Seventeen";
            break;
        case 17:
            vcNum = @"Eighteen";
            break;
        case 18:
            vcNum = @"Nineteen";
            break;
        case 19:
            vcNum = @"Twenty";
            break;
            
        default:
            break;
    }
    
    if (vcNum) {
        NSString * vcName = [NSString stringWithFormat:@"Fly%@Controller", vcNum];
        UIViewController * vc = [[NSClassFromString(vcName) alloc] init];
        if (vc) {
            NSString * name = [_dataArr objectAtIndex:indexPath.row];
            [vc setTitle:[NSString stringWithFormat:@"%@+%@", NSStringFromClass([vc class]), name]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end
