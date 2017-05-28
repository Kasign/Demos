//
//  FlyUserSettingManager.m
//  Security
//
//  Created by walg on 2017/5/25.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "FlyUserSettingManager.h"

#define FLY_USETOUCHID    @"ShowTouchID"
#define FLY_LOCKTIME    @"LockTime"
#define FLY_PASSWORD  @"PassWord"

@interface FlyUserSettingManager()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) dispatch_queue_t securityQueue;
@end

@implementation FlyUserSettingManager
+(instancetype)sharedInstance{
    static FlyUserSettingManager *manager  = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FlyUserSettingManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
        _securityQueue = dispatch_queue_create("security", DISPATCH_QUEUE_SERIAL);
        if (![_userDefaults objectForKey:FLY_USETOUCHID]) {
            [_userDefaults setBool:NO forKey:FLY_USETOUCHID];
            [_userDefaults synchronize];
        }
        if (![_userDefaults objectForKey:FLY_LOCKTIME]) {
            [_userDefaults setInteger:0 forKey:FLY_LOCKTIME];
            [_userDefaults synchronize];
        }
    }
    return self;
}

-(void)setPassWord:(NSString *)passWord{
    _passWord = passWord;
    dispatch_async(_securityQueue, ^{
        [_userDefaults setValue:passWord forKey:FLY_PASSWORD];
        [_userDefaults synchronize];
    });
}

-(void)setUseTouchID:(BOOL)useTouchID{
    _useTouchID = useTouchID;
    dispatch_async(_securityQueue, ^{
        [_userDefaults setBool:useTouchID forKey:FLY_USETOUCHID];
        [_userDefaults synchronize];
    });
}

-(void)setLockTime:(NSInteger)lockTime{
    _lockTime = lockTime;
    dispatch_async(_securityQueue, ^{
        [_userDefaults setBool:lockTime forKey:FLY_LOCKTIME];
        [_userDefaults synchronize];
    });
}


-(void)updateStates{
    __block typeof(self) weakSelf = self;
    dispatch_async(_securityQueue, ^{
        weakSelf.useTouchID =[weakSelf.userDefaults boolForKey:FLY_USETOUCHID];
        weakSelf.lockTime = [weakSelf.userDefaults integerForKey:FLY_LOCKTIME];
        weakSelf.passWord =  [weakSelf.userDefaults stringForKey:FLY_PASSWORD];
        [_userDefaults synchronize];
    });
};

-(BOOL)needShowSecuriView{
    if (_useTouchID||_passWord)
    {
        return YES;
    }
    else{
        return NO;
    }
}

@end
