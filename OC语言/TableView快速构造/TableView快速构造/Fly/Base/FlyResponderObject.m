//
//  FlyResponderObject.m
//  TableView快速构造
//
//  Created by Walg on 2021/6/22.
//

#import "FlyResponderObject.h"

@implementation FlyResponderObject

- (BOOL)respondsToSelector:(SEL)aSelector {
    
    BOOL isResponds = [super respondsToSelector:aSelector];
    if (!isResponds && self.extentDelegate) {
        isResponds = [self.extentDelegate respondsToSelector:aSelector];
    }
    NSLog(@"是否响应方法：\n%p\n%@\n%@\n%d", self, NSStringFromSelector(aSelector), self.extentDelegate, isResponds);
    return isResponds;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    
    if (self.extentDelegate && [self.extentDelegate respondsToSelector:aSelector]) {
        return self.extentDelegate;
    }
    return [super forwardingTargetForSelector:aSelector];
}

@end
