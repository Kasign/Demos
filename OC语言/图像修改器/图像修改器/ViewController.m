//
//  ViewController.m
//  图像修改器
//
//  Created by Qiushan on 2020/1/15.
//  Copyright © 2020 FLY. All rights reserved.
//

#import "ViewController.h"
#import "FLYImageChangeView.h"

@interface ViewController ()

@property (nonatomic, strong) FLYImageChangeView   *   imageChangeView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageChangeView];
}

- (FLYImageChangeView *)imageChangeView {
    
    if (_imageChangeView == nil) {
        _imageChangeView = [[FLYImageChangeView alloc] init];
        [_imageChangeView setBackgroundColor:[UIColor clearColor]];
    }
    return _imageChangeView;
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    [self.imageChangeView setFrame:CGRectMake(0, 28, self.view.frame.size.width, self.view.frame.size.height - 28)];
}

@end
