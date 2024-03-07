//
//  FlyImageDecode.h
//  FlyImageDecode
//
//  Created by Walg on 2021/5/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlyImageDecode : NSObject

+ (CGImageSourceRef)imageceSourRefWithPath:(NSString *)path;
+ (CGImageRef)imageRefWithPath:(NSString *)path;
+ (UIImage *)imageWithPath:(NSString *)path;
+ (UIImage *)imageWithContentsOfFile:(NSString *)path;
+ (UIImage *)decodeImageWithPath:(NSString *)path size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
