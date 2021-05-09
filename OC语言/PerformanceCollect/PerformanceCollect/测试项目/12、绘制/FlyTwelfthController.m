//
//  FlyTwelfthController.m
//  算法+链表
//
//  Created by Walg on 2019/10/25.
//  Copyright © 2019 Fly. All rights reserved.
//
//  绘制

#import "FlyTwelfthController.h"

@interface FlyTwelfthController ()

@property (nonatomic, strong) UIImageView  * imageView1;
@property (nonatomic, strong) UIImageView  * imageView2;

@end

@implementation FlyTwelfthController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.imageView1];
}

- (UIImageView *)imageView1 {
    
    if (_imageView1 == nil) {
        _imageView1 = [[UIImageView alloc] init];
        [_imageView1 setFrame:CGRectMake(0, 0, 100, 100)];
    }
    return _imageView1;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    
}


@end
