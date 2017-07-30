//
//  Card.h
//  手动添加KVO功能
//
//  Created by Walg on 2017/7/29.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
@interface Card : NSObject
@property (nonatomic,assign)NSInteger totalAge;
@property (nonatomic,strong)Person *user1;
@property (nonatomic,strong)Person *user2;
@end
