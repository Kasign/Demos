//
//  PatchLoader.m
//  WeChatRed
//
//  Created by qiuShan on 2018/1/2.
//  Copyright © 2018年 Fly. All rights reserved.
//

#import "PatchLoader.h"

@implementation PatchLoader

static void __attribute__((constructor)) initialize(void) {
    NSLog(@"code 注入成功");
}

@end
