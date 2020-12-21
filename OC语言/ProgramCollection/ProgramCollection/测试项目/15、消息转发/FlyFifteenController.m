//
//  FlyFifteenController.m
//  ProgramCollection
//
//  Created by Qiushan on 2020/12/18.
//  Copyright © 2020 FLY. All rights reserved.
//

#import "FlyFifteenController.h"

extern void instrumentObjcMessageSends(BOOL flag);

@interface Flyteacher : NSObject

+ (void)sayHello;
- (void)sayLove;

@end

@implementation Flyteacher

+ (BOOL)resolveInstanceMethod:(SEL)sel {
 
    NSLog(@"%s %@", __func__, NSStringFromSelector(sel));
    return [super resolveInstanceMethod:sel];
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    
    NSLog(@"%s %@", __func__, NSStringFromSelector(sel));
    return [super resolveClassMethod:sel];
}

@end

@interface FlyFifteenController ()

@property (nonatomic, strong) Flyteacher  *  teacher;

@end

@implementation FlyFifteenController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testMethod];
}

- (void)testMethod {
    
    _teacher = [[Flyteacher alloc] init];
    instrumentObjcMessageSends(true);
    [_teacher sayLove];
    instrumentObjcMessageSends(false);
}

@end
