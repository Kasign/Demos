//
//  FlyTextManager.h
//  UITextView+@符号
//
//  Created by mx-QS on 2019/4/26.
//  Copyright © 2019 Fly. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlyTextManager : NSObject

+ (NSAttributedString *)attributedStringWtihOriStr:(NSString *)oriStr symbolArr:(NSArray *)symbolArr configDict:(NSMutableDictionary *)configDic oriBlockDict:(NSDictionary *_Nullable*_Nonnull)ori_blockRangeDic showBlockDict:(NSDictionary *_Nullable*_Nonnull)show_blockRangeDic;

+ (NSString *)stringWhenChangedWithOriText:(NSString *)oriText showText:(NSString *)showText oriRangeDic:(NSDictionary *)oriRangeDic showRangeDic:(NSDictionary *)showRangeDic replaceRange:(NSRange)replaceRange replaceText:(NSString *)replaceText;

@end

NS_ASSUME_NONNULL_END
