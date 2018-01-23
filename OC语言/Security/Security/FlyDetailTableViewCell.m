//
//  FlyDetailTableViewCell.m
//  Security
//
//  Created by walg on 2017/1/5.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "FlyDetailTableViewCell.h"

@interface FlyDisPlayTableViewCell()
@property (nonatomic, strong) UIButton  *  securityButton;
@end

@implementation FlyDisPlayTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.leftField];
        [self.contentView addSubview:self.rightField];
        [self.contentView addSubview:self.securityButton];
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(70, 0, 0.5, self.frame.size.height - 1.f);
        layer.backgroundColor = [UIColor lightGrayColor].CGColor;
        [self.contentView.layer addSublayer:layer];
    }
    return self;
}

- (UITextField *)leftField
{
    if (!_leftField) {
        _leftField = [[UITextField alloc] init];
        _leftField.frame = CGRectMake(0, 0, 66, self.frame.size.height);
        _leftField.enabled = NO;
        _leftField.backgroundColor = [UIColor clearColor];
        _leftField.textColor = [UIColor blueColor];
        _leftField.font = [UIFont systemFontOfSize:Fly_FontSize];
        _leftField.textAlignment = NSTextAlignmentRight;
    }
    return _leftField;
}

- (UITextField *)rightField
{
    if (!_rightField) {
        _rightField = [[UITextField alloc] init];
        _rightField.frame = CGRectMake(73, 0, self.frame.size.width-75, self.frame.size.height);
        _rightField.backgroundColor = [UIColor clearColor];
        _rightField.textColor = [UIColor blueColor];
        _rightField.font = [UIFont systemFontOfSize:Fly_FontSize];
        _rightField.textAlignment = NSTextAlignmentLeft;
    }
    return _rightField;
}

- (UIButton *)securityButton
{
    if (!_securityButton) {
        _securityButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 30.f, (CGRectGetHeight(self.frame) - 20)/2.0, 20, 20)];
        [_securityButton.layer setCornerRadius:10.f];
        [_securityButton.layer setMasksToBounds:YES];
        [_securityButton.layer setBorderColor:[UIColor redColor].CGColor];
        [_securityButton.layer setBorderWidth:1.0f];
        [_securityButton setTitle:@"显" forState:UIControlStateNormal];
        [_securityButton setTitle:@"隐" forState:UIControlStateSelected];
        [_securityButton.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
        [_securityButton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
        [_securityButton addTarget:self action:@selector(showPassword:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _securityButton;
}

- (void)setLeftString:(NSString *)leftString
{
    [self.leftField setText:leftString];
}

- (void)setRightString:(NSString *)rightString
{
    [self.rightField setText:rightString];
}

- (void)setTag:(NSInteger)tag
{
    self.rightField.tag = tag;
}

- (void)setShowSecurityButton:(BOOL)showSecurityButton
{
    _showSecurityButton = showSecurityButton;
    if (self.securityButton) {
        self.securityButton.hidden = !showSecurityButton;
    }
}

- (void)showPassword:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.rightField setSecureTextEntry:NO];
    } else {
        [self.rightField setSecureTextEntry:YES];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.securityButton setFrame:CGRectMake(CGRectGetWidth(self.frame) - 30.f, (CGRectGetHeight(self.frame) - 20)/2.0, 20, 20)];
}
@end
