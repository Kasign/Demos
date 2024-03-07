//
//  FlyCoreImage.m
//  FlyImageDecode
//
//  Created by Walg on 2021/5/9.
//

#import "FlyCIImage.h"

@implementation FlyCIImage

+ (UIImage *)decodeImageWithPath:(NSString *)path size:(CGSize)size {
    
    UIImage *image = [self imageWithPath:path];
    //计算缩放比例
    float radio = MIN(size.width/image.size.width, size.height/image.size.height);
    CIImage *inputImg = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CILanczosScaleTransform" withInputParameters:@{
        kCIInputImageKey : inputImg,
        kCIInputScaleKey : @(radio)
    }];
    //获取outImag
    CIImage *ciimage = filter.outputImage;
    
    UIImage *resultImg = nil;
    if (!resultImg) {
        //将图片绘制到画布上
        CIContext *context = [CIContext context];
        CGImageRef cgImg = [context createCGImage:ciimage fromRect:ciimage.extent];
        resultImg = [UIImage imageWithCGImage:cgImg];
        CGImageRelease(cgImg);
    }
    return resultImg;
}

@end
