//
//  LQStoryCardCollectionCell.m
//  Unity-iPhone
//
//  Created by qiuShan on 2017/9/19.
//
//

#import "LQStoryCardCollectionCell.h"

@interface LQStoryCardCollectionCell ()

@property (nonatomic, strong) UIVisualEffectView  *  allBlurView;

@property (nonatomic, strong) UIImageView * avatarView;

@property (nonatomic, strong) UILabel     *  nameLabel;

@property (nonatomic, strong) CALayer     *  leftLineLayer;

@property (nonatomic, strong) CALayer     *  rightLineLayer;

@property (nonatomic, strong) UILabel     *  titleLabel;

@property (nonatomic, strong) UITextView  *  contentTV;

@property (nonatomic, strong) UIImageView *  leftImageView;

@end

@implementation LQStoryCardCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [[UIColor grayColor] colorWithAlphaComponent:0.8].CGColor;
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowOffset = CGSizeMake(0, -2.0);
        
        [self.contentView addSubview:self.leftImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentTV];
        [self.contentView.layer addSublayer:self.leftLineLayer];
        [self.contentView.layer addSublayer:self.rightLineLayer];
    }
    return self;
}

-(UIVisualEffectView*)allBlurView{
    if (!_allBlurView) {
        _allBlurView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _allBlurView.frame =self.bounds;
        _allBlurView.alpha = 0.02;
    }
    return _allBlurView;
}

-(UIImageView *)avatarView{
    if (!_avatarView) {
        CGFloat width = 40;
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        [_avatarView setBackgroundColor:[UIColor whiteColor]];
        [_avatarView setCenter:CGPointMake(self.bounds.size.width/2.0, 0)];
        [_avatarView setContentMode:UIViewContentModeScaleAspectFit];
        _avatarView.layer.cornerRadius = width/2.0;
        _avatarView.layer.masksToBounds = YES;
        _avatarView.layer.borderWidth = 2.0f;
        _avatarView.layer.borderColor = [UIColor whiteColor].CGColor;
        [_avatarView setImage:[UIImage imageNamed:@"brain_defaultAv"]];
    }
    return _avatarView;
}

-(UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
        [_leftImageView setContentMode:UIViewContentModeScaleAspectFit];
        [_leftImageView setImage:[UIImage imageNamed:@"brain_pCard"]];
    }
    return _leftImageView;
}


-(CALayer *)leftLineLayer{
    if (!_leftLineLayer) {
        _leftLineLayer = [CALayer layer];
        [_leftLineLayer setFrame:CGRectMake(CGRectGetMinX(self.nameLabel.frame)-7-33, self.nameLabel.center.y-0.5, 33, 1.0)];
        [_leftLineLayer setBackgroundColor:[UIColor greenColor].CGColor];
    }
    return _leftLineLayer;
}

-(CALayer *)rightLineLayer{
    if (!_rightLineLayer) {
        _rightLineLayer = [CALayer layer];
        [_rightLineLayer setFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame)+7, self.nameLabel.center.y-0.5, 33, 1.0)];
        [_rightLineLayer setBackgroundColor:[UIColor grayColor].CGColor];
    }
    return _rightLineLayer;
}


-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, self.bounds.size.width, 14)];
        [_nameLabel setTextColor:[UIColor grayColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [_nameLabel setFont:[UIFont systemFontOfSize:12]];
    }
    return _nameLabel;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, self.bounds.size.width, 18)];
        [_titleLabel setTextColor:[UIColor blueColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    }
    return _titleLabel;
}

-(UITextView *)contentTV{
    if (!_contentTV) {
        _contentTV = [[UITextView alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(self.titleLabel.frame)+12, self.bounds.size.width-44, 60)];
        _contentTV.selectable = NO;
        _contentTV.userInteractionEnabled = NO;
        _contentTV.editable = NO;
        _contentTV.font = [UIFont systemFontOfSize:14];
        [_contentTV setTextAlignment:NSTextAlignmentLeft];
    }
    return _contentTV;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    
    [self.nameLabel setText:[NSString stringWithFormat:@"%@",title]];
    [self.nameLabel sizeToFit];
    
    [self.titleLabel setText:@"雨夜晕倒与男神"];
    
    NSString *contentText =@"政知见梳理发现，国家主席、国务院总理是每次必见。李显龙2004年8月就任新加坡政府总理，2006年、2011年连任总理。就任总理以来，他已先后于2005年、2008年以及2012年、2013年访华。2005年首次访华，李显龙在北京参加了一系列的领导人会晤，其中包括同时任国务院总理温家宝的会谈，还有与时任国家主席胡锦涛、时任全国人大常委会委员长吴邦国和时任全国政协主席贾庆林的会见。";
    
    
    NSMutableAttributedString * attriAtr = [[NSMutableAttributedString alloc]initWithString:contentText];
    NSMutableParagraphStyle *paragraphStyle =[[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [attriAtr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, contentText.length)];
    [self.contentTV setAttributedText:attriAtr];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat centerX = self.bounds.size.width/2.0f;
    
//    [self.avatarView setCenter:CGPointMake(centerX, 0)];
    
    [self.nameLabel sizeToFit];
    
    [self.nameLabel setCenter:CGPointMake(centerX, CGRectGetMaxY(self.avatarView.frame)+CGRectGetHeight(self.nameLabel.frame)/2.0+5)];
    
    [self.leftLineLayer setFrame:CGRectMake(CGRectGetMinX(self.nameLabel.frame)-7-33, self.nameLabel.center.y-0.5, 33, 1.0)];
    
    [self.rightLineLayer setFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame)+7, self.nameLabel.center.y-0.5, 33, 1.0)];
    
    [self.titleLabel setCenter:CGPointMake(centerX, CGRectGetMaxY(self.nameLabel.frame)+16+CGRectGetHeight(self.titleLabel.frame))];
    
    [self.contentTV setFrame:CGRectMake(22, CGRectGetMaxY(self.titleLabel.frame)+12, self.bounds.size.width-44, 60)];
}

@end
