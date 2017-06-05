//
//  FlyBasicViewController.h
//  Security
//
//  Created by walg on 2017/1/4.
//  Copyright © 2017年 walg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FlyNavigationBar.h"

@interface FlyBasicViewController : UIViewController
/**
 *  系统状态条高度
 *  iOS6 is 0.0f, iOS7 is 20.0f
 */
@property (nonatomic, assign, readonly) CGFloat statusBarHeight;
/**
 *  导航条高度
 *  iOS6 is 44.0f, iOS7 is 64.0f
 */
@property (nonatomic, assign, readonly) CGFloat navigationBarHeight;
/**
 *  tabbar高度 50.0f
 */
@property (nonatomic, assign, readonly) CGFloat tabBarHeight;
/**
 *  返回按钮是否显示
 *  default is YES
 */
@property (nonatomic, getter = isBackBtnHidden) BOOL backBtnHidden;

/**
 是否支持旋转
 */
@property (nonatomic, assign) BOOL isSupportAutorotate;

/**
 导航栏是否隐藏
 */
@property (nonatomic, assign) BOOL navigationBarHidden;

/**
 导航栏
 */
@property (nonatomic, strong) FlyNavigationBar *navigationBar;

/**
 返回按钮
 */
@property (nonatomic, strong) UIButton *popBackBtn;

@end
