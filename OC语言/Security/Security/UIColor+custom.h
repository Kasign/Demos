//
//  PrefixHeader.pch
//  Security
//
//  Created by walg on 2017/1/4.
//  Copyright © 2017年 walg. All rights reserved.
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
