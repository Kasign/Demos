//
//  FlyDetailTableViewCell.m
//  ccc
//
//  Created by walg on 2017/5/23.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "FlyDetailTableViewCell.h"
@interface FlyDetailTableViewCell ()
@property (nonatomic, strong) UILabel  *topLabel1;
@property (nonatomic, strong) UILabel  *topLabel2;
@property (nonatomic, strong) UILabel  *topLabel3;
@end
@implementation FlyDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _topLabel1 = [self creatLable];
        _topLabel1.frame = CGRectMake(18, 8, self.frame.size.width/2.0, 30);
//        [_topLabel1 setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.3]];
        
        _topLabel2 = [self creatLable];
        _topLabel2.frame = CGRectMake( self.frame.size.width/2.0, 8, 200, 30);
//        [_topLabel2 setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
        
        _topLabel3 = [self creatLable];
        _topLabel3.frame = CGRectMake(18, 38, 200, 30);
        [_topLabel3 setTextAlignment:NSTextAlignmentCenter];
        [_topLabel3 setFont:[UIFont systemFontOfSize:14]];
        [_topLabel3 setTextColor:[UIColor redColor]];
//        [_topLabel3 setBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.3]];
        
        [self addSubview:_topLabel1];
        [self addSubview:_topLabel2];
        [self addSubview:_topLabel3];
    }
    return self;
}

-(UILabel*)creatLable{
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setTextColor:[UIColor blackColor]];
    return label;
}

-(void)setModel:(FlyDetailModel *)model{
    _model = model;
    [self.topLabel1 setText:[NSString stringWithFormat:@"第%@期", _model.expect]];
    [self.topLabel2 setText:_model.opentime];
    [self.topLabel3 setText:_model.opencode];
}



@end
