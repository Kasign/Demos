//
//  FlyDetailTableViewCell.m
//  Security
//
//  Created by walg on 2017/1/5.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "FlyDetailTableViewCell.h"

@interface FlyDetailTableViewCell()

@end

@implementation FlyDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.leftField];
    [self.contentView addSubview:self.rightField];
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(70, 0, 0.5, self.frame.size.height);
    layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.contentView.layer addSublayer:layer];
    return self;
}

-(UITextField *)leftField{
    if (!_leftField) {
        _leftField = [[UITextField alloc] init];
        _leftField.frame = CGRectMake(0, 0, 66, self.frame.size.height);
        _leftField.enabled = NO;
        _leftField.backgroundColor = [UIColor clearColor];
        _leftField.textColor = [UIColor blueColor];
        _leftField.font = [UIFont systemFontOfSize:14];
        _leftField.textAlignment = NSTextAlignmentRight;
    }
    return _leftField;
}

-(UITextField *)rightField{
    if (!_rightField) {
        _rightField = [[UITextField alloc] init];
        _rightField.frame = CGRectMake(73, 0, self.frame.size.width-75, self.frame.size.height);
        _rightField.backgroundColor = [UIColor clearColor];
        _rightField.textColor = [UIColor blueColor];
        _rightField.font = [UIFont systemFontOfSize:14];
        _rightField.textAlignment = NSTextAlignmentLeft;
    }
    return _rightField;
}

-(void)setLeftString:(NSString *)leftString{
    [self.leftField setText:leftString];
}

-(void)setRightString:(NSString *)rightString{
    [self.rightField setText:rightString];
}

-(void)setTag:(NSInteger)tag{
    self.rightField.tag = tag;
}

@end

@interface FlyDisPlayTableViewCell()
@property (nonatomic, strong) UILabel *leftLable;
@property (nonatomic, strong) UILabel *rightLabel;
@end

@implementation FlyDisPlayTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self.contentView addSubview:self.leftLable];
    [self.contentView addSubview:self.rightLabel];
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(70, 0, 0.5, self.frame.size.height);
    layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.contentView.layer addSublayer:layer];
    return self;
}

-(UILabel *)leftLable{
    if (!_leftLable) {
        _leftLable = [[UILabel alloc] init];
        _leftLable.frame = CGRectMake(0, 0, 66, self.frame.size.height);
        _leftLable.backgroundColor = [UIColor clearColor];
        _leftLable.textColor = [UIColor blueColor];
        _leftLable.font = [UIFont systemFontOfSize:10];
        _leftLable.textAlignment = NSTextAlignmentRight;
    }
    return _leftLable;
}

-(UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.frame = CGRectMake(73, 0, self.frame.size.width-75, self.frame.size.height);
        _rightLabel.backgroundColor = [UIColor clearColor];
        _rightLabel.textColor = [UIColor blueColor];
        _rightLabel.font = [UIFont systemFontOfSize:10];
        _rightLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _rightLabel;
}

-(void)setTag:(NSInteger)tag{
    self.rightLabel.tag = tag;
}


-(void)setLeftString:(NSString *)leftString{
    [self.leftLable setText:leftString];
}

-(void)setRightString:(NSString *)rightString{
     [self.rightLabel setText:rightString];
}

@end
