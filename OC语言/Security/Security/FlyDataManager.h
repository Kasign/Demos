//
//  FlyDateManager.h
//  Security
//
//  Created by walg on 2017/1/5.
//  Copyright © 2017年 walg. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FlyDataModel.h"

@interface FlyDataManager : NSObject

@property (nonatomic, strong) NSArray *daraArray;

+(instancetype)sharedInstance;

-(void)saveDataWithModel:(FlyDataModel*)model;

-(void)updateDataWithModel:(FlyDataModel*)model;

-(void)deleDataWithUserName:(NSString *)userName;

-(NSArray*)readData;

@end
