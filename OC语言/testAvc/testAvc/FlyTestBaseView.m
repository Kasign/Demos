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


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *t = [super hitTest:point withEvent:event];
    if (t) {
        NSLog(@"HIT:--->>>\n%@", [t description]);
    }
    return t;
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"<%@ %p %@>", self.class, self, self.name];
}

@end
