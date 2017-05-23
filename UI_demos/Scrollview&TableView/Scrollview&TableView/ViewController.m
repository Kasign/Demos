//
//  ViewController.m
//  Scrollview&TableView
//
//  Created by walg on 2017/5/15.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "ViewController.h"
#define MainScreenWidth   [UIScreen mainScreen].bounds.size.width
#define MainScreenHeight      [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIScrollView *baseScrollView;
@property (nonatomic, strong) UITableView *currentTableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.baseScrollView setContentSize:CGSizeMake(MainScreenWidth, MainScreenHeight + 30)];
    
    [self.view addSubview:self.baseScrollView];
    [self.baseScrollView addSubview:self.currentTableView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
        CGPoint point  = scrollView.contentOffset;
        
        CGFloat maxHeight =90+3;
        
        CGFloat height =0 > scrollView.contentOffset.y?0:scrollView.contentOffset.y;
        
        point.y =height <maxHeight?height:maxHeight;
        
        
        [self.baseScrollView setContentOffset:point];
        
        if (scrollView == self.baseScrollView) {
            self.currentTableView.delegate = self;
        }else{
            self.currentTableView.delegate = nil;
        }
    
}

-(UIScrollView *)baseScrollView{
    if (!_baseScrollView) {
        _baseScrollView = [[UIScrollView alloc] init];
        _baseScrollView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
        _baseScrollView.frame = CGRectMake(0, 60, MainScreenWidth, MainScreenHeight-60);
        _baseScrollView.showsHorizontalScrollIndicator = NO;
        _baseScrollView.showsVerticalScrollIndicator = NO;
        _baseScrollView.delegate = self;
        _baseScrollView.bounces = NO;
//        _baseScrollView.scrollEnabled = NO;
    }
    return _baseScrollView;
}

-(UITableView *)currentTableView{
    if (!_currentTableView) {
        _currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 90, MainScreenWidth, MainScreenHeight) style:UITableViewStylePlain];
        _currentTableView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.3];
        _currentTableView.delegate = self;
        _currentTableView.dataSource =self;
        [_currentTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _currentTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 153;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
