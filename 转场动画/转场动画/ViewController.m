//
//  ViewController.m
//  转场动画
//
//  Created by walg on 2017/3/3.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "ViewController.h"
#define IMAGE_COUNT 5
@interface ViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) int currentIndex;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageView = [[UIImageView alloc]init];
    _imageView.frame = [UIScreen mainScreen].bounds;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.image = [UIImage imageNamed:@"0.jpg"];
    [self.view addSubview:_imageView];
    
    UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipeGesture];
    
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGesture];
}

-(void)leftSwipe:(UISwipeGestureRecognizer*)gesture{
    [self transitionAnimation:YES];
}
-(void)rightSwipe:(UISwipeGestureRecognizer*)gesture{
    [self transitionAnimation:NO];
}

#pragma mark 转场动画
-(void)transitionAnimation:(BOOL)isNext{
    //1.创建转场动画对象
    CATransition *transition=[[CATransition alloc]init];
    CATransition *transitons = [[CATransition alloc]init];
    transitons.type = @"cube";
     /* `fade', `moveIn', `push' and `reveal'. Defaults to `fade'. */
    if (isNext) {
        transitons.subtype = kCATransitionFromRight;
    }else{
        transitons.subtype = kCATransitionFromLeft;
    }
    transitons.duration = 0.8;
    _imageView.image = [self getImage:isNext];
    [_imageView.layer addAnimation:transitons forKey:@"KCTransitionAnimation"];
    return;
    
    //2.设置动画类型,注意对于苹果官方没公开的动画类型只能使用字符串，并没有对应的常量定义
    transition.type=@"cube";
    
    //设置子类型
    if (isNext) {
        transition.subtype=kCATransitionFromRight;
    }else{
        transition.subtype=kCATransitionFromLeft;
    }
    //设置动画时常
    transition.duration=1.0f;
    
    //3.设置转场后的新视图添加转场动画
    _imageView.image=[self getImage:isNext];
    [_imageView.layer addAnimation:transition forKey:@"KCTransitionAnimation"];
}

#pragma mark 取得当前图片
-(UIImage *)getImage:(BOOL)isNext{
    if (isNext) {
        _currentIndex=(_currentIndex+1)%IMAGE_COUNT;
    }else{
        _currentIndex=(_currentIndex-1+IMAGE_COUNT)%IMAGE_COUNT;
    }
    NSString *imageName=[NSString stringWithFormat:@"%i.jpg",_currentIndex];
    return [UIImage imageNamed:imageName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
