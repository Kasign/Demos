//
//  FlyAddNewViewController.h
//  Security
//
//  Created by walg on 2017/1/5.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "FlyBasicViewController.h"
#import "FlyDataModel.h"

typedef NS_ENUM(NSUInteger, FlyDisplayDetailType) {
    FlyAddNewType  = 1<<0,
    FlyEditOldType = 1<<1,
    FlyDisplayType = 1<<2
};

@interface FlyDisplayDetailViewController : FlyBasicViewController

@property (nonatomic, assign) FlyDisplayDetailType type;

@property (nonatomic, strong) FlyDataModel *model;

@end


