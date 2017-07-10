//
//  FlyBasicViewController.m
//  Security
//
//  Created by walg on 2017/1/4.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "FlyBasicViewController.h"

@interface FlyBasicViewController ()

@end

@implementation FlyBasicViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    _navigationBarHeight = 64.0f;
    _statusBarHeight = 20.0f;
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    _tabBarHeight = 50.0f;
    _navigationBarHidden = YES;
    _backBtnHidden = YES;
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        _navigationBarHeight = 64.0f;
        _statusBarHeight = 20.0f;
//        self.automaticallyAdjustsScrollViewInsets = NO;
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        
        _tabBarHeight = 50.0f;
        _navigationBarHidden = YES;
        _backBtnHidden = YES;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBarHidden = NO;
    self.backBtnHidden = NO;
}

- (void)setNavigationBarHidden:(BOOL)navgationBarHidden
{
    _navigationBarHidden = navgationBarHidden;
    
    UIView *view = [self.view viewWithTag:100000];
    
    if(view && _navigationBarHidden)
    {
        [view removeFromSuperview];
    }
    else if(!view && !_navigationBarHidden)
    {
        if (!_navigationBar)
        {
            _navigationBar = [[FlyNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.navigationBarHeight)];
            [_navigationBar setTag:100000];
        }
        [self.view addSubview:_navigationBar];
    }
}

- (void)setBackBtnHidden:(BOOL)backBtnHidden
{
    _backBtnHidden = backBtnHidden;
    
    UIView *view = [self.navigationBar viewWithTag:321];
    
    if (view && _backBtnHidden) {
        [view removeFromSuperview];
    }else if(!view && !_backBtnHidden) {
        if (!_popBackBtn) {
            _popBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _popBackBtn.opaque = YES;
            [_popBackBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
            
            [_popBackBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
            _popBackBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            _popBackBtn.bounds = CGRectMake(0, 0, 60, 60);
            [_popBackBtn addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
            _popBackBtn.tag = 321;
        }
        self.navigationBar.leftBtn = _popBackBtn;
    }
}

-(void)setPopBackBtn:(UIButton *)popBackBtn{
    
    if (_popBackBtn) {
        [_popBackBtn removeFromSuperview];
    }
    if (_backBtnHidden) {
        return;
    }
    
    _popBackBtn = popBackBtn;
    self.navigationBar.leftBtn = popBackBtn;
    [self.navigationBar.leftBtn addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
}

- (void)popBack
{
    [self popBackWithAnimation:YES];
}

- (void)popBackWithAnimation:(BOOL)animation
{
    [self.navigationController popViewControllerAnimated:animation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
