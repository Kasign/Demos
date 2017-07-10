//
//  FlyDateModel.h
//  Security
//
//  Created by walg on 2017/1/5.
//  Copyright © 2017年 walg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlyDataModel : NSObject

@property (nonatomic, copy) NSString *dataType;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *security;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *detail1;
@property (nonatomic, copy) NSString *detail2;
@property (nonatomic, copy) NSString *detail3;
@property (nonatomic, copy) NSString *creatTime;
@property (nonatomic, copy) NSString *updateTime;

@property (nonatomic, strong) NSDictionary *valueDic;

@property (nonatomic, strong) NSDictionary *keyDic;

-(instancetype)initWithDataDic:(NSDictionary*)dataDic;

@end
