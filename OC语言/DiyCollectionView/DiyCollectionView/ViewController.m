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
        layout.itemSize = CGSizeMake(100.f, 100.f);
        layout.minimumLineSpacing = 10.f;
        layout.minimumInteritemSpacing = 10.f;
        layout.sectionInset = UIEdgeInsetsMake(20.f, 20.f, 20.f, 20.f);
        
        _collectionView = [[FlyCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        [_collectionView registerClass:[FlyCollectionReusableView class] forCellWithReuseIdentifier:kIdentifier_CELL];
        [_collectionView registerClass:[FlyCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kIdentifier_HEADER];
         [_collectionView registerClass:[FlyCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kIdentifier_HEADER];
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        [_collectionView setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.3]];
    }
    return _collectionView;
}

- (NSInteger)numberOfSectionsInFlyCollectionView:(FlyCollectionView *)collectionView
{
    return 10;
}

- (NSInteger)flyCollectionView:(FlyCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 1) {
        return 0;
    }
    return section;
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
    [label setFrame:cell.bounds];
    [label setText:[NSString stringWithFormat:@"%@ - %p",@(indexPath.row),cell]];
    return cell;
}

- (FlyCollectionReusableView *)flyCollectionView:(FlyCollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    FlyCollectionReusableView * reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kIdentifier_HEADER forIndexPath:indexPath];
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        [reusableView setBackgroundColor:[UIColor purpleColor]];
    } else {
        [reusableView setBackgroundColor:[UIColor redColor]];
    }
    
    UILabel * label = [reusableView viewWithTag:10086];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:reusableView.bounds];
        [label setTag:10086];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor blackColor]];
        [reusableView addSubview:label];
    }
    [label setFrame:reusableView.bounds];
    [label setText:kind];
    
    return reusableView;
}

- (CGSize)flyCollectionView:(FlyCollectionView *)collectionView layout:(FlyCollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 50.f;
    CGFloat weight = 100.f;
    if (indexPath.row % 3 == 1) {
        height = 150.f;
    } else if (indexPath.row % 3 == 2) {
        height = 100.f;
    }
    if (indexPath.row % 4 == 1) {
        weight = 50.f;
    } else if (indexPath.row % 4 == 2) {
        weight = 100.f;
    } else if (indexPath.row % 4 == 3) {
        weight = 150.f;
    }
    return CGSizeMake(weight, height);
}

- (CGSize)flyCollectionView:(FlyCollectionView *)collectionView layout:(FlyCollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(100.f, 45.f);
}

- (CGSize)flyCollectionView:(FlyCollectionView *)collectionView layout:(FlyCollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return CGSizeMake(100.f, 30.f);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}


@end
