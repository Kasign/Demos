//
//  FlyNSObject.m
//  单例测试
//
//  Created by Q on 2018/4/20.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "FlyNSObject.h"

@implementation FlyNSObject

- (void)testMethod
{
    int b = 10;
    NSString * myString = @"abcd";
    __block NSString * myBlockString = @"cdefg";
    __block typeof(self) blockSelf = self;
    __unsafe_unretained  typeof(self) weakSelf = self;
    void(^myBlock)(NSString * a, BOOL success) = ^(NSString * a, BOOL success){
        NSLog(@"%@",a);
        NSLog(@"%d",success);
        NSLog(@"%d",b);
        NSLog(@"%@",myString);
        NSLog(@"%@",myBlockString);
        NSLog(@"%@",blockSelf);
        NSLog(@"%@",weakSelf);
    };
    myBlock(@"person",YES);
}

@end
