//
//  FlyBaseController.h
//  算法+链表
//
//  Created by mx-QS on 2019/8/16.
//  Copyright © 2019 Fly. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FlyLog(format, ...) printf("\n%s  %s\n", [[NSString stringWithFormat:@"%@", [NSDate dateWithTimeIntervalSinceNow:8 * 60 * 60]] UTF8String], [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])

NS_ASSUME_NONNULL_BEGIN

@interface FlyBaseController : UIViewController

@end

NS_ASSUME_NONNULL_END
