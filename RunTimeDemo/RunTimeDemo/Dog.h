//
//  Dog.h
//  RunTimeDemo
//
//  Created by walg on 2017/3/22.
//  Copyright © 2017年 walg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dog : NSObject
@property (nonatomic, assign) int  age;
@property (nonatomic, strong) NSString *name;
-(void)eat;
-(void)run;
@end
