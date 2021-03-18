//
//  main.m
//  LGTest
//
//  Created by Cooci on 2020/1/4.
//

#import <Foundation/Foundation.h>
#import "FLYPerson.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        FLYPerson * p1 = [[FLYPerson alloc] init];
        
        FLYPerson * p2 = [[FLYPerson alloc] init];
        p2.delegate = p1;
        
        id __weak weakP = p2;
        void(^block)(void) = ^{
            NSLog(@"%@", weakP);
        };
        
        p2.block = ^(NSString * _Nonnull key) {
            NSLog(@"%@", weakP);
        };
        
        block();
        NSLog(@"99999");
    }
    return 0;
}
