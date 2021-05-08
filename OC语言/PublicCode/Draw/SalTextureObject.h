//
//  SalTextureObject.h
//  Unity-iPhone
//
//  Created by Qiushan on 2020/6/18.
//

#import <Foundation/Foundation.h>
#import "SalCommon.h"

NS_ASSUME_NONNULL_BEGIN

@class SalTextureObject;
typedef void(^TextureChangeBlock)(SalTextureObject * currentObject, BOOL isSuccess);

@class SalContent;
@interface SalTextureObject : NSObject

@property (nonatomic, weak)   SalContent        *  contentNode;
@property (nonatomic, assign) SALEdgeInsets        edgeInsets;
@property (nonatomic, assign) CGRect               cropRect;
@property (nonatomic, assign) CGRect               visibleArea;
@property (nonatomic, copy, readonly) NSString  *  key;

- (CGRect)currentCropArea;
- (UIImage *)currentImage;
///纹理发生改变
- (void)changeTextureWithKey:(NSString *)key block:(TextureChangeBlock __nullable)block;
- (void)changeOriImage:(UIImage *)oriImage block:(TextureChangeBlock __nullable)block;
- (void)changeOriInfoAndDisplay:(SalImageInfo *)oriImageInfo block:(TextureChangeBlock __nullable)block;

- (void)contentNodeDidChangeSize:(SalContent *)contentNode size:(CGSize)size;

- (float)alphaAtPixel:(CGPoint)point currentSize:(CGSize)currentSize;

@end

NS_ASSUME_NONNULL_END
