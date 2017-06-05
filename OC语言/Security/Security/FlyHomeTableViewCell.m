//
//  FlyHomeTableViewCell.m
//  Security
//
//  Created by walg on 2017/1/5.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "FlyHomeTableViewCell.h"

@interface FlyHomeTableViewCell()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation FlyHomeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.imgView];
    return self;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel= [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.frame = CGRectMake(30, 0, 140, self.bounds.size.height);
        _titleLabel.textColor = [UIColor lightBlueColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.frame = CGRectMake(6, 0, self.bounds.size.height, self.bounds.size.height);
        _imgView.backgroundColor = [UIColor clearColor];
    }
    return _imgView;
}

-(void)setTitle:(NSString *)title{
    [self.titleLabel setText:title];
}

-(void)setImageName:(NSString *)imageName{
    self.imgView.image = [UIImage imageNamed:imageName];
}

@end
