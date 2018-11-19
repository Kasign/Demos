//
//  ViewController.m
//  collectionView下拉加载
//
//  Created by Walg on 2017/9/17.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import "ViewController.h"
#import "CardLayout.h"
#import "XGRefresh.h"

#define RGBAColor(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGBColor(r,g,b)     RGBAColor(r,g,b,1.0)
#define RGBColorC(c)        RGBColor((((int)c) >> 16),((((int)c) >> 8) & 0xff),(((int)c) & 0xff))


@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UICollectionView * collectionView;

@property (nonatomic,strong)NSArray * dataSourceArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self.view setBackgroundColor:[UIColor cyanColor]];
    
    _dataSourceArr = @[@"1",@"2",@"3"];
//    _dataSourceArr = @[@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3"];
    
    [self.view addSubview:self.collectionView];
    
    
//    __weak typeof(self) weakSelf = self;

//    [self.collectionView.downRefreshView setRefreshingBlock:^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//
//            NSArray *newDataSource = @[@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3"];
////            NSMutableArray *source = [NSMutableArray arrayWithArray:weakSelf.dataSourceArr];
//
//            NSMutableArray *source = [weakSelf.dataSourceArr mutableCopy];
//
//            [source insertObjects:newDataSource atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newDataSource.count)]];
//
//            weakSelf.dataSourceArr = source;
//            [weakSelf.collectionView reloadData];
//
//            // 让刷新控件停止刷新
//            [weakSelf.collectionView.downRefreshView endRefreshing];
//
//
//        });
//    }];
}

-(UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
//        CardLayout *layout = [[CardLayout alloc] initWithOffsetY:0];
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.itemSize = CGSizeMake(414, 100);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cardCell"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSourceArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cardCell" forIndexPath:indexPath];
    [cell setBackgroundColor:[self getGameColor:indexPath.row]];
    
    UILabel *label = [cell.contentView viewWithTag:20181001];
    
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
        [label setTag:20181001];
        [cell.contentView addSubview:label];
    }
    
    label.text = [NSString stringWithFormat:@"Item %d",(int)indexPath.row];
    [label setCenter:CGPointMake(cell.frame.size.width/2.0, 40)];
    
    return cell;
}

-(UIColor*)getGameColor:(NSInteger)index
{
    NSArray* colorList = @[RGBColorC(0xfb742a),RGBColorC(0xfcc42d),RGBColorC(0x29c26d),RGBColorC(0xfaa20a),RGBColorC(0x5e64d9),RGBColorC(0x6d7482),RGBColorC(0x54b1ff),RGBColorC(0xe2c179),RGBColorC(0x9973e5),RGBColorC(0x61d4ff)];
    UIColor* color = [colorList objectAtIndex:(index%10)];
    return color;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
