//
//  ViewController.m
//  SnotText
//
//  Created by Walg on 2019/3/13.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIView  * contentView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(60, 80, 180, 30)];
    [label setText:@"shkjsdflkjsdfaklj"];
    [label setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.2]];
    [self.view addSubview:label];
    
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(40, 120, 180, 30)];
    [label2 setText:@"怎么回事呢？？？？"];
    [label2 setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.2]];
    [self.view addSubview:label2];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(50, 160, 200, 30)];
    
    [view setBackgroundColor:[[UIColor purpleColor] colorWithAlphaComponent:0.2]];
    [self.view addSubview:view];

    
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(70, 220, 200, 30)];
    
    [view1 setBackgroundColor:[[UIColor purpleColor] colorWithAlphaComponent:0.2]];
    [self.view addSubview:view1];
    
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(10, 270, 300, 30)];
    
    [view2 setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.2]];
    [self.view addSubview:view2];
    
    
    UIView * view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 330, 400, 30)];
    
    [view3 setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.2]];
    [self.view addSubview:view3];
    
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(75, 500, 250, 250)];
    
    [_contentView setBackgroundColor:[[UIColor purpleColor] colorWithAlphaComponent:1.0]];
    [self.view addSubview:_contentView];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    CGRect wantRect = CGRectMake(150, 60, 100, 200);

    
    CGRect rect = CGRectMake(0, 0, wantRect.size.width, wantRect.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);//设置好想要截取的图片大小
    rect = self.view.bounds;
    rect.origin = CGPointMake(- wantRect.origin.x, - wantRect.origin.y);
    [self.view drawViewHierarchyInRect:rect afterScreenUpdates:YES];//将self.view绘制在当前的conetext上，位置为rect
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    
    imageView.frame = CGRectMake(20, 20, imageView.frame.size.width, imageView.frame.size.height);
    imageView.alpha = 0.8;
    imageView.layer.zPosition = 100000;
    
    [_contentView addSubview:imageView];
}


@end
