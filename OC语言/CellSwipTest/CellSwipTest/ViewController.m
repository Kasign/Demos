//
//  ViewController.m
//  CellSwipTest
//
//  Created by walg on 16/7/1.
//  Copyright © 2016年 walg. All rights reserved.
//

#import "ViewController.h"
#import "LCSwipeTableCell.h"
#import "MGSwipeButton.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
}
-(NSArray *) createRightButtons: (int) number
{
    NSMutableArray * result = [NSMutableArray array];
    NSString* titles[2] = {@"Delete", @"More"};
    UIColor * colors[2] = {[UIColor yellowColor], [UIColor lightGrayColor]};
    for (int i = 0; i < number; ++i)
    {
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i] insets:UIEdgeInsetsMake(0, 0, 0, 0)];
//        button.bounds = CGRectMake(0, 0, 150, 0);
//        UIButton *button = [UIButton alloc]initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
        [result addObject:button];
    }
    return result;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"programmaticCell";
     LCSwipeTableCell *cell = [_tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[LCSwipeTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }

    cell.textLabel.text = @(indexPath.row).stringValue;
    
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    cell.rightButtons = [self createRightButtons:2];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
