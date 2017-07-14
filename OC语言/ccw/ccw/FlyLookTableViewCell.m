//
//  FlyLookTableViewCell.m
//  ccw
//
//  Created by walg on 2017/6/22.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import "FlyLookTableViewCell.h"
#import "UIImageView+AFNetworking.h"
@interface FlyLookTableViewCell ()
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong)UILabel *titleLabel;
@end

@implementation FlyLookTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.imageV];
        [self addSubview:self.titleLabel];
    }
    return self;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MainWidth-20, 40)];
        [_titleLabel setFont:[UIFont systemFontOfSize:18]];
        [_titleLabel setTextColor:[UIColor blackColor]];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

-(UIImageView *)imageV{
    if (!_imageV) {
        CGRect frame = CGRectMake((MainWidth-230)/2.0, 50, 230, 230);
        _imageV= [[UIImageView alloc] initWithFrame:frame];
    }
    return _imageV;
}

-(void)setModel:(FlyJokeModel *)model{
    _model = model;
    [self.titleLabel setText:model.title];
    [self.imageV setImageWithURL:[NSURL URLWithString:model.sourceurl]];
}
@end
