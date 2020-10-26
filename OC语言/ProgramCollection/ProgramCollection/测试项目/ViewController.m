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
    
<<<<<<< HEAD:OC语言/ProgramCollection/ProgramCollection/测试项目/ViewController.m
    self.title = @"好的试验田";
    
    _dataArr = @[@"1、没想好", @"2、链表", @"3、排序算法", @"4、锁+多线程", @"5、View控件", @"6、黑科技", @"7、通知", @"8、runtime", @"9、runloop", @"10、重写KVO", @"11、沙盒深入理解", @"12、绘制", @"13、xxx"];
=======
    _dataArr = @[@"2.链表", @"3.排序算法", @"4.锁+多线程", @"5.View控件", @"6.黑科技", @"7.通知", @"8.runtime", @"9.runloop", @"10.重写KVO", @"11.沙盒深入理解", @"12.绘制", @"13.类簇", @"xxx"];
>>>>>>> 31487c6d001dca71565ff2b8ee40d7e85707b544:OC语言/多种测试代码合集/算法+链表/ViewController.m
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

<<<<<<< HEAD:OC语言/ProgramCollection/ProgramCollection/测试项目/ViewController.m
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
=======
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
>>>>>>> 31487c6d001dca71565ff2b8ee40d7e85707b544:OC语言/多种测试代码合集/算法+链表/ViewController.m
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

<<<<<<< HEAD:OC语言/ProgramCollection/ProgramCollection/测试项目/ViewController.m
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIViewController * vc = nil;
    switch (indexPath.row) {
        case 0:
            vc = [[NSClassFromString(@"FlyFirstController") alloc] init];
            break;
        case 1:
            vc = [[NSClassFromString(@"FlySecondController") alloc] init];
            break;
        case 2:
            vc = [[NSClassFromString(@"FlyThirdController") alloc] init];
            break;
        case 3:
            vc = [[NSClassFromString(@"FlyForthController") alloc] init];
            break;
        case 4:
            vc = [[NSClassFromString(@"FlyFifthController") alloc] init];
            break;
        case 5:
            vc = [[NSClassFromString(@"FlySixthController") alloc] init];
            break;
        case 6:
            vc = [[NSClassFromString(@"FlySeventhController") alloc] init];
            break;
        case 7:
            vc = [[NSClassFromString(@"FlyEighthController") alloc] init];
            break;
        case 8:
            vc = [[NSClassFromString(@"FlyNinthController") alloc] init];
            break;
        case 9:
            vc = [[NSClassFromString(@"FlyTenthController") alloc] init];
            break;
        case 10:
            vc = [[NSClassFromString(@"FlyEleventhController") alloc] init];
            break;
        case 11:
            vc = [[NSClassFromString(@"FlyTwelfthViewController") alloc] init];
=======
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * vcNum = nil;
    switch (indexPath.row) {
        case 0:
            vcNum = @"Second";
            break;
        case 1:
            vcNum = @"Third";
            break;
        case 2:
            vcNum = @"Forth";
            break;
        case 3:
            vcNum = @"Fifth";
            break;
        case 4:
            vcNum = @"Sixth";
            break;
        case 5:
            vcNum = @"Seventh";
            break;
        case 6:
            vcNum = @"Eighth";
            break;
        case 7:
            vcNum = @"Ninth";
            break;
        case 8:
            vcNum = @"Tenth";
            break;
        case 9:
            vcNum = @"Eleventh";
            break;
        case 10:
            vcNum = @"Twelfth";
            break;
        case 11:
            vcNum = @"Thirteen";
            break;
        case 12:
            vcNum = @"Fourteen";
            break;
        case 13:
            vcNum = @"Fifteen";
>>>>>>> 31487c6d001dca71565ff2b8ee40d7e85707b544:OC语言/多种测试代码合集/算法+链表/ViewController.m
            break;
        case 14:
            vcNum = @"Fifteen";
            break;
        case 15:
            vcNum = @"Fifteen";
            break;
        case 16:
            vcNum = @"Sixteen";
            break;
        case 17:
            vcNum = @"Seventeen";
            break;
        case 18:
            vcNum = @"Eighteen";
            break;
            
        default:
            break;
    }
<<<<<<< HEAD:OC语言/ProgramCollection/ProgramCollection/测试项目/ViewController.m
    
    if (vc) {
        NSString * name = [_dataArr objectAtIndex:indexPath.row];
        [vc setTitle:[NSString stringWithFormat:@"%@+%@", name, NSStringFromClass([vc class])]];
        [self.navigationController pushViewController:vc animated:YES];
=======
    if (vcNum) {
        NSString * vcName = [NSString stringWithFormat:@"Fly%@Controller", vcNum];
        UIViewController * vc = [[NSClassFromString(vcName) alloc] init];
        if (vc) {
            NSString * name = [_dataArr objectAtIndex:indexPath.row];
            [vc setTitle:[NSString stringWithFormat:@"%@+%@", NSStringFromClass([vc class]), name]];
            [self.navigationController pushViewController:vc animated:YES];
        }
>>>>>>> 31487c6d001dca71565ff2b8ee40d7e85707b544:OC语言/多种测试代码合集/算法+链表/ViewController.m
    }
}

@end
