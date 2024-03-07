//
//  Dog.h
//  RunTimeDemo
//
//  Created by walg on 2017/3/22.
//  Copyright © 2017年 walg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@interface Dog : Person
@property (nonatomic, assign) int  age_d;
@property (nonatomic, strong) NSString *name_d;
- (void)eat;
- (void)run;
@end
