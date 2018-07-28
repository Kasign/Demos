//
//  ViewController.m
//  3D效果
//
//  Created by Q on 2018/5/8.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "ViewController.h"
#import "OrgLoopLayout.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView   *   collectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.collectionView];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        OrgLoopLayout * layout = [[OrgLoopLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.itemSize = CGSizeMake(200, 120);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, 130) collectionViewLayout:layout];
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        [_collectionView setShowsVerticalScrollIndicator:NO];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setBackgroundColor:[UIColor lightGrayColor]];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    
    UIImageView * imageView = [cell viewWithTag:100001];
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
        [imageView setTag:100001];
        [cell addSubview:imageView];
    }
    
    [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",indexPath.row]]];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
