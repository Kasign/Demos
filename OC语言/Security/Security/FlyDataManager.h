//
//  FlyDateManager.h
//  Security
//
//  Created by walg on 2017/1/5.
//  Copyright © 2017年 walg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FlyDataModel;

@interface FlyDataManager : NSObject

@property (nonatomic, strong) NSArray *daraArray;

+(instancetype)sharedInstance;

-(void)saveDataWithModel:(FlyDataModel*)model;

-(void)updateDataWithModel:(FlyDataModel*)model;

-(void)deleDataWithModel:(FlyDataModel*)model;

-(NSArray*)readData;

@end
