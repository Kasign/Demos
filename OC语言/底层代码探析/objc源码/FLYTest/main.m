//
//  main.m
//  FLYTest
//
//  Created by Walg on 2019/12/22.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "FLYPerson.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        FLYPerson * person = [FLYPerson alloc];
        Class pClass       = object_getClass(person);
        NSLog(@"%@ - %p", person, pClass);
    }
    return 0;
}
