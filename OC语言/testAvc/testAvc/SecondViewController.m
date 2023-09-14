//
//  SecondViewController.m
//  testAvc
//
//  Created by qiuShan on 2017/10/16.
//  Copyright © 2017年 秋山. All rights reserved.
//

#import "SecondViewController.h"
#import "LQStoryCardCollectionCell.h"
#import "FLYTestView.h"
#import "FlyTestControl.h"
#import "UIView+LayoutMethods.h"
#import "FlyTestBaseView.h"
#import "UIGestureRecognizer+FLYTouch.h"

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
    self.view.backgroundColor = [UIColor whiteColor];
    _dataSourceCount = 100;
    
//    [self.view addSubview:self.storyCollectionView];
    [self setUpSubviews];
}

- (UICollectionView *)storyCollectionView{
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

#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
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

- (void)setUpSubviews {
    
    CGRect frame2 = CGRectMake(0, 200, self.view.ct_width, 200);
    CGRect frame4 = CGRectMake(self.view.ct_width - 250, 50, 200, 200);
    
    CGRect frame3 = CGRectMake(100, 100, self.view.ct_width - 200, 400);
    CGRect frame5 = CGRectMake(-50, 50, 200, 200);
    
    FlyTestBaseView *view1 = [[FlyTestBaseView alloc] initWithFrame:self.view.bounds];
    FLYTestView *view2 = [[FLYTestView alloc] initWithFrame:frame2];
    FLYTestView *view3 = [[FLYTestView alloc] initWithFrame:frame3];
    
    FlyTestControl *view4 = [[FlyTestControl alloc] initWithFrame:frame4];
    FlyTestControl *view5 = [[FlyTestControl alloc] initWithFrame:frame5];
    
    [view4 addTarget:self action:@selector(didClickControl:) forControlEvents:UIControlEventTouchUpInside];
    [view5 addTarget:self action:@selector(didClickControl:) forControlEvents:UIControlEventTouchUpInside];
    
    view1.name = @"view1";
    view2.name = @"view2";
    view3.name = @"view3";
    view4.name = @"view4";
    view5.name = @"view5";
    
    [self.view addSubview:view1];
    [view1 addSubview:view2];
    [view1 addSubview:view3];
    
    [view2 addSubview:view4];
    [view3 addSubview:view5];
    
    view1.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
    
    view2.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.4];
    view4.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.4];
    
    view3.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.4];
    view5.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.4];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    
//    tap.cancelsTouchesInView = false;
//    tap.delaysTouchesBegan = false;
//    tap.delaysTouchesEnded = false;
    
    [view1 addGestureRecognizer:tap];
}

- (void)didClickControl:(id)view {
    
    NSLog(@"-----Control响应了");
}

- (void)didTap:(id)view {
    
    NSLog(@"-----手势响应了");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
