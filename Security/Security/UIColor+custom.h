//
//  UIColor+custom.h
//  leci
//
//  Created by 熊文博 on 14-2-15.
//  Copyright (c) 2014年 Leci. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (custom)

+ (UIColor *)colorWithHex:(int)hex;

+ (UIColor *)colorWithHex:(int)hex alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)hex;

+ (UIColor *)colorWithHexString:(NSString *)hex alpha:(CGFloat)alpha;

+ (UIColor *)lightBlueColor;

+ (UIColor *)midColorFromColor:(UIColor *)fromColor ToColor:(UIColor *)toColor Progress:(CGFloat)progress;

@end
