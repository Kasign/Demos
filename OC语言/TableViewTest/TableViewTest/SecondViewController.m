//
//  SecondViewController.m
//  TableViewTest
//
//  Created by Walg on 2017/9/26.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import "SecondViewController.h"
#import "FlyTableViewCell.h"
@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataSourceArr;
@property (nonatomic,strong) NSMutableArray *dataSourceArr2;

@property (nonatomic,strong)UITableView * tableView;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSourceArr = @[@"12",@"12",@"12",@"12",@"12",@"12",@"12",@"12",@"12",@"12",@"12"].mutableCopy;
    _dataSourceArr2 = @[@"12",@"12",@"12",@"12",@"12",@"12",@"12",@"12",@"12",@"12",@"12"].mutableCopy;

    
    
    [self.view addSubview:self.tableView];
    
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _dataSourceArr.count;
    }
    return _dataSourceArr2.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FlyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[FlyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    __weak typeof(self) weakSelf = self;
    [cell setDeleBlock:^(FlyTableViewCell *scell) {
        
        
        
        [weakSelf deleteCellWithIndexPath:scell];
    }];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 199;
}


-(void)deleteCellWithIndexPath:(FlyTableViewCell*)cell{
    
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath.section == 0) {
        [_dataSourceArr removeObjectAtIndex:indexPath.row];
    }else{
        [_dataSourceArr2 removeObjectAtIndex:indexPath.row];
    }
    
    if (indexPath.section == 0) {
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        
    }else{
//        [self.tableView beginUpdates];
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [self.tableView endUpdates];

        CGPoint point = cell.center;
        CGPoint oldOffset = self.tableView.contentOffset;
        NSLog(@"原始y:%f",oldOffset.y);
        
        [UIView animateWithDuration:0.4 animations:^{
            [cell setCenter:CGPointMake(point.x - 337, point.y)];

        } completion:^(BOOL finished) {

            [UIView performWithoutAnimation:^{
                [self.tableView reloadData];
                
                CGFloat newY = self.tableView.contentSize.height;
                CGPoint  newContentOff = self.tableView.contentOffset;
                if (oldOffset.y<newY) {
                    newY = oldOffset.y;
                }
                [self.tableView setContentOffset:CGPointMake(oldOffset.x, newY)];
                NSLog(@"新的y:%f",newContentOff.y);

            }];

        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
