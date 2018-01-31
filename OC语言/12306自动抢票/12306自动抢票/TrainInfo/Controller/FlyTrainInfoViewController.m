//
//  FlyTrainInfoViewController.m
//  12306自动抢票
//
//  Created by qiuShan on 2018/1/31.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "FlyTrainInfoViewController.h"
#import "FlyTrainInfoCell.h"
#import "FlyTrainStateModel.h"
#import "FlyCheckTrainResponseObject.h"


static NSString * cellIdentifier = @"trainInfoCellIdentifier";

@interface FlyTrainInfoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView  *  trainCollectionView;
@property (nonatomic, strong) NSMutableArray    *  dataSourceArr;
@end

@implementation FlyTrainInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataSourceArr = [NSMutableArray array];
    [self.view addSubview:self.trainCollectionView];
    [self loadServerData];
}

- (void)loadServerData
{
    [FlyStationManager stationInfoWithServerFromStation:_fromModel toStation:_toModel data:_data block:^(FlyCheckTrainResponseObject *responseObject, NSError *error) {
        if (!error && responseObject) {
            _dataSourceArr = [responseObject.result mutableCopy];
            [self.trainCollectionView reloadData];
        } else {
            NSLog(@"error:%@",error);
        }
    }];
}

- (UICollectionView *)trainCollectionView
{
    if (!_trainCollectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        
        _trainCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        [_trainCollectionView setShowsVerticalScrollIndicator:NO];
        [_trainCollectionView setShowsHorizontalScrollIndicator:NO];
        [_trainCollectionView setDelegate:self];
        [_trainCollectionView setDataSource:self];
        [_trainCollectionView registerClass:[FlyTrainInfoCell class] forCellWithReuseIdentifier:cellIdentifier];
    }
    return _trainCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSourceArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FlyTrainInfoCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row < _dataSourceArr.count) {
         FlyTrainStateModel * model = [_dataSourceArr objectAtIndex:indexPath.row];
        cell.model = model;
    }
   
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
