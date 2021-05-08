//
//  SALSteam.h
//  Unity-iPhone
//
//  Created by Qiushan on 2020/6/28.
//

#import <Foundation/Foundation.h>
#import "SalImageInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface SALSteam : NSObject

@property (nonatomic, strong) SalImageInfo   *   imageInfo;
@property (nonatomic, assign) CGRect             cropArea;
@property (nonatomic, assign) CGRect             visibleArea;
@property (nonatomic, assign) BOOL               isSteam;    //是否有效

- (UIImage *)currentImage;

@end

NS_ASSUME_NONNULL_END
