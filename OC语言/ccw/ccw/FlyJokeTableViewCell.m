//
//  FlyJokeTableViewCell.m
//  ccw
//
//  Created by Walg on 2017/6/25.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import "FlyJokeTableViewCell.h"
@interface FlyJokeTableViewCell ()
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *contentLabel;
@end

@implementation FlyJokeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.contentLabel];
    }
    return self;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MainWidth-20, 20)];
        [_titleLabel setFont:[UIFont systemFontOfSize:18]];
        [_titleLabel setTextColor:[UIColor blackColor]];
    }
    return _titleLabel;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, MainWidth-20, 20)];
        [_contentLabel setFont:[UIFont systemFontOfSize:14]];
        [_contentLabel setTextColor:[UIColor blackColor]];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

-(void)setModel:(FlyJokeModel *)model{
    _model = model;
    CGFloat height = [FlyJokeTableViewCell heightForCellWithContent:model.content];
    [self.contentLabel setFrame:CGRectMake(10, 30, MainWidth-20, height)];
    [self.titleLabel setText:model.title];
    [self.contentLabel setText:model.content];
}

+(CGFloat)heightForCellWithContent:(NSString*)content{
    CGFloat height=0;
    CGSize size = [content boundingRectWithSize:CGSizeMake(MainWidth-20, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    
    height = size.height;
    return height;
}

@end
