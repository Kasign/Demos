//
//  FlyTableViewCell.m
//  TableViewTest
//
//  Created by Walg on 2017/9/26.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import "FlyTableViewCell.h"
#import "FlyMyView.h"

@interface FlyTableViewCell()
@property (nonatomic,strong)UIView * view1;
@property (nonatomic,strong)UIView * view2;
@property (nonatomic,strong)FlyMyView *myView;
@end

@implementation FlyTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.view1];
        [self.contentView addSubview:self.view2];
        [self.contentView addSubview:self.myView];
        
        UIButton *deleBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 20, 80, 30)];
        [deleBtn setBackgroundColor:[UIColor grayColor]];
        [deleBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleBtn addTarget:self action:@selector(deleteSelfAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:deleBtn];
    }
    return self;
}

-(void)deleteSelfAction{
    if (_deleBlock) {
        _deleBlock(self);
    }
}

-(UIView *)view1{
    if (!_view1) {
        _view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, 50)];
        [_view1 setBackgroundColor:[UIColor grayColor]];
    }
    return _view1;
}

-(UIView *)view2{
    if (!_view2) {
        _view2 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view1.frame), CGRectGetMaxY(self.view1.frame), 100, 20+CGRectGetHeight(self.view1.frame))];
        [_view2 setBackgroundColor:[UIColor yellowColor]];
    }
    return _view2;
}

-(FlyMyView *)myView{
    if (!_myView) {
        _myView = [[FlyMyView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view2.frame), CGRectGetMaxY(self.view2.frame)+2, 100, 80)];
        [_myView setBackgroundColor:[[UIColor blueColor]colorWithAlphaComponent:0.2]];
    }
    return _myView;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    [self.view1 setFrame:CGRectMake(0, 0, 110, 50)];
    
    [self.view2 setFrame:CGRectMake(CGRectGetMaxX(self.view1.frame), CGRectGetMaxY(self.view1.frame), 100, 20+CGRectGetHeight(self.view1.frame))];
    
    [self.myView setFrame:CGRectMake(CGRectGetMaxX(self.view2.frame), CGRectGetMaxY(self.view2.frame)+2, self.bounds.size.width-CGRectGetMaxX(self.view2.frame)-10, self.bounds.size.height-CGRectGetMaxY(self.view2.frame))];
    
    
    
//    [self.myView setFrame:CGRectMake(CGRectGetMaxX(self.view2.frame), CGRectGetMaxY(self.view2.frame)+2, self.bounds.size.width-CGRectGetMaxX(self.view2.frame)-10, 80)];

    
    [self.myView layoutIfNeeded];
}



@end
