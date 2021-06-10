//
//  ViewController.m
//  FlyImageDecode
//
//  Created by Walg on 2021/5/9.
//

#import "ViewController.h"
#import "DecodeViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = self.view.bounds;
    _dataArr = [NSMutableArray array];
    [_dataArr addObject:@"ContentsOfFile"];
    [_dataArr addObject:@"Graphics"];
    [_dataArr addObject:@"CGBitmapContext"];
    [_dataArr addObject:@"ImageIO"];
    [_dataArr addObject:@"CIImage"];
    [_dataArr addObject:@"vImage"];
    
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.rowHeight = 44;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tableView;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", _dataArr[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DecodeViewController * vc = [[DecodeViewController alloc] init];
    vc.type = indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
