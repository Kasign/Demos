//
//  Person.h
//  RunTimeDemo
//
//  Created by walg on 2017/3/22.
//  Copyright © 2017年 walg. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Person : NSObject {
    int hight;
}
@property (nonatomic, assign) int            age;
@property (nonatomic, strong) NSString   *   name;
@property (nonatomic, copy)   NSString   *   NICK;

-(void)eat;
-(void)run;
-(void)walk;

@end
