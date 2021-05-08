//
//  SalTextureObject.h
//  Unity-iPhone
//
//  Created by Qiushan on 2020/6/18.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@class SalTextureObject;
typedef void(^TextureChangeBlock)(SalTextureObject * textureObject, BOOL isSuccess);

@class SalContent;
@interface SalTextureObject : NSObject

@property (nonatomic, weak)   SalContent           *   contentNode;
@property (nonatomic, assign) CGRect                   cropRect;
@property (nonatomic, assign) SALEdgeInsets            edgeInsets;

@property (nonatomic, strong) NSArray              *   nineInfoArr;
@property (nonatomic, assign) CGRect                   visibleArea;

- (void)changeTextureWithKey:(NSString *)key block:(TextureChangeBlock __nullable)block;
- (void)changeOriImage:(UIImage *)oriImage block:(TextureChangeBlock __nullable)block;
- (void)changeOriInfoAndDisplay:(SalImageInfo *)oriImageInfo block:(TextureChangeBlock __nullable)block;

- (void)contentNodeDidChangeSize:(SalContent *)contentNode size:(CGSize)size;

- (CGFloat)alphaAtPixel:(CGPoint)point currentSize:(CGSize)currentSize;

@end

NS_ASSUME_NONNULL_END
