//
//  SALSteam.h
//  Unity-iPhone
//
//  Created by Qiushan on 2020/6/28.
//

#import <Foundation/Foundation.h>
#import "SalImageInfo.h"

NS_ASSUME_NONNULL_BEGIN

//坐标转换
extern CGFloat ConverNum(CGFloat num);
extern CGSize  GetDirctSize(CGSize size);
extern CGPoint GetDirctPoint(CGPoint point);
extern CGRect  GetDirctRect(CGRect rect);

@interface SALSteam : NSObject

@property (nonatomic, strong) SalImageInfo   *   imageInfo;
@property (nonatomic, assign) CGRect             cropArea;    // 0 ~ 1
@property (nonatomic, assign) CGRect             visibleArea; // 0 ~ 1
@property (nonatomic, assign) BOOL               isSteam;     //是否有效

- (UIImage *)currentImage;

@end

NS_ASSUME_NONNULL_END
