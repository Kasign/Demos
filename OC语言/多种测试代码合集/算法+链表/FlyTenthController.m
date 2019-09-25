//
//  FlyTenthController.m
//  算法+链表
//
//  Created by mx-QS on 2019/9/25.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "FlyTenthController.h"
#import "NSObject+FlyKVO.h"
#import "Person.h"
#import "Dog.h"

@interface FlyTenthController ()

@property (nonatomic, strong) Person   *   p;
@property (nonatomic, strong) Dog      *   d;

@end

@implementation FlyTenthController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _p = [[Person alloc] init];
    
    
    _d = [[Dog alloc] init];
    
//    [_p addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    [_p fly_addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:nil];
    
    [FlyRuntimeTool loopInstanceSuperClass:_d];
    
    _p.name = @"nick";
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
    FLYLog(@" 来了 -->>%@ ---->>>>  %@", object, change);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    _p.name = @"XIIXIXIXI";
    _p.age  = _p.age ++;
}

@end
