//
//  FlyModelObject.m
//  三方库合集
//
//  Created by mx-QS on 2019/8/1.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "FlyModelObject.h"
#import <MJExtension.h>

@implementation FlyBaseModelObject
static NSCache * _classCache = nil;

- (id)copyWithZone:(NSZone *)zone {
    
    return [self mutableCopyWithZone:zone];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    
    return [self mutableCopyCurrentObject];
}

- (id)mutableCopyCurrentObject {
    
    id model = [[[self class] alloc] init];
    if (_classCache == nil) {
        _classCache = [[NSCache alloc] init];
    }
    NSArray * propertyArr = [_classCache objectForKey:NSStringFromClass([self class])];
    if ([propertyArr isKindOfClass:[NSArray class]]) {
        for (NSString * key in propertyArr) {
            [self setValueForKey:key model:model];
        }
    } else {
        Class superClass = [self class];
        while ([superClass isSubclassOfClass:[NSObject class]]) {
            [self setValuesWithClass:superClass model:model];
            superClass = [superClass superclass];
            if (superClass.superclass == nil) {
                break;
            }
        }
    }
    
    return model;
}

- (void)setValuesWithClass:(Class)class model:(id)model {
    
    unsigned int count = 0;
    objc_property_t * propertyList = class_copyPropertyList(class, &count);
    
    NSMutableArray * propertyArr = [[_classCache objectForKey:NSStringFromClass([model class])] mutableCopy];
    if (propertyArr == nil) {
        propertyArr = [NSMutableArray arrayWithCapacity:count];
    }
    for (int i = 0; i < count; i ++) {
        objc_property_t property = propertyList[i];
        const char * key  = property_getName(property);
        NSString   * name = [NSString stringWithCString:key encoding:NSUTF8StringEncoding];
        [self setValueForKey:name model:model];
        if ([name isKindOfClass:[NSString class]]) {
            [propertyArr addObject:name];
        }
    }
    [_classCache setObject:propertyArr forKey:NSStringFromClass([model class])];
    free(propertyList);
}

- (void)setValueForKey:(NSString *)key model:(id)model {
    
    if (model && [key isKindOfClass:[NSString class]]) {
        
        id value = [self valueForKey:key];
        if (key && [key conformsToProtocol:@protocol(NSMutableCopying)]) {
            key = [key mutableCopy];
        }
        if (value && [value conformsToProtocol:@protocol(NSMutableCopying)]) {
            value = [self mutableCopyWithObject:value];
        }
        if (key && value && model) {
            [model setValue:value forKey:key];
        }
    }
}

- (id)mutableCopyWithObject:(id)value {
    
    id resultValue = value;
    if ([value isKindOfClass:[NSArray class]]) {
        NSArray * arr = (NSArray *)value;
        NSMutableArray * mutableValue = [NSMutableArray arrayWithCapacity:arr.count];
        for (NSObject * subValue in arr) {
            id copyValue = subValue;
            if ([subValue conformsToProtocol:@protocol(NSMutableCopying)]) {
                copyValue = [self mutableCopyWithObject:subValue];
            }
            if (copyValue) {
                [mutableValue addObject:copyValue];
            }
        }
        resultValue = [mutableValue copy];
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dict = (NSDictionary *)value;
        NSMutableDictionary * mutableValue = [NSMutableDictionary dictionaryWithCapacity:dict.count];
        for (NSValue * key in dict.allKeys) {
            id copyValue = [dict objectForKey:key];
            id copyKey   = key;
            if ([copyKey conformsToProtocol:@protocol(NSMutableCopying)]) {
                copyKey = [self mutableCopyWithObject:copyKey];
            }
            if ([copyValue conformsToProtocol:@protocol(NSMutableCopying)]) {
                copyValue = [self mutableCopyWithObject:copyValue];
            }
            if (copyValue && copyKey) {
                [mutableValue setObject:copyValue forKey:copyKey];
            }
        }
        resultValue = [mutableValue copy];
    } else {
        if ([resultValue conformsToProtocol:@protocol(NSMutableCopying)]) {
            resultValue = [resultValue mutableCopy];
        } else {
            NSLog(@"%@", resultValue);
        }
    }
    return resultValue;
}

- (NSString *)description {
    
    NSString * des = [super description];
    NSDictionary * dict = [self mj_keyValues];
    return [NSString stringWithFormat:@"%@\n%@", des, dict];
}

@end

@implementation FlyModelObject

- (FlyModelObject2 *)detailModel {
    
    if (_detailModel == nil) {
        _detailModel = [[FlyModelObject2 alloc] init];
        __weak typeof(self) weakSelf = self;
        _detailModel.converBlock = ^(NSInteger index) {
            NSLog(@"%@", weakSelf.modelType);
        };
    }
    return _detailModel;
}

@end

@implementation FlyModelObject2

@end
