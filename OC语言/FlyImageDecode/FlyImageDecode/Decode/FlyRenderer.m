//
//  FlyRenderer.m
//  FlyImageDecode
//
//  Created by Walg on 2021/5/9.
//

#import "FlyRenderer.h"

@implementation FlyRenderer

+ (UIImage *)decodeImageWithPath:(NSString *)path size:(CGSize)size {
    
    UIImage *image = [self imageWithPath:path];
    CGSize imageSize = image.size;
    float maxSize = fmax(imageSize.width, imageSize.height);
    size.width = size.width * imageSize.width / maxSize;
    size.height = size.height * imageSize.height / maxSize;
    UIGraphicsImageRenderer * render = [[UIGraphicsImageRenderer alloc] initWithSize:size];
    return  [render imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        //绘制当前图片
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    }];
}

@end
