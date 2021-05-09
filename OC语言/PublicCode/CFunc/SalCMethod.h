//
//  SalCMethod.h
//  Unity-iPhone
//
//  Created by Qiushan on 2021/2/24.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SalStorageType) {
    SalStorageType_NONE   = 0,
    SalStorageType_MEMORY = 5,
    SalStorageType_NORMAL = 10,
    SalStorageType_IMPORT = 15,
    SalStorageType_PUBLIC = 20,
};

typedef NS_ENUM(NSUInteger, SalSaveDataType) {
    SalSaveDataType_NONE       = 0,
    SalSaveDataType_DATA       = 10,
    SalSaveDataType_IMAGE      = 11,
    SalSaveDataType_AUDIO      = 12,
    SalSaveDataType_STRING     = 13,
    SalSaveDataType_ARRAY      = 14,
    SalSaveDataType_DICTIONARY = 15,
    SalSaveDataType_NUMBER     = 16,
    SalSaveDataType_POINTER    = 17,
    SalSaveDataType_UNKNOWN    = 99,
};

NS_ASSUME_NONNULL_BEGIN

extern NSString * SALRandomName(void);
extern NSString * SALConverPath(id currentPath);
extern BOOL SALIsEffectivePath(NSString * path);

extern NSData * SALStreamDataFromFile(NSString * path, SalSaveDataType dataType, NSInteger bytes);
extern BOOL SALWriteDataToFile(NSData * saveData, NSString * path);
extern BOOL SALWriteObjectToFile(id saveData, NSString * path);
extern id SALReadDataFromFile(NSString * path, SalSaveDataType dataType, NSInteger fileSize);
extern BOOL SALRemoveItem(NSString * filePath);
extern BOOL SALMoveItemToTargetPath(NSString * targetPath, NSString * fromPath);

extern SalSaveDataType SALDataTypeWithFileName(NSString * fileName);
extern SalSaveDataType SALDataTypeWithData(id data);

extern NSString * SALMD5Key(NSString * key);

extern CGFloat ConverNum(CGFloat num);
extern CGRect SalDirctRect(CGRect rect);
extern CGPoint SalDirctPoint(CGPoint point);
extern CGSize SalDirctSize(CGSize size);

NS_ASSUME_NONNULL_END
