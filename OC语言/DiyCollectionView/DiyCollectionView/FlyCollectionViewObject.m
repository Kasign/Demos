//
//  FlyCollectionViewObject.m
//  DiyCollectionView
//
//  Created by Fly. on 2018/11/29.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "FlyCollectionViewObject.h"

@implementation FlyCollectionViewObject

+ (instancetype)initWithClass:(Class)className identifier:(NSString *)identifier type:(NSInteger)type
{
    FlyCollectionViewObject * object = [FlyCollectionViewObject new];
    object.className = NSStringFromClass(className);
    object.identifier = identifier;
    object.type = type;
    
    return object;
}

@end
