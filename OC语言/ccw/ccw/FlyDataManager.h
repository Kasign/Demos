//
//  FlyDataManager.h
//  ccw
//
//  Created by walg on 2017/6/21.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlyDataManager : NSObject
@property (nonatomic, assign) NSInteger appType;
@property (nonatomic, strong) NSArray *zixunArray;
+(instancetype)sharedInstance;
-(void)getZixunArrayBlock:(void(^)(NSArray *dataArray))block;
-(void)getAppStateBlock:(void(^)(NSInteger state))block;
@end
