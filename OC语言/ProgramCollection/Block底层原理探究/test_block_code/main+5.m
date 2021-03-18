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
        
        static NSString * fly_name;
        fly_name = [NSString stringWithFormat:@"abcd"];
        
        __block NSString * fly_nick = fly_name;
        
        void (^block1)(void) = ^{ // block_copy
            fly_nick = @"fly_abcd";
            NSLog(@"FLY_Block - %@", fly_nick);
        };
        block1();
        NSLog(@"FLY_Block - 2 - %@", fly_nick);
    }
    return 0;
}
