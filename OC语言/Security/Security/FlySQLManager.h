//
//  FlySQLManager.h
//  Security
//
//  Created by walg on 2017/7/10.
//  Copyright © 2017年 walg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FlyDataModel;
@interface FlySQLManager : NSObject
+(instancetype)shareInstance;
-(void)creatBaseTable;
-(NSArray *)readAllData;
-(void)insertDateWithModel:(FlyDataModel*)model;
-(void)updateDateWithModel:(FlyDataModel*)model;
-(void)deleteDataWithUserName:(NSString*)userName securityCode:(NSString*)securityCode dataType:(NSString*)dataType;
@end
