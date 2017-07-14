//
//  FlyTabBarViewController.m
//  ccw
//
//  Created by Walg on 2017/5/20.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import "FlyTabBarViewController.h"
#import "FlyFirstViewController.h"
#import "FlySecondViewController.h"
#import "FlyThirdViewController.h"
#import "FlyFourthViewController.h"
#import "FlyWebViewController.h"
#import "FlyHallViewController.h"
#import "UIButton+NMCategory.h"
@interface FlyTabBarViewController ()
@property (nonatomic,assign)NSInteger tag;
@property (nonatomic, strong) UIButton *topButton;
@end

@implementation FlyTabBarViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(UIButton *)topButton{
    if (!_topButton) {
        CGFloat width = 50;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(MainWidth-width+14, 300,width, width)];
        btn.backgroundColor = [UIColor clearColor];
//        [btn setImage:[UIImage imageNamed:@"luckClick"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"clickluck"] forState:UIControlStateNormal];
        [btn setTitle:@"运" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        
        [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [btn setDragEnable:YES];
        [btn setAdsorbEnable:YES];
        [btn.layer addAnimation:[self addBasicAnimation] forKey:@"basicAnimation"];
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(topButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
        _topButton = btn;
    }
    return _topButton;
}

-(CAAnimation*)addBasicAnimation{
    CGFloat time = 4;
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAnimation.fromValue=[NSNumber numberWithFloat:0];
    basicAnimation.toValue=[NSNumber numberWithFloat:M_PI*2];
    basicAnimation.duration=time;
    basicAnimation.repeatCount=HUGE_VALF;
    basicAnimation.removedOnCompletion = NO;
    return basicAnimation;
}

-(void)topButtonClickAction{
    CGFloat time = 0.4;
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAnimation.toValue=[NSNumber numberWithFloat:M_PI_2*8];
    basicAnimation.duration=time;
    basicAnimation.repeatCount=1;
    basicAnimation.autoreverses = YES;
    basicAnimation.removedOnCompletion=YES;
    [self.topButton.layer addAnimation:basicAnimation forKey:@"roatAnimation"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2*time* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self setSelectedIndex:2];
    });
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.tabBar setBackgroundColor:[UIColor lightGrayColor]];
    [self setAllViewControllers];
    [self.view addSubview:self.topButton];
    [self getData];
//    [self uploadData];
}

-(void)getData{
    [[FlyDataManager sharedInstance]getAppStateBlock:^(NSInteger state) {
        _tag = state;
        [self swichController];
    }];
}

-(void)uploadData{
    
    NSArray *array = @[@"DLT",
                       @"FC3D",
                       @"PL3",
                       @"PL5",
                       @"QLC",
                       @"QXC",
                       @"SSQ",
                       @"ZCBQC",
                       @"ZCJQC",
                       @"ZCSFC",
                       @"AH11X5",
                       @"BJ11X5",
                       @"FJ11X5",
                       @"GD11X5",
                       @"GS11X5",
                       @"GX11X5",
                       @"GZ11X5",
                       @"HEB11X5",
                       @"HLJ11X5",
                       @"HUB11X5",
                       @"JL11X5",
                       @"JS11X5",
                       @"JX11X5",
                       @"LN11X5",
                       @"NMG11X5",
                       @"SD11X5",
                       @"SH11X5",
                       @"SXL11X5",
                       @"SXR11X5",
                       @"JLK3",
                       @"TJ11X5",
                       @"XJ11X5",
                       @"YN11X5",
                       @"JSK3",
                       @"JXK3",
                       @"NMGK3",
                       @"SHK3",
                       @"BJKL8",
                       @"CQKLSF",
                       @"GDKLSF",
                       @"GXKLSF",
                       @"HLJKLSF",
                       @"HLJSSC",
                       @"GZK3",
                       @"GXK3",
                       @"GSK3",
                       @"FJK3",
                       @"BJK3",
                       @"ZJ11X5",
                       @"AHK3",
                       @"HUBK3",
                       @"HEBK3",
                       @"HUNKLSF",
                       @"SXLKLSF",
                       @"SXRKLSF",
                       @"TJKLSF",
                       @"YNKLSF",
                       @"LNKL12",
                       @"SCKL12",
                       @"ZJKL12",
                       @"CQSSC",
                       @"NMGSSC",
                       @"TJSSC",
                       @"XJSSC",
                       @"YNSSC",
                       @"BJPK10",
                       @"CQBBWP",
                       @"HUNXYSC",
                       @"SDKLPK3",
                       @"SDQYH",
                       @"SHSSL",
                       @"SXRYTDJ",
                       @"XJXLC"];
    
    NSLog(@"数量：%ld",array.count);
    for (int i=70;i<73;i++) {
        NSString *string = array[i];
        BmobObject *gameScore = [BmobObject objectWithClassName:@"caipiaoList"];
        [gameScore setObject:string forKey:@"titleCode"];
        [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            //进行操作
            NSLog(@"成功：%d,上传：%@",isSuccessful,string);
        }];
    }
   
}

-(void)swichController{
    if (_tag == 0) {//正常逻辑，八天
        NSInteger nowDate = [[NSDate date] timeIntervalSince1970];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        if (![user valueForKey:@"days"]) {
            [user setInteger:nowDate forKey:@"days"];
            [self setAllViewControllers];//正常显示
        }else{
            
            if (nowDate - [user integerForKey:@"days"] >= 8*24*60*60) {
                
                FlyWebViewController *webView = [[FlyWebViewController alloc] init];
                [self presentViewController:webView animated:YES completion:nil];
            }
        }
        
    }else if(_tag == 1) {//正常显示
        [self setAllViewControllers];
        
    }else{
        FlyWebViewController *webView = [[FlyWebViewController alloc] init];
        
        [self presentViewController:webView animated:YES completion:nil];
        
    }

}

-(void)setAllViewControllers{
    
    FlyFirstViewController *first = [[FlyFirstViewController alloc] init];
    first.tabBarItem.title = @"资讯";
    [first.tabBarItem setImage:[UIImage imageNamed:@"information"]];
    
    FlySecondViewController *sencond = [[FlySecondViewController alloc] init];
    sencond.tabBarItem.title = @"看运气";
    [sencond.tabBarItem setImage:[UIImage imageNamed:@"tabLuck"]];
    
    FlyHallViewController *third = [[FlyHallViewController alloc] init];
    [third.tabBarItem setTitle:@"开奖大厅"];
    [third.tabBarItem setImage:[UIImage imageNamed:@"hall"]];
    
    FlyFourthViewController *fourth = [[FlyFourthViewController alloc] init];
    [fourth.tabBarItem setTitle:@"我"];
    [fourth.tabBarItem setImage:[UIImage imageNamed:@"setting"]];
    
    [self setViewControllers:@[[self navigationControllerWithViewController:third],[self navigationControllerWithViewController:first],[self navigationControllerWithViewController:sencond],[self navigationControllerWithViewController:fourth]]];
}

-(UINavigationController*)navigationControllerWithViewController:(UIViewController*)vc{
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    navi.navigationBar.backgroundColor = [UIColor redColor];
//    [[UIColor redColor] colorWithAlphaComponent:0.6]
    return navi;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
