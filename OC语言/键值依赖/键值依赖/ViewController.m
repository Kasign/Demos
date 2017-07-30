//
//  ViewController.m
//  键值依赖
//
//  Created by Walg on 2017/7/30.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import "ViewController.h"
#import "Card.h"
#import <objc/runtime.h>

@interface ViewController ()
@property (nonatomic,strong)Card *userCard;
@end

@implementation ViewController


static NSInteger NewAge(){
    static NSInteger newAge = 10;
    return newAge++;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _userCard = [[Card alloc] init];
    _userCard.user1.pName = @"a";
    _userCard.user1.age = 18;
    
    NSLog(@"前类名：%@",NSStringFromClass(object_getClass(_userCard)));
    [self.userCard addObserver:self forKeyPath:@"totalAge" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    NSLog(@"后类名：%@",NSStringFromClass(object_getClass(_userCard)));

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"keyPath:%@",keyPath);
    NSLog(@"object:%@",object);
    NSLog(@"change:%@",change);
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.userCard.user2.age = NewAge();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
