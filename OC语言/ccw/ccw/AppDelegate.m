//
//  AppDelegate.m
//  ccw
//
//  Created by Walg on 2017/5/7.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import "AppDelegate.h"
#import "FlyTabBarViewController.h"

#import "FlyFirstViewController.h"
#import "FlySecondViewController.h"
#import "FlyThirdViewController.h"
#import "FlyWebViewController.h"

// 引 JPush功能所需头 件
#import "JPUSHService.h"
// iOS10注册APNs所需头 件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
//// 如果需要使 idfa功能所需要引 的头 件(可选)
//#import <AdSupport/AdSupport.h>

@interface AppDelegate ()<JPUSHRegisterDelegate>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [JPUSHService setupWithOption:launchOptions appKey:@"b85f70d66801764b55dd8796"
                          channel:@"appstore"
                 apsForProduction:1];
    
    [self jpushSet];
    // Optional
    // 获取IDFA
    // 如需使 IDFA功能请添加此代码并在初始化 法的advertisingIdentifier参数中填写对应值
    //        NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册 法，改成可上报IDFA，如果没有使 IDFA直接传nil
    
    [Bmob registerWithAppKey:@"f0367860fca6424b9a6f2b1c1d565607"];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [self.window makeKeyAndVisible];
    
    FlyTabBarViewController *vc = [[FlyTabBarViewController alloc] init];
    self.window.rootViewController = vc;
    
    return YES;
}

-(void)jpushSet{
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续 之前的注册 式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加 定义categories
//         NSSet<UNNotificationCategory *> *categories for iOS10 or later
//         NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger)
                                                                                                                                                 )completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]
        ]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执 这个 法，选择 是否提醒 户，有Badge、Sound、Alert三种类型可以选择设置
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)
                                                                                                                                                            ())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(); // 系统要求执 这个 法
}
//- (void)application:(UIApplication*)applicationdidReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    // Required, iOS 7 Support
//    [JPUSHService handleRemoteNotification:userInfo];
//    completionHandler(UIBackgroundFetchResultNewData);
//}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
