//
//  FlySQLManager.m
//  Security
//
//  Created by walg on 2017/7/10.
//  Copyright © 2017年 walg. All rights reserved.
//

#import "FlySQLManager.h"
#import <FMDB/FMDB.h>
#import "FlyDataModel.h"

@interface FlySQLManager ()

@property (nonatomic, strong) FMDatabaseQueue *currentUserDBQueue;

@end

static NSString *SECURITY_TABLE_CREAT = @"\
CREATE TABLE IF NOT EXISTS security(\
id  INTEGER PRIMARY KEY AUTOINCREMENT,\
datatype VARCHAR NOT NULL DEFAULT ('0'),\
username VARCHAR NOT NULL DEFAULT ('0'),\
security VARCHAR NOT NULL DEFAULT ('0'),\
note VARCHAR DEFAULT NULL,\
detail1 VARCHAR DEFAULT NULL,\
detail2 VARCHAR DEFAULT NULL,\
detail3 VARCHAR DEFAULT NULL,\
creattime VARCHAR NOT NULL DEFAULT('0'),\
updatetime VARCHAR NOT NULL DEFAULT('0')\
)";

static NSString *SECURITY_TABLE_INSERT = @"INSERT OR REPLACE INTO security(datatype,username,security,note,detail1,detail2,detail3,creattime,updatetime) VALUES(?,?,?,?,?,?,?,?,?)";

static NSString *SECURITY_TABLE_UPDATE =@"UPDATE security SET ";

static NSString *SECURITY_TABLE_DELETE =@"DELETE FROM security WHERE id=? and datatype=?";

static NSString *SECURITY_TALBE_SELE = @"SELECT * FROM security";

@implementation FlySQLManager

static inline NSString *path() {
    return [[NSFileManager docmentDirectory] stringByAppendingString:@"/base.db"];
}

+ (instancetype)shareInstance{
    static FlySQLManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FlySQLManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentUserDBQueue = [FMDatabaseQueue databaseQueueWithPath:path()];
    }
    return self;
}


- (void)creatBaseTable
{
    NSLog(@"数据库地址：%@",path());
    [self.currentUserDBQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:SECURITY_TABLE_CREAT];
    }];
}

- (NSArray *)readAllData
{
    __block NSMutableArray *mutableArray = [NSMutableArray array];
    [self.currentUserDBQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *s = [db executeQuery:SECURITY_TALBE_SELE];
        while ([s next]) {
            FlyDataModel *model = [[FlyDataModel alloc] init];
            model.itemId   = [s stringForColumn:@"id"];
            model.dataType = [s stringForColumn:@"datatype"];
            model.userName = [s stringForColumn:@"username"];
            model.security = [s stringForColumn:@"security"];
            model.note     = [s stringForColumn:@"note"];
            model.detail1  = [s stringForColumn:@"detail1"];
            model.detail2  = [s stringForColumn:@"detail2"];
            model.detail3  = [s stringForColumn:@"detail3"];
            model.creatTime = [s stringForColumn:@"creattime"];
            model.updateTime = [s stringForColumn:@"updatetime"];
            [mutableArray addObject:model];
        }
    }];
    return mutableArray;
}

- (void)insertDateWithModel:(FlyDataModel*)model
{
    NSString *nowTime = [self nowDateString];
    
    [self.currentUserDBQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:SECURITY_TABLE_INSERT,model.dataType,model.userName,model.security,model.note,model.detail1,model.detail2,model.detail3,nowTime,nowTime];
    }];
}

- (void)updateDateWithModel:(FlyDataModel*)model
{
    NSString *updat_sql = SECURITY_TABLE_UPDATE;
    NSDictionary *dic = [model toValueDictionary];
    for (NSString *key in dic.allKeys) {
        if (![key isEqualToString:@"updatetime"]) {
            updat_sql = [updat_sql stringByAppendingFormat:@"%@=\'%@\',",[key lowercaseString],[dic objectForKey:key]];
        }
    }
    NSString *sele_sql = [NSString stringWithFormat:@"updatetime=\'%@\' WHERE id=\'%@\' and datatype=\'%@\'",[self nowDateString],model.itemId,model.dataType];
    updat_sql = [updat_sql stringByAppendingString:sele_sql];
    
    [self.currentUserDBQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:updat_sql];
    }];
}

- (void)deleteDataWithItemID:(NSString *)itemId dataType:(NSString*)dataType;
{
    [self.currentUserDBQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:SECURITY_TABLE_DELETE,itemId,dataType];
    }];
}

+ (NSString *)stringFromDateFormat
{
    return @"yyyy-MM-dd hh:mm:ss";
}

- (NSString*)nowDateString
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:[FlySQLManager stringFromDateFormat]];
    return [dateFormat stringFromDate:[NSDate date]];
}

@end
