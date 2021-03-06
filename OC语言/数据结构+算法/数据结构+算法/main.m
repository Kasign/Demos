//
//  main.m
//  数据结构+算法
//
//  Created by Walg on 2020/4/9.
//  Copyright © 2020 Fly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

#import "DictionOrderOutPut.h"

typedef int Element;

struct Node {
    Element data;
    struct Node * next;
};


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        outPutNums(9, 2);
        NSLog(@"Hello, World!");
    }
    return 0;
}
