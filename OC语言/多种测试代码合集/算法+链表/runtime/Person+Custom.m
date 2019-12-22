//
//  Person+Custom.m
//  RunTimeDemo
//
//  Created by walg on 2017/3/22.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "Person+Custom.h"
#import <objc/runtime.h>
@implementation Person (Custom)

//- (void)run {
//    
//    FLYLog(@"人在跑");
//}

- (NSString *)nickname {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNickname:(NSString *)nickname {
    
    objc_setAssociatedObject(self, @selector(nickname), nickname, OBJC_ASSOCIATION_COPY);
}


//-(void)walk{
//    FLYLog(@"人在走");
//}
@end
