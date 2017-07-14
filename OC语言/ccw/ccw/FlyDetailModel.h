//
//  FlyDetailModel.h
//  ccc
//
//  Created by walg on 2017/5/23.
//  Copyright © 2017年 walg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlyDetailModel : NSObject
@property (nonatomic, copy) NSString *expect;
@property (nonatomic, copy) NSString *opencode;
@property (nonatomic, copy) NSString *opentime;
@property (nonatomic, copy) NSString *opentimestamp;

-(instancetype)initWithDic:(NSDictionary*)dic;
-(instancetype)initWithBmobObject:(BmobObject*)object;
@end
