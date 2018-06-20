//
//  FlyPerson.h
//  C指针
//
//  Created by Q on 2018/6/13.
//  Copyright © 2018 Fly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlyPerson : NSObject
@property (nonatomic, assign) NSInteger      age;
@property (nonatomic, copy)   NSString   *   uName;
@property (nonatomic, assign) float          height;

- (instancetype)initWithName:(NSString *)name age:(NSInteger)age height:(float)height;

@end
