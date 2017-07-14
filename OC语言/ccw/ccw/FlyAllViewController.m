//
//  FlyAllViewController.m
//  ccw
//
//  Created by walg on 2017/6/21.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import "FlyAllViewController.h"
#import "FlyShowOldViewController.h"
#import "FlyList.h"
#import "FlyHallCell.h"

@interface FlyAllViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSDictionary *dataSource;
@end

@implementation FlyAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.titleName;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    if (self.tag == 2) {
        self.dataSource =  hotList() ;
    }else{
        self.dataSource =  countryList() ;
    }
    
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10.0;
        layout.minimumInteritemSpacing = 0.0;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);

        CGRect frame = self.view.bounds;
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[FlyHallCell class] forCellWithReuseIdentifier:@"ALLCELL"];
    }
    return _collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FlyHallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ALLCELL" forIndexPath:indexPath];

    if (indexPath.row<_dataSource.allKeys.count)
    {
        NSString *key = _dataSource.allKeys[indexPath.row];
        cell.title = _dataSource[key];
        cell.kind = key;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.bounds.size.width/2.0-10, 80);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10,1,10,1);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

   NSString *key = _dataSource.allKeys[indexPath.row];
   NSString *value =_dataSource[key];
    
    
    FlyShowOldViewController *oldVC = [[FlyShowOldViewController alloc] init];
    oldVC.urlStr = key;
    oldVC.showTitle =value;
    if (self.tag == 2) {
        oldVC.isMain = NO;
    }else{
        oldVC.isMain = YES;
    }
    oldVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:oldVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
