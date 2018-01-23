//
//  FlyUserInfoTableViewCell.m
//  Security
//
//  Created by walg on 2017/1/5.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "FlyUserInfoTableViewCell.h"
@interface FlyUserInfoTableViewCell ()
@property (nonatomic, strong) UISwitch *switchButton;
@end

@implementation FlyUserInfoTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryCheckmark;
        self.accessoryView = self.switchButton;
    }
    return self;
}

-(UISwitch *)switchButton
{
    if (!_switchButton) {
        _switchButton = [[UISwitch alloc] init];
        [_switchButton addTarget:self action:@selector(switchClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

-(void)setIsOn:(BOOL)isOn
{
    _isOn = isOn;
    self.switchButton.on = isOn;
}

-(void)switchClickAction:(UISwitch*)sender
{
    _clickBlock(sender.on);
}


@end
