//
//  FlyFifteenController.m
//  ProgramCollection
//
//  Created by Qiushan on 2020/12/18.
//  Copyright © 2020 FLY. All rights reserved.
//

#import "FlyFifteenController.h"

/**
 实际用途：https://www.jianshu.com/p/fdd8f5225f0c
 
 1.JSPatch --iOS动态化更新方案
 2.为 @dynamic 实现方法
 3.实现多重代理
 4.间接实现多继承
 
 转发流程：
 1、+ (BOOL)resolveInstanceMethod:(SEL)sel
 2、- (id)forwardingTargetForSelector:(SEL)aSelector
 3、- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
   - (void)forwardInvocation:(NSInvocation *)invocation
 
 */

extern void instrumentObjcMessageSends(BOOL flag);

@interface Flyteacher : NSObject

+ (void)sayHello;
- (void)sayLove;

@end

/**
 2024-03-07 10:58:27 +0000  +[Flyteacher resolveInstanceMethod:] sayLove
 2024-03-07 10:58:27 +0000  -[Flyteacher forwardingTargetForSelector:] sayLove
 2024-03-07 10:58:27 +0000  -[Flyteacher methodSignatureForSelector:] sayLove
 2024-03-07 10:58:27 +0000  +[Flyteacher resolveInstanceMethod:] sayLove
 2024-03-07 10:58:27 +0000  -[Flyteacher forwardInvocation:] sayLove
 */
@implementation Flyteacher

/**
 第一步 是否解决了实例的方法
 */
+ (BOOL)resolveInstanceMethod:(SEL)sel {
 
    FLYLog(@"%s %@", __func__, NSStringFromSelector(sel));
    return [super resolveInstanceMethod:sel];
}

/**
 第二步 根据方法给出要实现的对象，消息转发给对应的对象
 */
- (id)forwardingTargetForSelector:(SEL)aSelector {
    
    FLYLog(@"%s %@", __func__, NSStringFromSelector(aSelector));
    return [super forwardingTargetForSelector:aSelector];
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    
    NSLog(@"%s %@", __func__, NSStringFromSelector(sel));
    return [super resolveClassMethod:sel];
}

+ (IMP)instanceMethodForSelector:(SEL)aSelector {
    
    FLYLog(@"%s %@", __func__, NSStringFromSelector(aSelector));
    return [super instanceMethodForSelector:aSelector];
}

- (IMP)methodForSelector:(SEL)aSelector {
    
    FLYLog(@"%s %@", __func__, NSStringFromSelector(aSelector));
    return [super methodForSelector:aSelector];
}

/**
 第三步 根据方法，给出方法信号
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {

    FLYLog(@"%s %@", __func__, NSStringFromSelector(selector));
    if ([self respondsToSelector:selector]) {
        return [[self class] instanceMethodSignatureForSelector:selector];
    }
    return [NSObject instanceMethodSignatureForSelector:@selector(description)];
}

/**
 第三步 根据方法，给出方法信号
 */
- (void)forwardInvocation:(NSInvocation *)invocation {
    
    FLYLog(@"%s %@", __func__, NSStringFromSelector(invocation.selector));
    SEL selector = [invocation selector];
    if ([self respondsToSelector:selector]) {
        [invocation invokeWithTarget:self];
        return;
    }
    void *null = NULL;
    [invocation setReturnValue:&null];
}

+ (NSMethodSignature *)instanceMethodSignatureForSelector:(SEL)aSelector {
    
    FLYLog(@"%s %@", __func__, NSStringFromSelector(aSelector));
    if ([self respondsToSelector:aSelector]) {
        return [[self class] instanceMethodSignatureForSelector:aSelector];
    }
    return [NSObject instanceMethodSignatureForSelector:@selector(description)];
}

@end

@interface FlyFifteenController ()

@property (nonatomic, strong) Flyteacher  *teacher;

@end

@implementation FlyFifteenController

+ (NSString *)functionName {
    
    return @"消息转发";
}

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
