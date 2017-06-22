//
//  FlyThirdViewController.m
//  ccw
//
//  Created by Walg on 2017/5/20.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import "FlyThirdViewController.h"
#import "FlyDetailTableViewCell.h"
@interface FlyThirdViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation FlyThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainWidth, MainHeight-64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
}


-(UILabel*)setlable{
    UILabel *label = [[UILabel alloc] init];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setNumberOfLines:0];
    
    return label;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FlyDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[FlyDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
