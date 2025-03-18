//
//  AppDelegate.m
//  MarkDown+Demo
//
//  Created by Walg on 2024/4/8.
//

#import "AppDelegate.h"
#import "DemoSnippetsViewController.h"
#import "DTCoreText.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // register a custom class for a tag
    [DTTextAttachment registerClass:[DTObjectTextAttachment class] forTagName:@"oliver"];
    
    // preload font matching table
    [DTCoreTextFontDescriptor asyncPreloadFontLookupTable];
    
    // for debugging, we make sure that UIView methods are only called on main thread
//    [UIView toggleViewMainThreadChecking];
    
    // Create window
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor redColor];
    
    // Create the view controller
    DemoSnippetsViewController *snippetsViewController = [[DemoSnippetsViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:snippetsViewController];
    
    // Display the window
    _window.rootViewController = navigationController;
    [_window makeKeyAndVisible];
    
    return YES;
}

@end
