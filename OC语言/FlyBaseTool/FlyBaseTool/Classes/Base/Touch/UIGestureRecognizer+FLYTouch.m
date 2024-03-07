//
//  UIGestureRecognizer+FLYTouch.m
//  testAvc
//
//  Created by Walg on 2023/8/30.
//  Copyright © 2023 FLY. All rights reserved.
//

#import "UIGestureRecognizer+FLYTouch.h"
#import <RSSwizzle/RSSwizzle.h>

@implementation UITapGestureRecognizer (FLYTouch)

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
            // Calling original implementation.
            [self logMsg:NSStringFromSelector(selector_)];
            RSSWCallOriginal(touches, event);
        }), 0, NULL);
        
        RSSwizzleInstanceMethod(self,
                                @selector(touchesEnded:withEvent:),
                                RSSWReturnType(void),
                                RSSWArguments(NSSet<UITouch *> * touches, UIEvent *event),
                                RSSWReplacement(
        {
            // Calling original implementation.
            [self logMsg:NSStringFromSelector(selector_)];
            RSSWCallOriginal(touches, event);
        }), 0, NULL);
        
        RSSwizzleInstanceMethod(self,
                                @selector(touchesCancelled:withEvent:),
                                RSSWReturnType(void),
                                RSSWArguments(NSSet<UITouch *> * touches, UIEvent *event),
                                RSSWReplacement(
        {
            // Calling original implementation.
            [self logMsg:NSStringFromSelector(selector_)];
            RSSWCallOriginal(touches, event);
        }), 0, NULL);
    });
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    
//    [self logMsg:NSStringFromSelector(_cmd)];
//    [super touchesBegan:touches withEvent:event];
//}
//
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//    [self logMsg:NSStringFromSelector(_cmd)];
//    [super touchesMoved:touches withEvent:event];
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//    [self logMsg:NSStringFromSelector(_cmd)];
//    [super touchesEnded:touches withEvent:event];
//}
//
//- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//    [self logMsg:NSStringFromSelector(_cmd)];
//    [super touchesCancelled:touches withEvent:event];
//}

- (void)logMsg:(NSString *)msg {
    
    FLYLog(@"\n------------------------->>> \n%@\n\n%@\n<<<------------------------", [self description], msg);
}

@end
