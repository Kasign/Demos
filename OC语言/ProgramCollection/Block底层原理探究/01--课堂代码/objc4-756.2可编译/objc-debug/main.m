//
//  main.m
//  objc-debug
//
//  Created by Cooci on 2019/10/9.
//

#import <Foundation/Foundation.h>
#import "LGPerson.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        // 拓展 - 不属于KVC
        // 为什么是这样的? 而不是 setName
        // 通用 - objc_setProperty_nonatomic_copy 入口
        // objc_setProperty_nonatomic_copy 为什么跑进来了?
        LGPerson *person = [[LGPerson alloc] init];
        person.name      = @"IKC";
        NSLog(@"Hello, World! %@",person);
    }
    return 0;
}
