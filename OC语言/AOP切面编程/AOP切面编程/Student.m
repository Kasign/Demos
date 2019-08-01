//
//  Student.m
//  AOP切面编程
//
//  Created by mx-QS on 2019/7/15.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "Student.h"

@implementation Student

-(void)study:(NSString *)subject :(NSString *)bookName
{
    NSLog(@"Invorking method on %@ object with selector %@",[self class],NSStringFromSelector(_cmd));
}

-(void)study:(NSString *)subject andRead:(NSString *)bookName
{
    NSLog(@"Invorking method on %@ object with selector %@",[self class],NSStringFromSelector(_cmd));
}

@end
