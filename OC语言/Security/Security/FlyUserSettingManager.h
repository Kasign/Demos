//
//  FlyUserSettingManager.h
//  Security
//
//  Created by walg on 2017/5/25.
//  Copyright © 2017年 walg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlyUserSettingManager : NSObject

@property (nonatomic, assign) BOOL  useTouchID;

@property (nonatomic, assign) NSInteger  lockTime;

@property (nonatomic, strong) NSString *passWord;

@property (nonatomic, assign,readonly) BOOL  needShowSecuriView;

+(instancetype)sharedInstance;

-(void)updateStates;

@end
