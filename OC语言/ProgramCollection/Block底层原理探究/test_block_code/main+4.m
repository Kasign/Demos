//
//  main.m
//  ProgramCollection
//
//  Created by Qiushan on 2020/9/10.
//  Copyright © 2020 FLY. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        NSMutableArray * arr = [NSMutableArray array];
        void (^block)(void) = ^() {
            [arr addObject:@"abcd_2"];
        };
        block();
        NSLog(@"%@", arr);
    }
    return 0;
}
