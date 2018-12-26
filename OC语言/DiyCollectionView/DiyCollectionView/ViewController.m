//
//  ViewController.m
//  DiyCollectionView
//
//  Created by 66-admin-qs. on 2018/11/29.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "ViewController.h"
#import "FlyCollectionView.h"
#import "FlyMenuController.h"

static NSString * kIdentifier_CELL = @"kIdentifier_CELL";
static NSString * kIdentifier_HEADER = @"kIdentifier_HEADER";
static NSString * kIdentifier_FOOTER = @"kIdentifier_FOOTER";

@interface ViewController ()<FlyCollectionViewDelegate, FlyCollectionViewDataSource, FlyCollectionViewLayoutDelegate>

@property (nonatomic, strong) FlyCollectionView   *   collectionView;

@property (nonatomic, strong) NSMutableArray   *   dataSourceArr;

@property (nonatomic, strong) NSIndexPath   *   currentIndexPath;
@property (nonatomic, strong) FlyMenuItem   *   repeatItem;
@property (nonatomic, strong) FlyMenuItem   *   pasteItem;
@property (nonatomic, strong) FlyMenuItem   *   deleteItem;
@property (nonatomic, strong) FlyMenuController   *   menuController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSourceArr = [@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16"] mutableCopy];
    [self.view addSubview:self.collectionView];
}

- (FlyMenuController *)menuController
{
    if (!_menuController) {
        _menuController = [FlyMenuController sharedMenuController];
        _repeatItem = [[FlyMenuItem alloc] initWithTitle:@"复制" fontSize:14.f];
        _pasteItem = [[FlyMenuItem alloc] initWithTitle:@"粘贴" fontSize:14.f];
        _deleteItem = [[FlyMenuItem alloc] initWithTitle:@"删除" fontSize:14.f];
        [_menuController setMenuItems:@[_repeatItem,_deleteItem]];
        __weak typeof(self) weakSelf = self;
        _menuController.flyMenuClickBlock = ^(FlyMenuItem * _Nonnull menuItem, UIView * _Nonnull relyView) {
            [weakSelf menuDidClick:menuItem];
        };
    }
    return _menuController;
}

- (void)menuDidClick:(FlyMenuItem *)menuItem
{
    id object = _dataSourceArr[_currentIndexPath.row];
    if (menuItem == _repeatItem) {
        [_dataSourceArr insertObject:object atIndex:_currentIndexPath.row];
        [self.collectionView insertItemsAtIndexPaths:@[_currentIndexPath]];
    } else if (menuItem == _pasteItem) {
        
        [self.collectionView insertItemsAtIndexPaths:@[_currentIndexPath]];
    } else if (menuItem == _deleteItem) {
        [_dataSourceArr removeObjectAtIndex:_currentIndexPath.row];
        [self.collectionView deleteItemsAtIndexPaths:@[_currentIndexPath]];
    }
}

- (FlyCollectionView *)collectionView
{
    if (!_collectionView) {
        FlyCollectionViewLayout * layout = [[FlyCollectionViewLayout alloc] init];
//        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[FlyCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        [_collectionView setContentInset:UIEdgeInsetsMake(60.f, 15.f, 60.f, 15.f)];
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
    FlyLog(@" 1---->>>>numberOfSectionsInCollectionView");
    return 1;
}

- (NSInteger)flyCollectionView:(FlyCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    FlyLog(@" 2---->>>>numberOfItemsInSection section:%ld",section);
    return _dataSourceArr.count;
}

- (__kindof FlyCollectionReusableView *)flyCollectionView:(FlyCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FlyCollectionReusableView * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kIdentifier_CELL forIndexPath:indexPath];
    
    UILabel * label = [cell viewWithTag:10086];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:cell.bounds];
        [label setTag:10086];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor blackColor]];
        [label setNumberOfLines:0];
        [cell addSubview:label];
    }
    [cell setBackgroundColor:[UIColor purpleColor]];
    [label setFrame:cell.bounds];
    //    [label setText:[NSString stringWithFormat:@"%@-%@\n %p",@(indexPath.section),@(indexPath.row),cell]];
    
    [label setText:_dataSourceArr[indexPath.row]];
//    FlyLog(@" 3---->>>>cellForItemAtIndexPath index:%@",indexPath);
    
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
    
    FlyLog(@" 4---->>>>viewForSupplemen kind:%@ index:%@ point : %@",kind,indexPath,[NSValue valueWithCGPoint:reusableView.frame.origin]);
    
    return reusableView;
}

- (CGSize)flyCollectionView:(FlyCollectionView *)collectionView layout:(FlyCollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FlyLog(@" 5---->>>>sizeForItemAtIndexPath index:%@",indexPath);
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

- (CGFloat)flyCollectionView:(FlyCollectionView *)collectionView layout:(FlyCollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    FlyLog(@" 6---->>>>minimumLineSpacingForSectionAtIndex section:%ld",section);
    return 10.f;
}

-(CGFloat)flyCollectionView:(FlyCollectionView *)collectionView layout:(FlyCollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    FlyLog(@" 7---->>>>minimumInteritemSpacingForSectionAtIndex section:%ld",section);
    return 10.f;
}

- (UIEdgeInsets)flyCollectionView:(FlyCollectionView *)collectionView layout:(FlyCollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    FlyLog(@" 8---->>>>insetForSectionAtIndex section:%ld",section);
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

- (CGSize)flyCollectionView:(FlyCollectionView *)collectionView layout:(FlyCollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    FlyLog(@" 9---->>>>referenceSizeForHeaderInSection section:%ld",section);
    return CGSizeMake(100.f, 45.f);
}

- (CGSize)flyCollectionView:(FlyCollectionView *)collectionView layout:(FlyCollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    FlyLog(@" 10---->>>>referenceSizeForFooterInSection section:%ld",section);
    return CGSizeMake(100.f, 30.f);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    FlyLog(@" 11---->>>>scrollViewDidScroll contentOffset.y:%f %@",scrollView.contentOffset.y,[NSValue valueWithCGSize:scrollView.contentSize]);
}

- (void)flyCollectionView:(FlyCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FlyLog(@"didSelectItemAtIndexPath");
    
    FlyCollectionReusableView * cell = [collectionView cellForItemAtIndexPath:indexPath];
    if (cell) {
        _currentIndexPath = indexPath;
        [self.menuController showRelyView:cell inView:collectionView];
        [self.menuController setMenuVisible:YES animated:YES];
    }
    
    //    [self getClassMethods:self.collectionView];
    //    [self getClassMethods:self.layout];
}

@end
