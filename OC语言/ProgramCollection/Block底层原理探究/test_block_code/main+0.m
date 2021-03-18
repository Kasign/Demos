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
        
        NSString * fly_name = [NSString stringWithFormat:@"abcd"];
        void (^block1)(void) = ^{ // block_copy
            NSLog(@"FLY_Block - %@", fly_name);
        };
        block1();
        NSLog(@"FLY_Block - 2 - %@", fly_name);
    }
    return 0;
}
