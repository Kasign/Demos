//
//  SalStorageStream.h
//  Unity-iPhone
//
//  Created by Qiushan on 2020/11/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SalStreamBlock)(NSData * _Nullable targetData, NSInteger length, NSError * _Nullable error);

@interface SalInputStream : NSObject

@property (nonatomic, assign) NSUInteger   bytesEach;
@property (nonatomic, copy)   NSString   * path;

+ (instancetype)streamWithPath:(NSString *)path;
- (instancetype)initWithPath:(NSString *)path;

/// 可反复调用，设置当前数据读取起始位置
/// @param offset 当前数据读取起始位置
- (void)setPropertyForOffset:(NSInteger)offset;

- (NSData *)readDataWithLength:(NSInteger)length;
- (NSData *)readDataWithLength:(NSInteger)length startOffset:(NSInteger)startOffset;

- (void)asyReadDataWithLength:(NSInteger)length
                   completion:(SalStreamBlock)completion;

- (void)asyReadDataWithLength:(NSInteger)length
                  startOffset:(NSInteger)startOffset
                   completion:(SalStreamBlock)completion;

- (void)asyReadDataWithLength:(NSInteger)length
                  startOffset:(NSInteger)startOffset
                      runLoop:(NSRunLoop * _Nullable)runLoop
                   completion:(SalStreamBlock)completion;

@end

@interface SalOutputStream : NSObject

@property (nonatomic, assign) NSUInteger    bytesEach;
@property (nonatomic, copy)   NSString   *  path;
@property (nonatomic, assign) BOOL          needAppend;

+ (instancetype)streamWithPath:(NSString *)path append:(BOOL)append;
- (instancetype)initWithPath:(NSString *)path append:(BOOL)append;

- (NSInteger)writeData:(NSData *)data;

- (void)asyWriteData:(NSData *)data block:(SalStreamBlock)block;

- (void)asyWriteData:(NSData *)data
             runLoop:(NSRunLoop * _Nullable)runLoop
          completion:(SalStreamBlock)completion;

@end

@interface SalStorageStream : NSObject

+ (NSData *)readDataFromPath:(NSString *)path dataLength:(NSInteger)length;
+ (NSInteger)writeDataToPath:(NSString *)path data:(NSData *)data;

+ (SalInputStream *)asyReadDataFromPath:(NSString *)path dataLength:(NSInteger)length completion:(SalStreamBlock)completion;
+ (SalOutputStream *)asyWriteDataToPath:(NSString *)path data:(NSData *)data completion:(SalStreamBlock)completion;

+ (SalInputStream *)asyReadDataFromPath:(NSString *)path
                             dataLength:(NSInteger)length
                                runLoop:(NSRunLoop * _Nullable)runLoop
                             completion:(SalStreamBlock)completion;

+ (SalOutputStream *)asyWriteDataToPath:(NSString *)path
                                   data:(NSData *)data
                                runLoop:(NSRunLoop * _Nullable)runLoop
                             completion:(SalStreamBlock)completion;

@end

NS_ASSUME_NONNULL_END
