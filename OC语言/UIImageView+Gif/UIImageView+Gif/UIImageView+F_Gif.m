//
//  UIImageView+F_Gif.m
//  UIImageView+Gif
//
//  Created by 66-admin-qs. on 2018/10/17.
//  Copyright © 2018 Fly. All rights reserved.
//

#import "UIImageView+F_Gif.h"

@implementation UIImageView (F_Gif)

- (void)fly_setImageWithGifFileName:(NSString *)fileName {
    
    NSData * imageData = nil;
    UIImage * image = [UIImage imageWithData:imageData];
    
    if (!imageData) {
        return;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *animatedImage;
    
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:imageData];
    }
    else {
        NSMutableArray *images = [NSMutableArray array];
        
        NSTimeInterval duration = 0.0f;
        
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            
            duration += [self sd_frameDurationAtIndex:i source:source];
            
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            
            CGImageRelease(image);
        }
        
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    
    CFRelease(source);
    
}

@end
