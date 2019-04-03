//
//  InjectCode.m
//  FlyHook
//
//  Created by mx-QS on 2019/3/19.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "InjectCode.h"

@implementation InjectCode

static void __attribute__ ((constructor))initialize(void) {
    
    NSLog(@"==== Code Injection in Action initialize ====");
}

static void __attribute__ ((constructor))load(void) {
    
    NSLog(@"==== Code Injection in Action load ====");
}

+ (void)load
{
    NSLog(@"来了老弟load");
}

@end
