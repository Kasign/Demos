//
//  FlySecondViewController.m
//  单例测试
//
//  Created by Q on 2018/4/20.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "FlySecondViewController.h"
#import "FlyButton.h"
#import "FlyTestManager.h"
#import "FlyThirdViewController.h"

static  NSInteger staticCount = 0;

@interface FlySecondViewController (){
    NSInteger  count;
    NSString * smallString;
}

@property (nonatomic, copy) NSString   *   bigString;
@property (nonatomic, assign) NSInteger    countP;
@end

@implementation FlySecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _countP = 12;
    count = 1;
    smallString = @"abcd";
    staticCount = 10;
    _bigString = @"bnm";
    
    __weak typeof(self) weakSelf = self;
    FlyButton * thirdButton = [[FlyButton alloc] initWithFrame:CGRectMake(100, 100, 180, 20)];
    [thirdButton setTitle:@"跳转第三页面" forState:UIControlStateNormal];
    [thirdButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [thirdButton setButtonBlock:^(FlyButton *sender) {
        FlyThirdViewController * secondVC = [[FlyThirdViewController alloc] init];
        [weakSelf.navigationController pushViewController:secondVC animated:YES];
    }];
    [self.view addSubview:thirdButton];
    
    FlyButton * testButton = [[FlyButton alloc] initWithFrame:CGRectMake(100, 180, 180, 20)];
    [testButton setTitle:@"测试方法1" forState:UIControlStateNormal];
    [testButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [testButton setButtonBlock:^(FlyButton *sender) {
        [weakSelf test1];
    }];
    [self.view addSubview:testButton];
    
    FlyButton * testButton2 = [[FlyButton alloc] initWithFrame:CGRectMake(100, 260, 180, 20)];
    [testButton2 setTitle:@"测试方法2" forState:UIControlStateNormal];
    [testButton2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [testButton2 setButtonBlock:^(FlyButton *sender) {
        [weakSelf test2];
    }];
    [self.view addSubview:testButton2];
    
    FlyButton * testButton3 = [[FlyButton alloc] initWithFrame:CGRectMake(100, 340, 180, 20)];
    [testButton3 setTitle:@"测试方法3" forState:UIControlStateNormal];
    [testButton3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [testButton3 setButtonBlock:^(FlyButton *sender) {
        [weakSelf test3];
    }];
    [self.view addSubview:testButton3];
    
}

- (void)test1
{
    __block typeof(staticCount) blockCount = staticCount;
    [[FlyTestManager shareInstance] setManagerBlock:^{
        staticCount ++ ;
        NSLog(@"staticCount:%ld",(long)staticCount);
        NSLog(@"blockCount:%ld",(long)blockCount);
    }];
    
    [[FlyTestManager shareInstance] sleepWithTimes:2.f];
    staticCount ++;
}

- (void)test2
{
    __weak typeof(self) weakSelf = self;
    __block typeof(self) blockSelf = self;
    __block typeof(count) blockCount = count;
    [[FlyTestManager shareInstance] setManagerBlock:^{
        //        [self.view setBackgroundColor:[UIColor blueColor]];
//        blockSelf.bigString = @"abcd";
//        NSLog(@"%ld",(long)blockSelf->count);
        blockCount ++ ;
        NSLog(@"%ld",(long)blockCount);
    }];
    
    [[FlyTestManager shareInstance] sleepWithTimes:4.f];
}

- (void)test3
{
    __weak typeof(self) weakSelf = self;
    __block typeof(self) blockSelf = self;
    __block typeof(_countP) blockCount = _countP;
    __block typeof(_bigString) blockString = _bigString;
    [[FlyTestManager shareInstance] setManagerBlock:^{
        //        [self.view setBackgroundColor:[UIColor blueColor]];
        //        blockSelf.bigString = @"abcd";
        NSLog(@"blockString:%@",blockString);
        NSLog(@"blockSelf:%@",blockSelf.bigString);
        NSLog(@"weakSelf:%@",weakSelf.bigString);
    }];
    [[FlyTestManager shareInstance] sleepWithTimes:4.f];
    _countP ++;
    _bigString = @"**11**";
}


-(void)dealloc
{
    NSLog(@"***********%s************",__func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
