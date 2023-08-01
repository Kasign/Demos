//
//  SecondViewController.m
//  testAvc
//
//  Created by qiuShan on 2017/10/16.
//  Copyright © 2017年 秋山. All rights reserved.
//

#import "SecondViewController.h"
#import "LQStoryCardCollectionCell.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

static NSString *cardCellIdentify = @"StoryCardIdentify";
static NSString *cardFootIdentify = @"FootCardIdentify";

@interface SecondViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>{
    NSInteger _dataSourceCount;
}

@property (nonatomic, strong) UICollectionView  *storyCollectionView;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSourceCount = 100;
    
    [self.view addSubview:self.storyCollectionView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.storyCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    });
}

-(UICollectionView *)storyCollectionView{
    if (!_storyCollectionView) {
        UICollectionViewFlowLayout  *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(ScreenWidth, ScreenHeight/4.0-5);
        
        _storyCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:layout];
        [_storyCollectionView setBackgroundColor:[UIColor blackColor]];
        _storyCollectionView.showsVerticalScrollIndicator   = NO;
        _storyCollectionView.showsHorizontalScrollIndicator = NO;
        _storyCollectionView.dataSource = self;
        _storyCollectionView.delegate   = self;
        [_storyCollectionView registerClass:[LQStoryCardCollectionCell class] forCellWithReuseIdentifier:cardCellIdentify];
        [_storyCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:cardFootIdentify];
        [_storyCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cardFootIdentify];
    }
    return _storyCollectionView;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _dataSourceCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LQStoryCardCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cardCellIdentify forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.title = [NSString stringWithFormat:@"我是第%ld行",(long)indexPath.row];
    
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    for (int i =0; i<_dataSourceCount; i++) {
//        NSIndexPath  *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//
//        UICollectionViewCell *cell = [self.storyCollectionView cellForItemAtIndexPath:indexPath];
//        if (cell.frame.origin.y != 0) {
//            NSLog(@"\n>>>>>>>>>>>>contentOffset.y = %f  origin.y = %f    row = %ld<<<<<<<<<<<",self.storyCollectionView.contentOffset.y,cell.frame.origin.y,indexPath.row);
//        }
//    }
//    NSLog(@"******************************************");
    [self logIfNeed:NSStringFromSelector(_cmd)];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {

    [self logIfNeed:NSStringFromSelector(_cmd)];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self logIfNeed:NSStringFromSelector(_cmd)];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset  {
 
    [self logIfNeed:NSStringFromSelector(_cmd)];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
 
    [self logIfNeed:NSStringFromSelector(_cmd)];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
    [self logIfNeed:NSStringFromSelector(_cmd)];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self logIfNeed:NSStringFromSelector(_cmd)];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    [self logIfNeed:NSStringFromSelector(_cmd)];
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
    
    [self logIfNeed:NSStringFromSelector(_cmd)];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    
    [self logIfNeed:NSStringFromSelector(_cmd)];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    
    [self logIfNeed:NSStringFromSelector(_cmd)];
    return YES;
};

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    
    [self logIfNeed:NSStringFromSelector(_cmd)];
}

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView {
    
    [self logIfNeed:NSStringFromSelector(_cmd)];
}

- (void)logIfNeed:(NSString *)msg {
    
    if (![NSThread isMainThread]) {
        NSLog(@" 非主线程：--->>> %@\n%@", [NSThread currentThread], msg);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
