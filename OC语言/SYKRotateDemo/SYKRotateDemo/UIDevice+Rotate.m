//
//  UIDevice+Rotate.m
//  SYKRotateDemo
//
//  Created by Walg on 2021/8/11.
//

#import "UIDevice+Rotate.h"

@implementation UIDevice (Rotate)

+ (UIInterfaceOrientation)interfaceOrientation {
    
    return [UIDevice currentDevice].orientation;
}

+ (void)changeRotateSwitch:(BOOL)open {
    
    [[NSUserDefaults standardUserDefaults] setBool:open forKey:@"k_jg_canRotate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)supportRotate {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"k_jg_canRotate"];
}

+ (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskAll;
}

+ (void)rotateScreeen:(UIInterfaceOrientation)orientation {
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        NSUInteger val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}


@end
