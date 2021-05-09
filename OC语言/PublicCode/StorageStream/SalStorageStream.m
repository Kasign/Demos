//
//  SalStorageStream.m
//  Unity-iPhone
//
//  Created by Qiushan on 2020/11/17.
//

#import "SalStorageStream.h"

typedef NS_ENUM(NSUInteger, SalStreamDataType) {
    SalStreamDataType_NONE  = 0,
    SalStreamDataType_DIRCT = 1,
    SalStreamDataType_ASYN  = 2,
};

@interface SalInputStream ()<NSStreamDelegate>

@property (nonatomic, strong) NSRunLoop      *  streamRunLoop;
@property (nonatomic, strong) NSMutableData  *  targetData;
@property (nonatomic, copy)   SalStreamBlock    completeBlock;

@property (nonatomic, strong) NSInputStream  *  inputStream;
@property (nonatomic, assign) SalStreamDataType dataType;
@property (nonatomic, assign) NSInteger         needLength;
@property (nonatomic, assign) NSInteger         lastLength;//剩余需要读取的长度

@end

@implementation SalInputStream

+ (instancetype)streamWithPath:(NSString *)path {
    
    return [[SalInputStream alloc] initWithPath:path];
}

- (instancetype)initWithPath:(NSString *)path {
    
    self = [self init];
    if (self) {
        _path = path;
        if ([_path isKindOfClass:[NSString class]] && _path.length > 0) {
            if (_inputStream == nil) {
                _inputStream = [NSInputStream inputStreamWithFileAtPath:_path];
                [_inputStream open];
            }
        }
    }
    return self;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _needLength = 0;
        _lastLength = 0;
        _bytesEach  = 50 * 1024;//一次读取50K
        _dataType   = SalStreamDataType_NONE;
    }
    return self;
}

- (void)setPropertyForOffset:(NSInteger)offset {
    
    if (_inputStream && offset >= 0) {
        [_inputStream setProperty:@(offset) forKey:NSStreamFileCurrentOffsetKey];
    }
}

- (NSData *)readDataWithLength:(NSInteger)length {
    
    return [self readDataWithLength:length startOffset:0];
}

- (void)asyReadDataWithLength:(NSInteger)length completion:(SalStreamBlock)completion {
    
    [self asyReadDataWithLength:length startOffset:0 completion:completion];
}

- (NSData *)readDataWithLength:(NSInteger)length startOffset:(NSInteger)startOffset {
    
    NSData * targetData = nil;
    if (_inputStream && length > 0) {
        _dataType   = SalStreamDataType_DIRCT;
        _needLength = length;
        _lastLength = length;
        [_inputStream setProperty:@(startOffset) forKey:NSStreamFileCurrentOffsetKey];
        targetData = [self startReadDataWithStream:_inputStream];
    }
    return targetData;
}

- (void)asyReadDataWithLength:(NSInteger)length startOffset:(NSInteger)startOffset completion:(SalStreamBlock)completion {
    
    [self asyReadDataWithLength:length startOffset:startOffset runLoop:nil completion:completion];
}

- (void)asyReadDataWithLength:(NSInteger)length startOffset:(NSInteger)startOffset runLoop:(NSRunLoop *)runLoop completion:(SalStreamBlock)completion {
    
    if (_inputStream && length > 0 && completion) {
        _targetData = [NSMutableData data];
        _needLength = length;
        _lastLength = length;
        [_inputStream setProperty:@(startOffset) forKey:NSStreamFileCurrentOffsetKey];
        _dataType = SalStreamDataType_ASYN;
        NSLog(@"开始异步任务 %@", self);
        [_inputStream setDelegate:self];
        if ([runLoop isKindOfClass:[NSRunLoop class]]) {
            _streamRunLoop = runLoop;
        } else {
            _streamRunLoop = [NSRunLoop currentRunLoop];
        }
        [_inputStream scheduleInRunLoop:_streamRunLoop forMode:NSRunLoopCommonModes];
        if (_inputStream.streamStatus == NSStreamStatusAtEnd || _inputStream.streamStatus == NSStreamStatusClosed) {
            completion(_targetData, _needLength - _lastLength, _inputStream.streamError);
        } else if (_inputStream.streamStatus == NSStreamStatusError) {
            completion(nil, _needLength - _lastLength, _inputStream.streamError);
        } else {
            _completeBlock = completion;
        }
    }
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    
    if (aStream == _inputStream) {
//        NSLog(@"--当前线程--->>>> %@", [NSThread currentThread]);
        switch (eventCode) {
            case NSStreamEventNone: {
//                NSLog(@"NSStreamEventNone");
                break;
            }
            case NSStreamEventOpenCompleted: {
//                NSLog(@"NSStreamEventOpenCompleted");
                break;
            }
            case NSStreamEventHasBytesAvailable: {
//                NSLog(@"NSStreamEventHasBytesAvailable");
                if (_dataType == SalStreamDataType_ASYN) {
                    [self startReadDataWhenBytesAvailable];
                }
                break;
            }
            case NSStreamEventHasSpaceAvailable: {
//                NSLog(@"NSStreamEventHasSpaceAvailable");
                break;
            }
            case NSStreamEventErrorOccurred: {
//                NSLog(@"NSStreamEventErrorOccurred");
                [self didFinishReadData];
                break;
            }
            case NSStreamEventEndEncountered: {
//                NSLog(@"NSStreamEventEndEncountered");
                [self didFinishReadData];
                break;
            }
        }
    }
}

#pragma mark - 开始读取数据
- (NSData *)startReadDataWithStream:(NSInputStream *)inputStream {
    
    NSInteger readBytes = _bytesEach;
    NSMutableData * mutableData = [NSMutableData data];
    while (_lastLength > 0) {
        readBytes = MIN(_lastLength, _bytesEach);
        NSInteger didReadLength = [self cycleReadDataWithStream:inputStream readLength:readBytes appendData:mutableData];
        _lastLength = _lastLength - didReadLength;
    }
    return mutableData;
}

- (NSInteger)cycleReadDataWithStream:(NSInputStream *)inputStream readLength:(NSInteger)readLength appendData:(NSMutableData *)appendData {
    
    NSInteger resultLength = 0;
    while (1) {
        if ([inputStream hasBytesAvailable]) {
            resultLength = [self readWithStream:inputStream readLength:readLength appendData:appendData];
            if (resultLength > 0) {
                break;
            }
        }
    }
    return resultLength;
}

#pragma mark - 异步读取数据
//这里全部数据读取完之后还要读取一次，为了出发delegate的结束event
- (void)startReadDataWhenBytesAvailable {
    
    if (_lastLength >= 0) {
        NSInteger readBytes = _bytesEach;
        NSInteger didReadLength = [self readWithStream:_inputStream readLength:readBytes appendData:_targetData];
        _lastLength = _lastLength - didReadLength;
        if (_lastLength <= 0) {
            [self didFinishReadData];
        }
    } else {
        NSLog(@"已经无数据可读取 %@", _path);
    }
}

- (void)didFinishReadData {
    
    if (_completeBlock) {
        _completeBlock([_targetData copy], _needLength - _lastLength, _inputStream.streamError);
    }
    _completeBlock = nil;
    _targetData  = nil;
}

#pragma mark - read
- (NSInteger)readWithStream:(NSInputStream *)inputStream readLength:(NSInteger)readLength appendData:(NSMutableData *)appendData {
    
    NSInteger resultLength = 0;
    if (readLength > 0 && inputStream) {
        uint8_t buffer[readLength];
        resultLength = [inputStream read:buffer maxLength:readLength];
        if ([appendData isKindOfClass:[NSMutableData class]] && resultLength > 0) {
            [appendData appendBytes:(const void *)buffer length:resultLength];
        }
    }
    return resultLength;
}

#pragma mark - dealloc
- (void)dealloc {
    
    if (_inputStream) {
        if (_inputStream.streamStatus != NSStreamStatusClosed) {
            [_inputStream close];
        }
        [_inputStream setDelegate:nil];
        if (_streamRunLoop) {
            [_inputStream removeFromRunLoop:_streamRunLoop forMode:NSRunLoopCommonModes];
            _streamRunLoop = nil;
        }
        _inputStream = nil;
    }
    _targetData  = nil;
    _completeBlock = nil;
    
//    NSLog(@"<<%@ dealloc>>", self);
}

@end

@interface SalOutputStream ()<NSStreamDelegate>

@property (nonatomic, strong) NSRunLoop      *  streamRunLoop;
@property (nonatomic, assign) SalStreamDataType dataType;
@property (nonatomic, copy)   SalStreamBlock    completeBlock;
@property (nonatomic, assign) NSInteger         needLength;
@property (nonatomic, assign) NSInteger         lastLength;   //剩余需要写入的长度
@property (nonatomic, strong) NSOutputStream *  outputStream;
@property (nonatomic, strong) NSData         *  oriData;

@end

@implementation SalOutputStream

+ (instancetype)streamWithPath:(NSString *)path append:(BOOL)append {
    
    return [[SalOutputStream alloc] initWithPath:path append:append];
}

- (instancetype)initWithPath:(NSString *)path append:(BOOL)append {
    
    self = [self init];
    if (self) {
        _path = path;
        if ([path isKindOfClass:[NSString class]] && path.length > 0) {
            if (_outputStream == nil) {
                _outputStream = [NSOutputStream outputStreamToFileAtPath:path append:append];
                [_outputStream open];
            }
        }
    }
    return self;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _needLength = 0;
        _lastLength = 0;
        _bytesEach  = 100 * 1024;//一次读取50K
        _dataType   = SalStreamDataType_NONE;
    }
    return self;
}

- (NSInteger)writeData:(NSData *)data {
    
    NSInteger length = 0;
    if (_outputStream && [data isKindOfClass:[NSData class]]) {
        _dataType   = SalStreamDataType_DIRCT;
        _needLength = data.length;
        _lastLength = data.length;
        _oriData    = data;
        length      = [self startWriteDataWithStream:_outputStream];
    }
    return length;
}

- (void)asyWriteData:(NSData *)data block:(SalStreamBlock)completion {
    
    [self asyWriteData:data runLoop:nil completion:completion];
}

- (void)asyWriteData:(NSData *)data runLoop:(NSRunLoop * _Nullable)runLoop completion:(SalStreamBlock)completion {
    
    if (_outputStream && [data isKindOfClass:[NSData class]] && completion) {
        _oriData    = data;
        _needLength = data.length;
        _lastLength = data.length;
        _dataType = SalStreamDataType_ASYN;
        [_outputStream setDelegate:self];
        
        if ([runLoop isKindOfClass:[NSRunLoop class]]) {
            _streamRunLoop = runLoop;
        } else {
            _streamRunLoop = [NSRunLoop currentRunLoop];
        }
        [_outputStream scheduleInRunLoop:_streamRunLoop forMode:NSRunLoopCommonModes];
        if (_outputStream.streamStatus == NSStreamStatusAtEnd || _outputStream.streamStatus == NSStreamStatusClosed) {
            completion(nil, _needLength - _lastLength, _outputStream.streamError);
        } else if (_outputStream.streamStatus == NSStreamStatusError) {
            completion(nil, _needLength - _lastLength, _outputStream.streamError);
        } else {
            _completeBlock = completion;
        }
    }
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    
    if (aStream == _outputStream) {
        switch (eventCode) {
            case NSStreamEventNone: {
                NSLog(@"NSStreamEventNone");
                break;
            }
            case NSStreamEventOpenCompleted: {
                NSLog(@"NSStreamEventOpenCompleted");
                break;
            }
            case NSStreamEventHasBytesAvailable: {
                NSLog(@"NSStreamEventHasBytesAvailable");
                break;
            }
            case NSStreamEventHasSpaceAvailable: {
                NSLog(@"NSStreamEventHasSpaceAvailable");
                if (_dataType == SalStreamDataType_ASYN) {
                    [self startReadDataWhenSpaceAvailable];
                }
                break;
            }
            case NSStreamEventErrorOccurred: {
                NSLog(@"NSStreamEventErrorOccurred");
                [self didFinishWriteData];
                break;
            }
            case NSStreamEventEndEncountered: {
                NSLog(@"NSStreamEventEndEncountered");
                [self didFinishWriteData];
                break;
            }
        }
    }
}

#pragma mark - 开始写入数据
- (NSInteger)startWriteDataWithStream:(NSOutputStream *)outputStream {
    
    //    const uint8_t * buffer = [_oriData bytes];
    NSInteger readBytes = _bytesEach;
    while (_lastLength > 0) {
        readBytes = MIN(_lastLength, _bytesEach);
        uint8_t buffer[readBytes];
        [_oriData getBytes:buffer range:NSMakeRange(_needLength - _lastLength, readBytes)];
        NSInteger didReadLength = [self cycleWriteDataWithStream:outputStream readLength:readBytes buffer:buffer];
        _lastLength = _lastLength - didReadLength;
    }
    return _needLength - _lastLength;
}

- (NSInteger)cycleWriteDataWithStream:(NSOutputStream *)outputStream readLength:(NSInteger)readLength buffer:(const uint8_t *)buffer {
    
    NSInteger resultLength = 0;
    while (1) {
        if ([outputStream hasSpaceAvailable]) {
            resultLength = [self writeWithStream:outputStream readLength:readLength buffer:buffer];
            if (resultLength > 0) {
                break;
            }
        }
    }
    return resultLength;
}

#pragma mark - 异步读取数据
- (void)startReadDataWhenSpaceAvailable {
    
    if (_lastLength > 0) {
        NSInteger readBytes = MIN(_lastLength, _bytesEach);
        uint8_t buffer[readBytes];
        [_oriData getBytes:buffer range:NSMakeRange(_needLength - _lastLength, readBytes)];
        NSInteger didReadLength = [self writeWithStream:_outputStream readLength:readBytes buffer:buffer];
        _lastLength = _lastLength - didReadLength;
        if (_lastLength <= 0) {
            [self didFinishWriteData];
        }
    }
}

- (void)didFinishWriteData {
    
    if (_completeBlock) {
        _completeBlock(nil, _needLength - _lastLength, _outputStream.streamError);
    }
    _oriData     = nil;
    _completeBlock = nil;
}

#pragma mark - read
- (NSInteger)writeWithStream:(NSOutputStream *)outputStream readLength:(NSInteger)readLength buffer:(const uint8_t *)buffer {
    
    NSInteger resultLength = 0;
    if (buffer != NULL && readLength > 0 && outputStream) {
        resultLength = [outputStream write:buffer maxLength:readLength];
    }
    return resultLength;
}

#pragma mark - dealloc
- (void)dealloc {
    
    if (_outputStream) {
        if (_outputStream.streamStatus != NSStreamStatusClosed) {
            [_outputStream close];
        }
        [_outputStream setDelegate:nil];
        if (_streamRunLoop) {
            [_outputStream removeFromRunLoop:_streamRunLoop forMode:NSRunLoopCommonModes];
            _streamRunLoop = nil;
        }
        _outputStream = nil;
    }
    _oriData     = nil;
    _completeBlock = nil;
//    NSLog(@"<<%@ dealloc>>", self);
}

@end

@implementation SalStorageStream

+ (NSData *)readDataFromPath:(NSString *)path dataLength:(NSInteger)length {
    
    NSData * data = nil;
    if ([path isKindOfClass:[NSString class]] && path.length > 0 && length > 0) {
        SalInputStream * inputStream = [SalInputStream streamWithPath:path];
        data = [inputStream readDataWithLength:length];
    }
    return data;
}

+ (NSInteger)writeDataToPath:(NSString *)path data:(NSData *)data {
    
    NSInteger length = 0;
    if ([path isKindOfClass:[NSString class]] && path.length > 0 && [data isKindOfClass:[NSData class]] && data.length > 0) {
        SalOutputStream * outputStream = [SalOutputStream streamWithPath:path append:NO];
        length = [outputStream writeData:data];
    }
    return length;
}

+ (SalInputStream *)asyReadDataFromPath:(NSString *)path dataLength:(NSInteger)length completion:(SalStreamBlock)completion {
    
    return [self asyReadDataFromPath:path dataLength:length runLoop:nil                              completion:completion];
}

+ (SalOutputStream *)asyWriteDataToPath:(NSString *)path data:(NSData *)data completion:(SalStreamBlock)completion {
    
    return [self asyWriteDataToPath:path data:data runLoop:nil completion:completion];
}

+ (SalInputStream *)asyReadDataFromPath:(NSString *)path
                             dataLength:(NSInteger)length
                                runLoop:(NSRunLoop * _Nullable)runLoop
                             completion:(SalStreamBlock)completion {
    
    SalInputStream * inputStream = nil;
    if ([path isKindOfClass:[NSString class]] && path.length > 0 && length > 0) {
        inputStream = [SalInputStream streamWithPath:path];
        [inputStream asyReadDataWithLength:length startOffset:0 runLoop:runLoop completion:completion];
    } else {
        completion(nil, 0, [NSError errorWithDomain:NSCocoaErrorDomain code:-100 userInfo:@{@"NSLocalizedDescriptionKey": @"参数错误"}]);
    }
    return inputStream;
}

+ (SalOutputStream *)asyWriteDataToPath:(NSString *)path
                                   data:(NSData *)data
                                runLoop:(NSRunLoop * _Nullable)runLoop
                             completion:(SalStreamBlock)completion {
    
    SalOutputStream * outputStream = nil;
    if ([path isKindOfClass:[NSString class]] && path.length > 0 && [data isKindOfClass:[NSData class]] && data.length > 0) {
        outputStream = [SalOutputStream streamWithPath:path append:NO];
        [outputStream asyWriteData:data runLoop:runLoop completion:completion];
    } else {
        completion(nil, 0, [NSError errorWithDomain:NSCocoaErrorDomain code:-100 userInfo:@{@"NSLocalizedDescriptionKey": @"参数错误"}]);
    }
    return outputStream;
}

@end
