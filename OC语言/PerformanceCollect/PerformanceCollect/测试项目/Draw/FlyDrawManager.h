//
//  FlyDrawManager.h
//  算法+链表
//
//  Created by Walg on 2019/10/25.
//  Copyright © 2019 Fly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlyDrawManager : NSObject

+ (UIImage *)imageBlackToTransparent:(UIImage *)image color:(UIColor *)color whiteToTransparent:(BOOL)transparent;

@end

NS_ASSUME_NONNULL_END
