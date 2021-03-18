//
//  main.m
//  004-Block结构与签名
//
//  Created by Cooci on 2019/7/3.
//  Copyright © 2019 Cooci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
        //
//        __block NSString * fly_name = [NSString stringWithFormat:@"abcd"];
        __block NSObject * fly_object = [[NSObject alloc] init];
        void (^block1)(void) = ^{ // block_copy
            fly_object = [[NSObject alloc] init];
            NSLog(@"FLY_Block - %@", fly_object);
        };
        block1();
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
