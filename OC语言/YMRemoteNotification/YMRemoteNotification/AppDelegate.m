//
//  AppDelegate.m
//  YMRemoteNotification
//
//  Created by walg on 2017/5/17.
//  Copyright © 2017年 walg. All rights reserved.
//


#import "AppDelegate.h"
#import "UMessage.h"

#define KUMAppKey @""

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)registerPushNotificationWithOptionApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions
{
    [UMessage startWithAppkey:KUMAppKey launchOptions:launchOptions];
    [UMessage registerForRemoteNotifications];
    
    //iOS10必须加下面这段代码。
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
    {
        //iOS 10 later
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //必须写代理，不然无法监听通知的接收与点击事件
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error && granted) {
            }else{
            }
        }];
    }
    else //ios8=< - <ios10
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    
    if (application.applicationState == UIApplicationStateActive) {
        
        NSDictionary *dic = [userInfo valueForKey:@"aps"];
        NSString *message;
        if (dic && [dic isKindOfClass:[NSDictionary class]]) {
            //新版本适配了iOS10，所以消息体的结构有所变化。在旧版中，alter的参数是一个String型的，而在新版中是一个Dictionary型的。
            if ([[dic valueForKey:@"alert"] isKindOfClass:[NSString class]]) {
                message = [dic valueForKey:@"alert"];
            }
            else if ([[dic valueForKey:@"alert"] isKindOfClass:[NSDictionary class]])
            {
                message = [[dic valueForKey:@"alert"] valueForKey:@"body"];
            }
        }
        
        if (!message)
        {
            message = @"收到一条新消息";
        }
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"消息提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        [self.window.rootViewController presentViewController:alertController
                                                     animated:YES
                                                   completion:nil];
    }
    else
    {
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
