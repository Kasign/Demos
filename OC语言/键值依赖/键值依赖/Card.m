//
//  Card.m
//  手动添加KVO功能
//
//  Created by Walg on 2017/7/29.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import "Card.h"

@implementation Card

- (instancetype)init
{
    self = [super init];
    if (self) {
        _user1 = [[Person alloc] init];
        _user2 = [[Person alloc] init];
    }
    return self;
}

-(NSInteger)totalAge{
    return _user1.age+_user2.age;
}

+(NSSet<NSString *> *)keyPathsForValuesAffectingValueForKey:(NSString *)key{
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
    NSArray *moreKeyPaths = nil;
    if ([key isEqualToString:@"totalAge"])//需要观察的属性，也是被影响的属性
    {
        moreKeyPaths = [NSArray arrayWithObjects:@"user1.age", @"user2.age", nil];//两个关联的属性
    }
    
    if (moreKeyPaths)
    {
        keyPaths = [keyPaths setByAddingObjectsFromArray:moreKeyPaths];
    }
    
    
    
    return keyPaths;
}



@end
