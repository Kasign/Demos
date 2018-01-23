//
//  FlyNavigationBar.h
//  FlyLive
//
//  Created by walg on 2016/12/14.
//  Copyright © 2016年 walg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlyNavigationBar : UIView

@property (nonatomic, copy)   NSString  * title;
@property (nonatomic, strong) UIColor   * titleColor;
@property (nonatomic, strong) UIFont    * titleFont;

@property (nonatomic, strong) UIView    * centerView;

@property (nonatomic, strong) UIButton  * leftBtn;
@property (nonatomic, strong) UIButton  * rightBtn;

@end
