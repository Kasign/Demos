//
//  FlyDateManager.m
//  Security
//
//  Created by walg on 2017/1/5.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "FlyDataManager.h"
#import "FlyDataModel.h"
#import "FlySQLManager.h"

@implementation FlyDataManager

+(instancetype)sharedInstance
{
    static FlyDataManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[FlyDataManager alloc] init];
    });
    return _sharedInstance;
}

-(void)updateDataWithModel:(FlyDataModel*)model
{
    [[FlySQLManager shareInstance] updateDateWithModel:model];
}

-(void)saveDataWithModel:(FlyDataModel*)model
{
    [[FlySQLManager shareInstance] insertDateWithModel:model];
}

-(void)deleDataWithModel:(FlyDataModel*)model
{
    [[FlySQLManager shareInstance] deleteDataWithItemID:model.itemId dataType:model.dataType];
}

-(NSArray*)readData
{
    NSArray *dataArray = [[FlySQLManager shareInstance] readAllData];
    return [dataArray mutableCopy];
}

@end
