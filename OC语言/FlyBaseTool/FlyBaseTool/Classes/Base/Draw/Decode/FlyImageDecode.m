//
//  FlyImageDecode.m
//  FlyImageDecode
//
//  Created by Walg on 2021/5/15.
//

#import "FlyImageDecode.h"

@implementation FlyImageDecode

+ (CGImageSourceRef)imageceSourRefWithPath:(NSString *)path {
    
    return CGImageSourceCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:path], NULL);
}

+ (CGImageRef)imageRefWithPath:(NSString *)path {
    
    CGImageSourceRef imageSourceRef = [self imageceSourRefWithPath:path];
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(imageSourceRef, 0, NULL);
    CFRelease(imageSourceRef);
    return imageRef;
}

+ (UIImage *)imageWithPath:(NSString *)path {
    
    CGImageRef imageRef = [self imageRefWithPath:path];
    UIImage *image = [[UIImage alloc] initWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    return image;
}

+ (UIImage *)imageWithContentsOfFile:(NSString *)path {
    
    return [UIImage imageWithContentsOfFile:path];
}

+ (UIImage *)decodeImageWithPath:(NSString *)path size:(CGSize)size {
    
    return nil;
}

@end
