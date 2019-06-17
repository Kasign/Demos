//
//  ViewController.m
//  无限循环CollectionView
//
//  Created by mx-QS on 2019/6/10.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

#define FlyLog(format, ...)

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView   *   collectionView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 80, 40)];
    [btn addTarget:self action:@selector(taction) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:btn];
}

- (void)taction {
    
    SecondViewController * vc = [[SecondViewController alloc] init];
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize           = CGSizeMake(100, 100);
        layout.scrollDirection    = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 15.f;
        layout.minimumInteritemSpacing = 15.f;
        
        CGRect frame = CGRectMake(0, 200, self.view.bounds.size.width, 100);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
    }
    return _collectionView;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UILabel * label = [cell.contentView viewWithTag:111111];
    
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setFont:[UIFont systemFontOfSize:16.f]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor redColor]];
        [label setTag:111111];
        [cell.contentView addSubview:label];
        [label.layer setBorderColor:[UIColor blueColor].CGColor];
        [label.layer setBorderWidth:0.5];
        [label setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.2]];
    }
    
    [label setFrame:cell.bounds];
    [label setText:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    [cell setBackgroundColor:[[UIColor purpleColor] colorWithAlphaComponent:0.2]];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 30;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width  = 80;
    CGFloat height = 80;
    
    UICollectionViewLayoutAttributes * attri = [collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
    
    if (attri) {
        if (attri.frame.origin.x - 150 < collectionView.contentOffset.x && indexPath.item %4 != 0) {
            width  = 100;
            height = 100;
        }
    }
    
    return CGSizeMake(width, height);
}

@end
