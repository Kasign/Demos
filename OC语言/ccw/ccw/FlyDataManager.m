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
-(void)getZixunArrayBlock:(void(^)(NSArray *dataArray))block{
    NSMutableArray *_dataSource = [NSMutableArray array];
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"DataSource"];
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
@end
