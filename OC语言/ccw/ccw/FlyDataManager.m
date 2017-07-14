//
//  FlyDataManager.m
//  ccw
//
//  Created by walg on 2017/6/21.
//  Copyright © 2017年 Walg. All rights reserved.
//

#import "FlyDataManager.h"

@implementation FlyDataManager
+(instancetype)sharedInstance{
    static FlyDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FlyDataManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.appType = 1;
    }
    return self;
}

-(void)getZixunArrayBlock:(void(^)(NSArray *dataArray))block{
    NSMutableArray *_dataSource = [NSMutableArray array];
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"newsTable"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error&&array) {
            [_dataSource removeAllObjects];
            for (BmobObject * object in array) {
                NSString *string = [object objectForKey:@"title"];
                NSString *contenString = [object objectForKey:@"content"];
                NSNumber *type = [object objectForKey:@"pageType"];
                NSString *urlString = [object objectForKey:@"urlString"];
                DataModel *model = [[DataModel alloc]init];
                [model setTitle:string];
                [model setContent:contenString];
                [model setType:type];
                [model setUrlString:urlString];
                [_dataSource addObject:model];
            }
            self.zixunArray = [_dataSource copy];
            block(_dataSource.copy);
        }else{
            NSLog(@"%@",error);
        }
    }];
}

-(void)getAppStateBlock:(void(^)(NSInteger state))block{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        BmobQuery  *bquery = [BmobQuery queryWithClassName:@"ViewController"];
        
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (!error&&array) {
                BmobObject *object = array.firstObject;
                NSNumber *num = [object objectForKey:@"isShow"];
                _appType = num.integerValue;
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(_appType);
                });
            }
        }];
    });

}

@end
