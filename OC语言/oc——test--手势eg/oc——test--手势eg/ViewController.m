//
//  ViewController.m
//  oc——test--手势eg
//
//  Created by walg on 2017/7/24.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;
@property (nonatomic, strong) UIView *view4;
@property (nonatomic, strong) UILabel *label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view addSubview:self.view1];
//    [self.view1 addSubview:self.view2];
//    [self.view1 addSubview:self.view3];
    _label  = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 40, 30)];
    [_label setBackgroundColor:[UIColor grayColor]];
    [_label setText:@"123"];
    [self.view addSubview:_label];
    [_label addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}
- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context{
    NSLog(@"keyPath = %@",keyPath);
    NSLog(@"change = %@",change);
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_label setText:@"123"];
}

-(UIView *)view1{
    if (!_view1) {
        _view1 = [[UIView alloc] initWithFrame:CGRectMake(10, 80, 300, 400)];
        [_view1 setBackgroundColor:[UIColor purpleColor]];
        [_view1 setUserInteractionEnabled:YES];
        UISwipeGestureRecognizer *swipG = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipAction:)];
//        swipG.enabled = NO;
        [_view1 addGestureRecognizer:swipG];
        
    }
    return _view1;
}

-(UIView *)view2{
    if (!_view2) {
        _view2 = [[UIView alloc] initWithFrame:CGRectMake(10, 40, 300, 400)];
        [_view2 setBackgroundColor:[UIColor yellowColor]];
        [_view2 setUserInteractionEnabled:YES];
        UILongPressGestureRecognizer *longG = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
//        swipG.enabled = NO;
        [_view2 addGestureRecognizer:longG];
        
    }
    return _view2;
}

-(UIView *)view3{
    if (!_view3) {
        _view3 = [[UIView alloc] initWithFrame:CGRectMake(10, 80, 300, 400)];
        [_view3 setBackgroundColor:[UIColor blueColor]];
        [_view3 setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.enabled = NO;
        [_view3 addGestureRecognizer:tap];
        
    }
    return _view3;
}

-(UIView *)view4{
    if (!_view4) {
        _view4 = [[UIView alloc] initWithFrame:CGRectMake(10, 80, 300, 400)];
        [_view4 setBackgroundColor:[UIColor purpleColor]];
        [_view4 setUserInteractionEnabled:YES];
        UISwipeGestureRecognizer *swipG = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipAction:)];
        swipG.enabled = NO;
        [_view4 addGestureRecognizer:swipG];
        
    }
    return _view4;
}

-(void)panAction:(UIPanGestureRecognizer*)pan{
    NSLog(@"view4 - panAction");
}

-(void)longAction:(UILongPressGestureRecognizer*)longG{
    NSLog(@"view2 - longAction");
}

-(void)swipAction:(UISwipeGestureRecognizer*)swipG{
    NSLog(@"view1-swipAction");
}

-(void)tapAction:(UITapGestureRecognizer*)tap{
    NSLog(@"view3-tapAction");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
