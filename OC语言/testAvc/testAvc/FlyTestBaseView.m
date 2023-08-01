//
//  FlyTestBaseView.m
//  testAvc
//
//  Created by Walg on 2023/8/1.
//  Copyright © 2023 FLY. All rights reserved.
//

#import "FlyTestBaseView.h"

@interface FlyTestBaseView ()

@property (nonatomic, strong) UILabel *msgLabel;

@end

@implementation FlyTestBaseView


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self logIfNeed:NSStringFromSelector(_cmd)];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self logIfNeed:NSStringFromSelector(_cmd)];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self logIfNeed:NSStringFromSelector(_cmd)];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self logIfNeed:NSStringFromSelector(_cmd)];
}

- (void)logIfNeed:(NSString *)msg {
    
    NSLog(@"--->>> \n%@:%p\n%@\n%@\n-------------------------", [self class], self, self.name, msg);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *t = [super hitTest:point withEvent:event];
    if (t) {
        NSLog(@"HIT:--->>>\n%@:%p", t.class, t);
    }
    return t;
}

@end
