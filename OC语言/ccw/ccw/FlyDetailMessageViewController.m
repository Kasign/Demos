//
//  FlyDetailMessageViewController.m
//  ccw
//
//  Created by Walg on 2017/5/20.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import "FlyDetailMessageViewController.h"
#define HTTP_ADDRESS @"http://f.apiplus.net/dlt-10.json"
@interface FlyDetailMessageViewController ()
@property (nonatomic,strong)AFHTTPSessionManager *manger;
@end

@implementation FlyDetailMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(AFHTTPSessionManager *)manger{
    if (!_manger) {
        _manger = [AFHTTPSessionManager manager];
    }
    return _manger;
}



-(void)getData{
    NSString *request = [NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    [_manger GET:request parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
