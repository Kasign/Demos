//
//  FlyHallViewController.m
//  ccc
//
//  Created by walg on 2017/5/23.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "FlyHallViewController.h"
#import "FlyShowOldViewController.h"
#import "FlyList.h"
#import "FlyHallCell.h"
#import "FlyAllViewController.h"
#import "DetailViewController.h"
#import "FlyLookViewController.h"
@interface FlyHallViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIScrollView *headScrollView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIButton *lookGirlsBtn;
@property (nonatomic, strong) UIButton *luckBtn;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation FlyHallViewController
static NSInteger height = 150;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self  getData];
    self.navigationItem.title = @"开奖大厅";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.headScrollView];
    [self creatMidButtons];
}

-(void)getData{
    self.dataSource = [NSMutableArray array];
    [[FlyDataManager sharedInstance] getZixunArrayBlock:^(NSArray *dataArray) {
        NSInteger count =dataArray.count;
        int  j = arc4random()%(count);
        for (int i = 0; i<3; i++) {
            DataModel *model =[dataArray objectAtIndex:(j+i)%count];
            [self.dataSource addObject:model];
        }
        [self reloadHeadView];
    }];
}

-(void)reloadHeadView{
    for (int i=0; i<3; i++) {
        UIImageView *imageView = [self.headScrollView viewWithTag:i+200];
        DataModel *model =  _dataSource[i];
        for (UILabel *label in imageView.subviews) {
            if ([label isKindOfClass:[UILabel class]]) {
                [label setText:model.title];
            }
        }
    }
}

-(UIScrollView *)headScrollView{
    if (!_headScrollView) {
        _headScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, MainWidth, height)];
        [_headScrollView setBackgroundColor:[UIColor whiteColor]];
        [_headScrollView setContentSize:CGSizeMake(MainWidth*3, height)];
        [_headScrollView setPagingEnabled:YES];
        for (int i=0; i<3; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainWidth*i, 0, MainWidth, height)];
            [imageView setContentMode:UIViewContentModeScaleToFill];
            [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]]];
            imageView.tag = i+200;
            imageView.userInteractionEnabled = YES;
            [_headScrollView addSubview:imageView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToZixun:)];
            [imageView addGestureRecognizer:tap];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height-30, MainWidth, 20)];
            [titleLabel setTextAlignment:NSTextAlignmentCenter];
            [titleLabel setFont:[UIFont systemFontOfSize:12]];
            [titleLabel setTextColor:[UIColor whiteColor]];
            [imageView addSubview:titleLabel];
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
        
    }
    return _headScrollView;
}

-(void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)startTimer{
    static int time = 0;
    time++;
    [_headScrollView setContentOffset:CGPointMake(time%3*MainWidth, 0) animated:YES];
}

-(void)jumpToZixun:(UITapGestureRecognizer*)tap{
    if (_dataSource.count<1) {
        return;
    }
    UIView *view = tap.view;
    DetailViewController *dv = [[DetailViewController alloc] init];
    dv.object = _dataSource[view.tag-200];
    [self.navigationController pushViewController:dv animated:YES];
}

-(void)creatMidButtons{
    CGRect frame= CGRectMake(0, height+64, MainWidth, 44);
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    [bgView setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.4]];
    [self.view addSubview:bgView];
    
    CGRect frame1= CGRectMake(0, 2, MainWidth/2.0-1, 40);
    _lookGirlsBtn = [[UIButton alloc] initWithFrame:frame1];
    [_lookGirlsBtn setBackgroundColor:[UIColor whiteColor]];
    [_lookGirlsBtn setImage:[UIImage imageNamed:@"girl.jpg"] forState:UIControlStateNormal];
    [_lookGirlsBtn setTitle:@"看" forState:UIControlStateNormal];
    [_lookGirlsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_lookGirlsBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_lookGirlsBtn.imageView setBounds:CGRectMake(0, 0, 40, 40)];
    [_lookGirlsBtn addTarget:self action:@selector(clickLookAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_lookGirlsBtn];
    
    CGRect frame2= CGRectMake(MainWidth/2.0+1, 2, MainWidth/2.0-1, 40);
    _luckBtn = [[UIButton alloc] initWithFrame:frame2];
    [_luckBtn setBackgroundColor:[UIColor whiteColor]];
    [_luckBtn setImage:[UIImage imageNamed:@"luckBtn.jpeg"] forState:UIControlStateNormal];
    [_luckBtn setTitle:@"看运气" forState:UIControlStateNormal];
    [_luckBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_luckBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_luckBtn addTarget:self action:@selector(clickLuckAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_luckBtn];
}

-(void)clickLuckAction{
    [self.tabBarController setSelectedIndex:2];
}

-(void)clickLookAction{
    FlyLookViewController *lookVC = [[FlyLookViewController alloc]init];
    [self.navigationController pushViewController:lookVC animated:YES];
}


-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10.0;
        layout.minimumInteritemSpacing = 0.0;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 50);
        
        CGRect frame = self.view.bounds;
        frame.origin.y = frame.origin.y + height+48;
        frame.size.height = frame.size.height - height - 48;
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.clipsToBounds = YES;
        _collectionView.layer.masksToBounds = YES;
        [_collectionView registerClass:[FlyHallCell class] forCellWithReuseIdentifier:@"HALLCELL"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    }
    return _collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FlyHallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HALLCELL" forIndexPath:indexPath];
    if (indexPath.section == 0)
    {
        if (indexPath.row<countryList().allKeys.count)
        {
            NSString *key = countryList().allKeys[indexPath.row];
            cell.title = countryList()[key];
            cell.kind = key;
        }
    }
    else
    {
        if (indexPath.row<hotList().allKeys.count)
        {
            NSString *key = hotList().allKeys[indexPath.row];
            cell.title = hotList()[key];
            cell.kind = key;
        }
    }
   
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        header.backgroundColor = [UIColor whiteColor];
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:header.bounds];
        header.layer.masksToBounds = NO;
        header.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        header.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
        header.layer.shadowOpacity = 0.5f;
        header.layer.shadowPath = shadowPath.CGPath;
        
        UILabel *lable = [[UILabel alloc] init];
        CGRect frame = header.bounds;
        frame.size.width = frame.size.width - 140;
        frame.origin.x = frame.origin.x + 10;
        [lable setFrame:frame];
        [lable setFont:[UIFont systemFontOfSize:18]];
        [lable setTextColor:[[UIColor blueColor] colorWithAlphaComponent:0.8]];
        [lable setTextAlignment:NSTextAlignmentLeft];
        if (indexPath.section == 0) {
             [lable setText:@"全国彩列表"];
        }
        else{
             [lable setText:@"高频彩列表"];
        }
        CGRect buttonFrame = CGRectMake(MainWidth-100, 0, 80, frame.size.height);
        UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
        [button setTitle:@"查看全部" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [button.titleLabel setTextAlignment:NSTextAlignmentRight];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button addTarget:self action:@selector(gotoAll:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1000 + indexPath.section;
        
        for (UIView *view in header.subviews) {
            [view removeFromSuperview];
        } // 防止复用分区头
        [header addSubview:lable];
        [header addSubview:button];
        return header;
    } else {
        return nil;
    }
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
    NSString *key;
    NSString *value;
    if (indexPath.section==0)
    {
        key = countryList().allKeys[indexPath.row];
        value =countryList()[key];
    }
    else
    {
        key = hotList().allKeys[indexPath.row];
        value =hotList()[key];
    }
    
    FlyShowOldViewController *oldVC = [[FlyShowOldViewController alloc] init];
    oldVC.urlStr = key;
    oldVC.showTitle =value;
    oldVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:oldVC animated:YES];
    
}

-(void)gotoAll:(UIButton*)sender{
    NSInteger tag = sender.tag - 1000;
    FlyAllViewController *allVC = [[FlyAllViewController alloc] init];
    if (tag == 0) {
        allVC.tag = 1;
        allVC.titleName = @"全国彩列表";
    }else{
        allVC.tag = 2;
        allVC.titleName = @"高频彩列表";
    }
    allVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:allVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
