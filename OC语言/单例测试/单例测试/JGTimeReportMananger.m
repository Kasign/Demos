//
//  JGTimeReportMananger.m
//  JGEngine
//
//  Created by Walg on 2021/6/30.
//

#import "JGTimeReportMananger.h"

@interface JGTimeNode : NSObject

@property (nonatomic, copy) NSString *nodeKey;
@property (nonatomic, assign) CFTimeInterval time;
@property (nonatomic, assign) CFTimeInterval currentTime;

@end

@interface JGTimeEvent : NSObject

@property (nonatomic, copy) NSString *eventKey;
@property (nonatomic, assign) CFTimeInterval startTime;
@property (nonatomic, strong) NSMutableArray<JGTimeNode *> *timeNodeList;

- (NSString *)logCurrent;

@end


@implementation JGTimeEvent

- (instancetype)init {
    self = [super init];
    if (self) {
        _startTime = CACurrentMediaTime();
        _timeNodeList = [NSMutableArray array];
    }
    return self;
}

- (void)recordNodeTimeForKey:(NSString *)nodeKey {
    
    JGTimeNode *node = [[JGTimeNode alloc] init];
    node.nodeKey = nodeKey;
    node.time = node.currentTime - _startTime;
    [_timeNodeList addObject:node];
}

- (NSString *)logCurrent {
    
    NSMutableString *logStr = [NSMutableString string];
    [logStr appendFormat:@"\n当前事件名称：%@ %f", _eventKey, _startTime];
    for (JGTimeNode *node in _timeNodeList) {
        [logStr appendFormat:@"\n  %@ %f %f", node.nodeKey, node.currentTime, node.time];
    }
    [logStr appendFormat:@"\n以上关于事件 %@ 所有的记录\n", _eventKey];
    return [logStr copy];
}

@end


@implementation JGTimeNode

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentTime = CACurrentMediaTime();
    }
    return self;
}

@end


@interface JGTimeReportMananger ()

@property (nonatomic, strong) NSMutableDictionary *recordDic;

@end

@implementation JGTimeReportMananger

+ (instancetype)sharedInstance {
    
    static JGTimeReportMananger *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JGTimeReportMananger alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _recordDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)startRecordEvent:(NSString *)eventStr {
    
    if ([_recordDic.allKeys containsObject:eventStr]) {
        [_recordDic removeObjectForKey:eventStr];
    }
    if (eventStr) {
        JGTimeEvent *eventModel = [[JGTimeEvent alloc] init];
        eventModel.eventKey = eventStr;
        [eventModel recordNodeTimeForKey:@"start"];
        [_recordDic setObject:eventModel forKey:eventStr];
    }
}

- (void)recordEvent:(NSString *)eventStr nodeKey:(NSString *)nodeKey {
    
    JGTimeEvent *eventModel = [_recordDic objectForKey:eventStr];
    if (eventModel) {
        [eventModel recordNodeTimeForKey:nodeKey];
    }
}

- (void)clearAllRecord {
    
    [_recordDic removeAllObjects];
}

- (NSString *)logAllRecord {
    
    NSMutableString *logStr = [NSMutableString string];
    NSArray *allTimeList = [[_recordDic allValues] copy];
    [logStr appendFormat:@"当前记录总数：%ld", allTimeList.count];
    for (JGTimeEvent *event in allTimeList) {
        [logStr appendString:event.logCurrent];
    }
    return logStr;
}

@end
