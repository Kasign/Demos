//
//  UIColor+custom.m
//  leci
//
//  Created by 熊文博 on 14-2-15.
//  Copyright (c) 2014年 Leci. All rights reserved.
//

#import "UIColor+custom.h"

@implementation UIColor (custom)

+ (UIColor *)colorWithHex:(int)hex
{
    return [UIColor colorWithHex:hex alpha:1.0f];
}

+ (UIColor *)colorWithHex:(int)hex alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0
                            blue:((float)(hex & 0xFF))/255.0 alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)hex
{
    return [UIColor colorWithHexString:hex alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)hex alpha:(CGFloat)alpha {
    if ([hex isEqualToString:@""]) {
        return nil;
    }
    NSString *cString = [[hex stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return [UIColor whiteColor];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor whiteColor];
   
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];

}

+ (UIColor *)lightBlueColor
{
    return [UIColor colorWithHex:0x2ea4ff];
}

+ (UIColor *)midColorFromColor:(UIColor *)fromColor ToColor:(UIColor *)toColor Progress:(CGFloat)progress
{
    if (progress >= 1) {
        return toColor;
    }
    if (progress <= 0) {
        return fromColor;
    }
    
    CGFloat fromR;
    CGFloat fromG;
    CGFloat fromB;
    CGFloat fromA;
    [fromColor getRed:&fromR green:&fromG blue:&fromB alpha:&fromA];
    
    CGFloat toR;
    CGFloat toG;
    CGFloat toB;
    CGFloat toA;
    [toColor getRed:&toR green:&toG blue:&toB alpha:&toA];
    
    return [UIColor colorWithRed:fromR+(toR-fromR)*progress
                           green:fromG+(toG-fromG)*progress
                            blue:fromB+(toB-fromB)*progress
                           alpha:fromA+(toA-fromA)*progress];
}
@end
