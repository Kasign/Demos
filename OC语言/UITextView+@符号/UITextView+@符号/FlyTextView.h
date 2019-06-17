//
//  FlyTextView.h
//  UITextView+@符号
//
//  Created by mx-QS on 2019/5/15.
//  Copyright © 2019 Fly. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FlyNormalLog(format, ...) printf("\n%s  %s\n", [[NSString stringWithFormat:@"%@", [NSDate dateWithTimeIntervalSinceNow:8 * 60 * 60]] UTF8String], [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])

#define FLyScreenWidth [UIScreen mainScreen].bounds.size.width
#define FlyScreenHeight [UIScreen mainScreen].bounds.size.height

NS_ASSUME_NONNULL_BEGIN

@interface FlyTextView : UITextView

@end

NS_ASSUME_NONNULL_END
