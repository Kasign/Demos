//
//  FlyHallCell.m
//  ccc
//
//  Created by walg on 2017/5/23.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "FlyHallCell.h"
@interface FlyHallCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLable;
@end
@implementation FlyHallCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.layer.shadowRadius = 1;
        
//        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
        self.layer.masksToBounds = NO;
//        self.layer.shadowColor = [UIColor blackColor].CGColor;
//        self.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
        self.layer.shadowOpacity = 0.5f;
//        self.layer.shadowPath = shadowPath.CGPath;
        
        [self creatViews];
    }
    return self;
}

-(void)creatViews{
    CGFloat distance = 20;
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    _imageView.center = CGPointMake(self.frame.size.width/2.0, _imageView.frame.size.height/2.0);
    _imageView.backgroundColor = [UIColor clearColor];
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [self addSubview:_imageView];
    
    _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame), self.frame.size.width, 20)];
    [_titleLable setTextColor:[UIColor blackColor]];
    [_titleLable setFont:[UIFont systemFontOfSize:14]];
    [_titleLable setTextAlignment:NSTextAlignmentCenter];
    
    [self addSubview:_titleLable];

}

-(void)setKind:(NSString *)kind{
    _kind = kind;
    [_titleLable setText:_title];
    
    NSString *url = [NSString stringWithFormat:@"http://www.opencai.net/static/v2/logos/%@.gif",_kind];
    
    UIImage *image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    
    [_imageView setImage:image];
    
}



@end
