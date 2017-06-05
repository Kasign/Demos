//
//  FlyDateModel.h
//  Security
//
//  Created by walg on 2017/1/5.
//  Copyright © 2017年 walg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlyDataModel : NSObject

@property (nonatomic, copy) NSString *keyString;

@property (nonatomic, strong) NSMutableArray *valueArray;

@property (nonatomic, strong) NSMutableArray *keyArray;

- (instancetype)initWithArray:(NSArray*)array key:(NSString*)keyString;

@end
