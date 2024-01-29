//
//  LJTextureRender.m
//  MetalDemo
//
//  Created by Walg on 2024/1/15.
//

#import "LJTextureRender.h"
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSUInteger, LJRenderingResizingMode) {
    LJRenderingResizingModeScale = 0,
    LJRenderingResizingModeAspect,
    LJRenderingResizingModeAspectFill,
};

@interface LJTextureRender ()

@property (nonatomic, strong) UIImage *image;

@end

@implementation LJTextureRender

- (void)initConfig {
    
    [self setupFragment];
}

- (void)setupFragment {
    
    self.image = [UIImage imageNamed:@"abc"];
    UIImage *image = self.image;
    MTLTextureDescriptor *textureDesc = [MTLTextureDescriptor new];
    textureDesc.pixelFormat = MTLPixelFormatRGBA8Unorm;
    textureDesc.width = image.size.width;
    textureDesc.height = image.size.height;
    self.texture = [self.device newTextureWithDescriptor:textureDesc];
    
    MTLRegion region = {
        {0, 0, 0},
        {textureDesc.width, textureDesc.height, 1}
    };
    Byte *imageBytes = LJLoadImage(image);
    if (imageBytes) {
        [self.texture replaceRegion:region mipmapLevel:0 withBytes:imageBytes bytesPerRow:image.size.width * 4];
        free(imageBytes);
        imageBytes = NULL;
    }
}

// 初始化pipelineState
- (void)setUpPineline:(MTKView *)mtkView {
    
    MTLRenderPipelineDescriptor *pinelineDesc = [MTLRenderPipelineDescriptor new];
    id <MTLLibrary> library = [self.device newDefaultLibrary];
    pinelineDesc.vertexFunction = [library newFunctionWithName:@"vertexShader"];
    pinelineDesc.fragmentFunction = [library newFunctionWithName:@"fragmentShader"];
    pinelineDesc.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
    self.pipelineState = [self.device newRenderPipelineStateWithDescriptor:pinelineDesc error:nil];
}

- (void)setUpRenderCommandEncoder:(id<MTLRenderCommandEncoder>)renderCommandEncoder {
    
    [super setUpRenderCommandEncoder:renderCommandEncoder];
    // 设置顶点数据
    [renderCommandEncoder setVertexBuffer:self.vertices offset:0 atIndex:0];
    // 设置纹理数据
    [renderCommandEncoder setFragmentTexture:self.texture atIndex:0];
    // 开始绘制
    [renderCommandEncoder drawPrimitives:MTLPrimitiveTypeTriangleStrip 
                             vertexStart:0
                             vertexCount:self.numVertices];
}

- (void)setUpRenderPassDescriptor:(MTLRenderPassDescriptor *)renderPassDescriptor {
    
    [super setUpRenderPassDescriptor:renderPassDescriptor];
    
    if (self.vertices) {
        return;
    }
    UIImage *image = self.image;
    float heightScaling = 1.0;
    float widthScaling = 1.0;
    CGSize drawableSize = CGSizeMake(renderPassDescriptor.colorAttachments[0].texture.width, renderPassDescriptor.colorAttachments[0].texture.height);
    CGRect bounds = CGRectMake(0, 0, drawableSize.width, drawableSize.height);
    CGRect insetRect = AVMakeRectWithAspectRatioInsideRect(image.size, bounds);
    
    LJRenderingResizingMode fillMode = LJRenderingResizingModeAspect;
    switch (fillMode) {
        case LJRenderingResizingModeScale: {
            widthScaling = 1.0;
            heightScaling = 1.0;
        };
            break;
        case LJRenderingResizingModeAspect:
        {
            widthScaling = insetRect.size.width / drawableSize.width;
            heightScaling = insetRect.size.height / drawableSize.height;
        };
            break;
        case LJRenderingResizingModeAspectFill:
        {
            widthScaling = drawableSize.height / insetRect.size.height;
            heightScaling = drawableSize.width / insetRect.size.width;
        };
            break;
    }
    
    LJVertex vertices[] = {
        // 顶点坐标 x, y, z, w  --- 纹理坐标 x, y
        { {-widthScaling,  heightScaling, 0.0, 1.0}, {0.0, 0.0} },
        { { widthScaling,  heightScaling, 0.0, 1.0}, {1.0, 0.0} },
        { {-widthScaling, -heightScaling, 0.0, 1.0}, {0.0, 1.0} },
        { { widthScaling, -heightScaling, 0.0, 1.0}, {1.0, 1.0} },
    };
    
    self.vertices = [self.device newBufferWithBytes:vertices length:sizeof(vertices) options:MTLResourceStorageModeShared];
    self.numVertices = sizeof(vertices) / sizeof(LJVertex);
}

@end
