//
//  SecondViewController.m
//  无限循环CollectionView
//
//  Created by mx-QS on 2019/6/12.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "SecondViewController.h"
#import "FlyLoopView.h"
#import "FlyLayout.h"

@interface FlyCell : UICollectionViewCell

@property (nonatomic, strong) UILabel   *   label;

@end

@implementation FlyCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        [_label setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.2]];
        [_label setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_label];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_label setFrame:self.bounds];
    [_label setCenter:CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5)];
}

@end

@interface SecondViewController ()<FlyLoopViewDataSource, FlyLoopViewDelegate, FlyLayoutDelegate>

@property (nonatomic, strong) FlyLoopView   *   collectionView;

@property (nonatomic, strong) FlyCell   *   animatedCell;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 350, 80, 40)];
    [btn addTarget:self action:@selector(taction) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:btn];
    
//    _animatedCell = [[FlyCell alloc] initWithFrame:CGRectMake(300, 180, 150, 150)];
//    [_animatedCell setBackgroundColor:[UIColor purpleColor]];
//    [self.view addSubview:_animatedCell];
}

- (void)taction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [_animatedCell setFrame:CGRectMake(300, 180, 150, 150)];
}

- (FlyLoopView *)collectionView {
    
    if (!_collectionView) {
        
        FlyLayout * layout = [[FlyLayout alloc] init];
        layout.itemSize         = CGSizeMake(100, 100);
        layout.scrollDirection  = UICollectionViewScrollDirectionHorizontal;
        layout.interitemSpacing = 15.f;
        
        CGRect frame = CGRectMake(290, 100, 300, 200);
        _collectionView = [[FlyLoopView alloc] initWithFrame:frame collectionViewLayout:layout];
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        _collectionView.isLoop     = YES;
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        _collectionView.itemOffset = 3;
    }
    return _collectionView;
}

- (NSInteger)flyLoopViewNumberOfItems {
    
    return 30;
}

- (__kindof UICollectionReusableView *)flyLoopView:(FlyLoopView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FlyCell * cell = [collectionView dequeueReusableCellWithIndexPath:indexPath cellClass:[FlyCell class]];
    
//    UILabel * label = [cell.contentView viewWithTag:111111];
//
//    if (!label) {
//        label = [[UILabel alloc] initWithFrame:CGRectZero];
//        [label setFont:[UIFont systemFontOfSize:16.f]];
//        [label setTextAlignment:NSTextAlignmentCenter];
//        [label setTextColor:[UIColor redColor]];
//        [label setTag:111111];
//        [cell.contentView addSubview:label];
//        [label.layer setBorderColor:[UIColor blueColor].CGColor];
//        [label.layer setBorderWidth:0.5];
//        [label setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.2]];
//    }
//
//    [label setFrame:cell.bounds];
//    [label setText:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    
    cell.label.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
//    [cell setBackgroundColor:[[UIColor purpleColor] colorWithAlphaComponent:1]];
    [cell setBackgroundColor:[UIColor purpleColor]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width  = 80;
    CGFloat height = 80;
    if (indexPath.row%3 == 0) {
        width  = 100;
        height = 100;
    }
    
    return CGSizeMake(width, height);
}

- (void)loopViewLayout:(FlyLayout *)loopViewLayout initializeAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes indexPath:(nonnull NSIndexPath *)indexPath {
    
    CGRect frame = layoutAttributes.frame;
    if (indexPath.item == self.collectionView.itemOffset) {
        frame.size = CGSizeMake(150, 150);
    }
    frame.origin.y = self.collectionView.bounds.size.height * 0.5 - frame.size.height * 0.5;
    layoutAttributes.frame = frame;
}

- (void)dealloc {
    
    NSLog(@"---->>> %@ dealloc<<<----", [self class]);
}


@end
