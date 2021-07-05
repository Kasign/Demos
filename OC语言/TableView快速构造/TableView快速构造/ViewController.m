//
//  ViewController.m
//  TableView快速构造
//
//  Created by Walg on 2021/6/22.
//

#import "ViewController.h"
#import "FlyTableViewModel.h"
#import "FlyTableViewCell.h"

@interface ViewController ()

@property (nonatomic, strong) FlyTableViewModel *tableViewModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableViewModel = [[FlyTableViewModel alloc] initWithConfig:nil tableView:nil];
    _tableViewModel.tableViewConfig.rowHeight = 40;
    _tableViewModel.tableViewConfig.cellClass = [FlyTableViewCell class];
    _tableViewModel.delegateModel.extentDelegate = self;
    
    
    [self.view addSubview:_tableViewModel.tableView];
    _tableViewModel.tableView.frame = self.view.bounds;
    
    [self addDatas];
}

- (void)addDatas {
    
    [_tableViewModel addSetionWithDatas:@[@"123", @"123", @"123"]];
    
    [_tableViewModel addItem:@"123" atSection:0 block:^(FlyTableCellModel * _Nonnull cellModel) {
        cellModel.rowHeight = 50;
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSLog(@" -------->>>>> %f", scrollView.contentOffset.y);
}

@end
