//
//  ViewController.m
//  12306自动抢票
//
//  Created by qiuShan on 2018/1/23.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "ViewController.h"
#import "FlyServerManager.h"
#import "FlyHttpClient.h"
#import "FlyCheckTrainRequestObject.h"
#import "FlyStationManager.h"

#import "FlyTrainInfoViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
}

//- (void)initSubViews
//{
//    UITextField * fromTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 80, 30)];
//
//}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [[FlyServerManager sharedInstanced] getDataWithUrlStr:@"https://kyfw.12306.cn/otn/leftTicket/queryZ?leftTicketDTO.train_date=2018-02-11&leftTicketDTO.from_station=BJP&leftTicketDTO.to_station=CCT&purpose_codes=ADULT" block:nil];
//    [self startData];
    
    [self pushToTrain];
}

- (void)startData
{
    FlyCheckTrainRequestObject * request = [[FlyCheckTrainRequestObject alloc] init];
    request.from_station = @"BJP";
    request.to_station   = @"CCT";
    request.train_date   = @"2018-02-11";
    request.purpose_codes = @"ADULT";
    
    [[FlyHttpClient sharedInstance] getDataWithRequest:request block:^(FlyResponseObject *responseObject, NSError *error) {
        NSLog(@"%@",responseObject);
    }];
}

- (void)pushToTrain
{
    NSDictionary * stationDict = [FlyStationManager stationDictionary];
    
    FlyStationModel * fromModel = [stationDict objectForKey:@"北京"];
    FlyStationModel * toModel = [stationDict objectForKey:@"长春"];
    
    FlyTrainInfoViewController * trainInfoVC = [[FlyTrainInfoViewController alloc] init];
    trainInfoVC.fromModel = fromModel;
    trainInfoVC.toModel   = toModel;
    trainInfoVC.data      = @"2018-02-13";
    [self.navigationController pushViewController:trainInfoVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
