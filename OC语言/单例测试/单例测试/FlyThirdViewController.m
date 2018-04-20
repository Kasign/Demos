//
//  FlyThirdViewController.m
//  单例测试
//
//  Created by Q on 2018/4/20.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "FlyThirdViewController.h"
#import "FlyNSObject.h"

@interface FlyThirdViewController ()

@end

@implementation FlyThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[[FlyNSObject alloc] init] testMethod];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
