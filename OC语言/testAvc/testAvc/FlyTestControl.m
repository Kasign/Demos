//
//  FlyTestControl.m
//  testAvc
//
//  Created by Walg on 2023/8/1.
//  Copyright © 2023 FLY. All rights reserved.
//

#import "FlyTestControl.h"
#import "UIView+FLYTouch.h"

@interface FlyTestControl ()

@property (nonatomic, strong) UILabel *msgLabel;

@end

@implementation FlyTestControl

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfig];
    }
    return self;
}

- (void)initConfig {
    
    [self addSubview:self.msgLabel];
}

- (void)didMoveToSuperview {
    
    [super didMoveToSuperview];
    [self.msgLabel setText:[NSString stringWithFormat:@"Self:%@\nSuper:%@", [self description], self.superview.description]];
    [self resetMsgLabel];
}

- (void)resetMsgLabel {
    
    [self.msgLabel sizeToFit];
    self.msgLabel.frame = CGRectMake(0, self.bounds.size.height - self.msgLabel.bounds.size.height, self.bounds.size.width, self.msgLabel.bounds.size.height);
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//    [self logMsg:NSStringFromSelector(_cmd)];
//    [super touchesBegan:touches withEvent:event];
//}
//
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//    [self logMsg:NSStringFromSelector(_cmd)];
//    [super touchesMoved:touches withEvent:event];
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//    [self logMsg:NSStringFromSelector(_cmd)];
//    [super touchesEnded:touches withEvent:event];
//}
//
//- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//    [self logMsg:NSStringFromSelector(_cmd)];
//    [super touchesCancelled:touches withEvent:event];
//}

- (UILabel *)msgLabel {
    
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 100)];
        _msgLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.numberOfLines = 0;
        _msgLabel.font = [UIFont systemFontOfSize:12];
        _msgLabel.textColor = [UIColor blackColor];
        _msgLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    }
    return _msgLabel;
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"<%@ %p %@>", self.class, self, self.name];
}

@end
