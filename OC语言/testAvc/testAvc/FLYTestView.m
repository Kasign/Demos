//
//  FLYTestView.m
//  testAvc
//
//  Created by Walg on 2023/8/1.
//  Copyright © 2023 FLY. All rights reserved.
//

#import "FLYTestView.h"

@interface FLYTestView ()

@property (nonatomic, strong) UILabel *msgLabel;

@end

@implementation FLYTestView

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
    [self.msgLabel setText:[NSString stringWithFormat:@"%p:%@:%p", self, self.name, self.superview]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self logIfNeed:NSStringFromSelector(_cmd)];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self logIfNeed:NSStringFromSelector(_cmd)];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self logIfNeed:NSStringFromSelector(_cmd)];
}

- (void)logIfNeed:(NSString *)msg {
    
    NSLog(@"--->>> \n%@:%p\n%@\n%@\n-------------------------", [self class], self, self.name, msg);
}

- (UILabel *)msgLabel {
    
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40)];
        _msgLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.numberOfLines = 1;
        _msgLabel.font = [UIFont systemFontOfSize:12];
        _msgLabel.textColor = [UIColor blackColor];
    }
    return _msgLabel;
}

@end
