//
//  main.m
//  ProgramCollection
//
//  Created by Qiushan on 2020/9/10.
//  Copyright © 2020 FLY. All rights reserved.
//

#import <UIKit/UIKit.h>

NSString * fly_name;
int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        fly_name = [NSString stringWithFormat:@"abcd"];
        void (^block)(void) = ^() {
            fly_name = @"fly_abcd";
            NSLog(@"FLY_Block - %@", fly_name);
        };
        block();
        NSLog(@"FLY_Block - 2 - %@", fly_name);
    }
    return 0;
}
