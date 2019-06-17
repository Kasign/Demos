//
//  FlyTextManager.m
//  UITextView+@符号
//
//  Created by mx-QS on 2019/4/26.
//  Copyright © 2019 Fly. All rights reserved.
//

#import "FlyTextManager.h"
#import <UIKit/UIKit.h>

@implementation FlyTextManager

+ (NSAttributedString *)attributedStringWtihOriStr:(NSString *)oriStr symbolArr:(NSArray *)symbolArr configDict:(NSMutableDictionary *)configDic oriBlockDict:(NSDictionary **)ori_blockRangeDic showBlockDict:(NSDictionary **)show_blockRangeDic {

    NSString * textStr = oriStr;
    UIFont * numFont   = [configDic objectForKey:@"hightlight_font"];
    UIColor * numColor = [configDic objectForKey:@"hightlight_color"];
    [configDic removeObjectForKey:@"hightlight_font"];
    [configDic removeObjectForKey:@"hightlight_color"];
    
    
    NSDictionary * oriRangeDict = nil;
    NSDictionary * showRangeDic = nil;
    textStr = [self mx_symbolRangsWithString:textStr oriRangeDic:&oriRangeDict showRangeDic:&showRangeDic symbolArr:symbolArr];

    if (ori_blockRangeDic) {
        *ori_blockRangeDic = oriRangeDict;
    }
    if (show_blockRangeDic) {
        *show_blockRangeDic = showRangeDic;
    }

    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:textStr attributes:configDic];

    NSMutableDictionary * numDict = [NSMutableDictionary dictionaryWithCapacity:2];
    if (numColor) {
        [numDict setObject:numColor forKey:NSForegroundColorAttributeName];
    }
    if (numFont) {
        [numDict setObject:numFont forKey:NSFontAttributeName];
    }

    if (showRangeDic.allKeys.count && numDict.count) {
        for (NSArray * rangeArr in showRangeDic.allValues) {
            if ([rangeArr isKindOfClass:[NSArray class]]) {
                for (NSValue * value in rangeArr) {
                    if ([value isKindOfClass:[NSValue class]]) {
                        NSRange rang = [value rangeValue];
                        if (rang.location + rang.length <= textStr.length) {
                            [attributedString setAttributes:numDict range:rang];
                        }
                    }
                }
            }
        }
    }
    
    return [attributedString copy];
}

+ (NSString *)mx_symbolRangsWithString:(NSString *)string oriRangeDic:(NSDictionary **)ori_rangeDic showRangeDic:(NSDictionary **)show_rangeDict symbolArr:(NSArray *)symbolArr {
    
    NSString * resultStr = string;
    NSMutableDictionary * showRangeDic = [NSMutableDictionary dictionary];
    NSMutableDictionary * oriRangeDic  = [NSMutableDictionary dictionary];
    if (string) {
        
        NSMutableArray * oriRangeArr  = [NSMutableArray array];
        NSMutableArray * showRangeArr = [NSMutableArray array];
        
        NSString * textStr     = string;
        NSString * firstSymbol = symbolArr.firstObject;
        NSString * lastSymbol  = symbolArr.lastObject;
        NSString * symString   = [firstSymbol stringByAppendingString:lastSymbol];
        NSRange firstRang  = [textStr rangeOfString:firstSymbol];
        NSRange lastRang   = [textStr rangeOfString:lastSymbol];
        NSString * showStr = nil;
        
        NSRange oriFirstRang = [textStr rangeOfString:firstSymbol];
        NSRange oriLastRang  = [textStr rangeOfString:lastSymbol];
        
        [oriRangeDic  setObject:oriRangeArr  forKey:symString];
        [showRangeDic setObject:showRangeArr forKey:symString];
        
        while (firstRang.length != 0 && lastRang.length != 0 && lastRang.location > firstRang.location + firstRang.length) {
            
            NSRange currentRang = NSMakeRange(firstRang.location, lastRang.location + lastRang.length - firstRang.location);
            NSRange showRang = NSMakeRange(firstRang.location + firstRang.length, lastRang.location - firstRang.location - firstRang.length);
            
            showStr = [NSString stringWithFormat:@"【%@:怨气值】",[textStr substringWithRange:showRang]];
            
            textStr = [textStr stringByReplacingCharactersInRange:currentRang withString:showStr];
            
            showRang.location = showRang.location - firstSymbol.length;
            showRang.length   = showStr.length;
            
            firstRang = [textStr rangeOfString:firstSymbol];
            lastRang  = [textStr rangeOfString:lastSymbol];
            
            NSRange oriRange = NSMakeRange(oriFirstRang.location, NSMaxRange(oriLastRang) - oriFirstRang.location);
            oriFirstRang = [string rangeOfString:firstSymbol options:NSLiteralSearch range:NSMakeRange(NSMaxRange(oriFirstRang), string.length - NSMaxRange(oriFirstRang))];
            oriLastRang = [string rangeOfString:lastSymbol options:NSLiteralSearch range:NSMakeRange(NSMaxRange(oriLastRang), string.length - NSMaxRange(oriLastRang))];
            
            [oriRangeArr addObject:[NSValue valueWithRange:oriRange]];
            [showRangeArr addObject:[NSValue valueWithRange:showRang]];
        }
        resultStr = textStr;
    }
    
    if (ori_rangeDic) {
        *ori_rangeDic = [oriRangeDic copy];
    }
    if (show_rangeDict) {
        *show_rangeDict = [showRangeDic copy];
    }
    
    return resultStr;
}

+ (NSString *)stringWhenChangedWithOriText:(NSString *)oriText showText:(NSString *)showText oriRangeDic:(NSDictionary *)oriRangeDic showRangeDic:(NSDictionary *)showRangeDic replaceRange:(NSRange)replaceRange replaceText:(NSString *)replaceText selectRange:(NSRange *)selected_range {
    
    NSRange selectedRange = replaceRange;
    for (NSString * key in showRangeDic.allKeys) {
        NSArray * oriArr  = [oriRangeDic  objectForKey:key];
        NSArray * showArr = [showRangeDic objectForKey:key];
        for (NSInteger index = 0; index < showArr.count; index ++) {
            
            NSValue * oriValue  = [oriArr objectAtIndex:index];
            NSValue * showValue = [showArr objectAtIndex:index];
            NSRange oriRange  = [oriValue rangeValue];
            NSRange showRange = [showValue rangeValue];
            
            if ([self isIntersectRange1:replaceRange range2:showRange]) {
                replaceRange.location = MIN(replaceRange.location - showRange.location + oriRange.location, oriRange.location);
                replaceRange.length   = MAX(NSMaxRange(replaceRange), NSMaxRange(oriRange)) - replaceRange.location;
                selectedRange.location = MIN(showRange.location, selectedRange.location);
                break;
            } else {
                if (NSMaxRange(showRange) <= replaceRange.location) {//在后面
                    if (index == showArr.count - 1) {
                        replaceRange.location = replaceRange.location - NSMaxRange(showRange) + NSMaxRange(oriRange);
                        break;
                    }
                } else {//在前面
                    replaceRange.location = replaceRange.location - showRange.location + oriRange.location;
                    break;
                }
            }
            
        }
    }
    oriText = [oriText stringByReplacingCharactersInRange:replaceRange withString:replaceText];
    if (selected_range) {
        *selected_range = NSMakeRange(selectedRange.location + replaceText.length, 0);
    }
    
    return oriText;
}

+ (BOOL)isIntersectRange1:(NSRange)range1 range2:(NSRange)range2 {
    
    BOOL result = NO;
    
    if (((range1.location > range2.location) && (range1.location - range2.location) < range2.length) || ((range2.location > range1.location) && (range2.location - range1.location) < range1.length)) {
        result = YES;
    }
    return result;
}


@end
