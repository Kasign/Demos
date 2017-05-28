//
//  FlyDateManager.m
//  Security
//
//  Created by walg on 2017/1/5.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "FlyDataManager.h"

@implementation FlyDataManager

+(instancetype)sharedInstance{
    static FlyDataManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[FlyDataManager alloc] init];
    });
    return _sharedInstance;
}

static inline NSString *path() {
//    return [[NSFileManager docmentDirectory] stringByAppendingString:@"security.zip"];
    return [[NSBundle mainBundle] pathForResource:@"PropertyList" ofType:@"plist"];
}

-(void)updateDataWithModel:(FlyDataModel*)model{
    
    
}

-(void)saveDataWithModel:(FlyDataModel*)model{
    
}

-(void)deleDataWithUserName:(NSString *)userName{
    
    
}

-(NSArray*)readData{
    NSMutableArray *mutableArray = [NSMutableArray array];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path()];
    NSDictionary *securityDic = [dictionary objectForKey:@"SecurityList"];
    for (NSString *key in securityDic.allKeys) {
        NSArray *keyArray = [securityDic objectForKey:key];
        FlyDataModel *model = [[FlyDataModel alloc] initWithArray:keyArray key:key];
        [mutableArray addObject:model];
    }
    return [mutableArray copy];
}

@end
