//
//  FlyHttpManager.h
//  ccc
//
//  Created by walg on 2017/5/23.
//  Copyright © 2017年 walg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface FlyHttpManager : NSObject
@property (nonatomic, strong) AFHTTPSessionManager *manager;
+(instancetype)sharedInstance;
@end
