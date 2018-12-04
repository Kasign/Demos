//
//  ViewController.m
//  DiyCollectionView
//
//  Created by 66-admin-qs. on 2018/11/29.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "ViewController.h"
#import "FlyCollectionView.h"

static NSString * kIdentifier_CELL = @"kIdentifier_CELL";
static NSString * kIdentifier_HEADER = @"kIdentifier_HEADER";
static NSString * kIdentifier_FOOTER = @"kIdentifier_FOOTER";

@interface ViewController ()<FlyCollectionViewDelegate, FlyCollectionViewDataSource, FlyCollectionViewLayoutDelegate>

@property (nonatomic, strong) FlyCollectionView   *   collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
}

- (FlyCollectionView *)collectionView
{
    if (!_collectionView) {
        FlyCollectionViewLayout * layout = [[FlyCollectionViewLayout alloc] init];
        layout.itemSize = CGSizeMake(375.f, 100.f);
        layout.minimumLineSpacing = 10.f;
        layout.minimumInteritemSpacing = 10.f;
        
        _collectionView = [[FlyCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        [_collectionView registerClass:[FlyCollectionReusableView class] forCellWithReuseIdentifier:kIdentifier_CELL];
        [_collectionView registerClass:[FlyCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kIdentifier_HEADER];
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        [_collectionView setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.3]];
    }
    return _collectionView;
}

- (NSInteger)flyCollectionView:(FlyCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 30;
}

- (__kindof FlyCollectionReusableView *)flyCollectionView:(FlyCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FlyCollectionReusableView * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kIdentifier_CELL forIndexPath:indexPath];
    
    UILabel * label = [cell viewWithTag:20191919];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5.f, CGRectGetWidth(cell.frame), CGRectGetHeight(cell.frame) - 10.f)];
        [label setTag:20191919];
        [label setTextColor:[UIColor blackColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:[[UIColor cyanColor] colorWithAlphaComponent:0.3]];
        [cell addSubview:label];
    }
    [label setText:[NSString stringWithFormat:@"%@ - %p",@(indexPath.row),cell]];
    return cell;
}

- (FlyCollectionReusableView *)flyCollectionView:(FlyCollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    FlyCollectionReusableView * reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kIdentifier_HEADER forIndexPath:indexPath];
    [reusableView setBackgroundColor:[UIColor redColor]];
    return reusableView;
}

- (CGSize)flyCollectionView:(FlyCollectionView *)collectionView layout:(FlyCollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 50.f;
    if (indexPath.row > 10) {
        height = 150.f;
    }
    return CGSizeMake(375.f, height);
}

- (CGSize)flyCollectionView:(FlyCollectionView *)collectionView layout:(FlyCollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(375.f, 20.f);
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}


@end
