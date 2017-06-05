//
//  FlyNavigationBar.m
//  FlyLive
//
//  Created by walg on 2016/12/14.
//  Copyright © 2016年 walg. All rights reserved.
//

#import "FlyNavigationBar.h"

@interface FlyNavigationBar ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation FlyNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = YES;
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor whiteColor];
        CALayer *line = [CALayer layer];
        line.frame = CGRectMake(0, frame.size.height-1, frame.size.width, 0.5);
        line.backgroundColor = [UIColor lightGrayColor].CGColor;
        [self.layer addSublayer:line];
        _titleColor = [UIColor blackColor];
        _titleFont = [UIFont systemFontOfSize:16];
    }
    return self;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, self.bounds.size.height-44, self.bounds.size.width-88, 44)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = _titleColor;
        _titleLabel.font =_titleFont;
        _titleLabel.opaque = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    if (_title) {
        self.centerView = self.titleLabel;
        self.titleLabel.text = _title;
    }
}

-(void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    if (_titleColor) {
            self.titleLabel.textColor = _titleColor;
    }
}

-(void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;
    if (_titleFont) {
        self.titleLabel.font = _titleFont;
    }
}

-(void)setCenterView:(UIView *)centerView{
    if (centerView) {
        [_centerView removeFromSuperview];
        _centerView = centerView;
        _centerView.center = CGPointMake(self.frame.size.width/2.0f, self.frame.size.height-22.0f);
        [self addSubview:_centerView];
    }
}

- (void)setLeftBtn:(UIButton *)leftBtn
{
    [_leftBtn removeFromSuperview];
    
    if(leftBtn){
        _leftBtn = leftBtn;
        if (_leftBtn.bounds.size.width > 44) {
            _leftBtn.center = CGPointMake(_leftBtn.bounds.size.width/2.0f, self.frame.size.height-22.0f);
        }else{
            _leftBtn.center = CGPointMake(_leftBtn.bounds.size.width/2.0f+14, self.frame.size.height-22.0f);
        }
        [self addSubview:_leftBtn];
    }
}

- (void)setRightBtn:(UIButton *)rightBtn
{
    [_rightBtn removeFromSuperview];
    if (rightBtn) {
        _rightBtn = rightBtn;
        if (_rightBtn.bounds.size.width > 44) {
            _rightBtn.center = CGPointMake(self.frame.size.width-_rightBtn.bounds.size.width/2.0f, self.frame.size.height-22.0f);
        }else{
            _rightBtn.center = CGPointMake(self.frame.size.width-_rightBtn.bounds.size.width/2.0f-12, self.frame.size.height-22.0f);
        }
        [self addSubview:_rightBtn];
    }
    else{
        _rightBtn = nil;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.bounds = CGRectMake(0, 0,  self.bounds.size.width-88, 44);
    self.titleLabel.center = CGPointMake(self.frame.size.width/2.0f, self.frame.size.height-22.0f);
}
@end
