//
//  ViewController.m
//  002---Block循环引用
//
//  Created by Cooci on 2018/6/24.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import "ViewController.h"

typedef void(^KCBlock)(ViewController *);
@interface ViewController ()
@property (nonatomic, copy) KCBlock block;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // self - tableView - delegate - self;
    self.tableView.delegate = self;

    // 循环引用
    self.name = @"lg_cooci";
    __block ViewController *vc = self;
    // self - block - self
    //
    self.block = ^(ViewController *vc){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"%@",vc.name);
        });
    };
    self.block();
}

//- (void)test1{
//    __weak typeof(self) weakSelf = self; // weakSelf(弱引用表) -> self
//    // strongSelf(nil) -> weakSelf -> self(引用计数不处理)--nil -> block -> weakSelf
//    self.block = ^{
//        // 持有 不能是一个永久持有 - 临时的
//        // strong-weak-dance
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSLog(@"%@",strongSelf.name);
//        });
//    };
//    self.block();
//
//    __block ViewController *vc = self;
//    // vc - self - block - vc
//    //
//    self.block = ^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSLog(@"%@",vc.name);
//            vc = nil;
//        });
//    };
//    self.block();
//}

- (void)dealloc{
    NSLog(@"dealloc 来了");
    // self - 变量都会发送 release
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
