//
//  FlyPerson.m
//  C指针
//
//  Created by Q on 2018/6/13.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "FlyPerson.h"

@implementation FlyPerson

- (instancetype)initWithName:(NSString *)name age:(NSInteger)age height:(float)height
{
    self = [super init];
    if (self) {
        self.uName  = name;
        self.age    = age;
        self.height = height;
    }
    return self;
}

- (NSString *)description
{
    NSString * des = [NSString stringWithFormat:@"p:[%@ %p] age:%ld name:%@ height:%f",[self class], self, _age, _uName, _height];
    return des;
}

@end
