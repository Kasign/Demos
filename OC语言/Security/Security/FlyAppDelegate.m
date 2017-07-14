//
//  FlyAppDelegate.m
//  Security
//
//  Created by walg on 2017/1/4.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "FlyAppDelegate.h"

#import "FlyTabBarViewController.h"
#import "FlySQLManager.h"

@interface FlyAppDelegate ()
@property (nonatomic, strong) FlyTabBarViewController *rootView;
@end

@implementation FlyAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[FlyUserSettingManager sharedInstance] updateStates];
    [[FlySQLManager shareInstance] creatBaseTable];
    
    FlyTabBarViewController *tabVC = [[FlyTabBarViewController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setRootViewController:tabVC];
    _rootView = tabVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

//进入后台1，加载
- (void)applicationWillResignActive:(UIApplication *)application {
    [[FlyUserSettingManager sharedInstance] updateStates];
}

//进入后台2，加载
- (void)applicationDidEnterBackground:(UIApplication *)application {

}

//进入前台1，加载
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self.rootView needShowView];
}

//进入前台2，加载
- (void)applicationDidBecomeActive:(UIApplication *)application {

}


- (void)applicationWillTerminate:(UIApplication *)application {
   
}

@end
