//
//  UIView+FLYTouch.m
//  testAvc
//
//  Created by Walg on 2023/8/30.
//  Copyright © 2023 FLY. All rights reserved.
//

#import "UIView+FLYTouch.h"
#import "RSSwizzle.h"

@implementation UIView (FLYTouch)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        RSSwizzleInstanceMethod(self,
                                @selector(touchesBegan:withEvent:),
                                RSSWReturnType(void),
                                RSSWArguments(NSSet<UITouch *> * touches, UIEvent *event),
                                RSSWReplacement(
        {
            [self logMsg:NSStringFromSelector(selector_)];
            // Calling original implementation.
            RSSWCallOriginal(touches, event);
        }), 0, NULL);
        
        RSSwizzleInstanceMethod(self,
                                @selector(touchesMoved:withEvent:),
                                RSSWReturnType(void),
                                RSSWArguments(NSSet<UITouch *> * touches, UIEvent *event),
                                RSSWReplacement(
        {
            [self logMsg:NSStringFromSelector(selector_)];
            // Calling original implementation.
            RSSWCallOriginal(touches, event);
        }), 0, NULL);
        
        RSSwizzleInstanceMethod(self,
                                @selector(touchesEnded:withEvent:),
                                RSSWReturnType(void),
                                RSSWArguments(NSSet<UITouch *> * touches, UIEvent *event),
                                RSSWReplacement(
        {
            [self logMsg:NSStringFromSelector(selector_)];
            // Calling original implementation.
            RSSWCallOriginal(touches, event);
        }), 0, NULL);
        
        RSSwizzleInstanceMethod(self,
                                @selector(touchesCancelled:withEvent:),
                                RSSWReturnType(void),
                                RSSWArguments(NSSet<UITouch *> * touches, UIEvent *event),
                                RSSWReplacement(
        {
            [self logMsg:NSStringFromSelector(selector_)];
            // Calling original implementation.
            RSSWCallOriginal(touches, event);
        }), 0, NULL);
    });
}

- (void)logMsg:(NSString *)msg {
    
    NSLog(@"\n------------------------->>> \n%@\n%@\n%@\n<<<------------------------", [self description], self.gestureRecognizers, msg);
}

@end

@interface UIControl (FLYTouch)

@end

@implementation UIControl (FLYTouch)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        RSSwizzleInstanceMethod(self,
                                @selector(touchesBegan:withEvent:),
                                RSSWReturnType(void),
                                RSSWArguments(NSSet<UITouch *> * touches, UIEvent *event),
                                RSSWReplacement(
        {
            [self logMsg:NSStringFromSelector(selector_)];
            // Calling original implementation.
            RSSWCallOriginal(touches, event);
        }), 0, NULL);
        
        RSSwizzleInstanceMethod(self,
                                @selector(touchesMoved:withEvent:),
                                RSSWReturnType(void),
                                RSSWArguments(NSSet<UITouch *> * touches, UIEvent *event),
                                RSSWReplacement(
        {
            [self logMsg:NSStringFromSelector(selector_)];
            // Calling original implementation.
            RSSWCallOriginal(touches, event);
        }), 0, NULL);
        
        RSSwizzleInstanceMethod(self,
                                @selector(touchesEnded:withEvent:),
                                RSSWReturnType(void),
                                RSSWArguments(NSSet<UITouch *> * touches, UIEvent *event),
                                RSSWReplacement(
        {
            [self logMsg:NSStringFromSelector(selector_)];
            // Calling original implementation.
            RSSWCallOriginal(touches, event);
        }), 0, NULL);
        
        RSSwizzleInstanceMethod(self,
                                @selector(touchesCancelled:withEvent:),
                                RSSWReturnType(void),
                                RSSWArguments(NSSet<UITouch *> * touches, UIEvent *event),
                                RSSWReplacement(
        {
            [self logMsg:NSStringFromSelector(selector_)];
            // Calling original implementation.
            RSSWCallOriginal(touches, event);
        }), 0, NULL);
    });
}

@end
