//
//  FlyJokeModel.h
//  ccw
//
//  Created by Walg on 2017/6/25.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlyJokeModel : NSObject
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *poster;
@property (nonatomic,copy)NSString *sourceurl;
-(instancetype)initWithBmobObject:(BmobObject*)object;
@end
