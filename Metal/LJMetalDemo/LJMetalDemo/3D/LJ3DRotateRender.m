//
//  LJ3DRoateRender.m
//  MetalDemo
//
//  Created by Walg on 2024/1/16.
//

#import "LJ3DRotateRender.h"
#import <GLKit/GLKit.h>

@interface LJ3DRotateRender ()

@property (nonatomic, strong) UISwitch *rotationX;
@property (nonatomic, strong) UISwitch *rotationY;
@property (nonatomic, strong) UISwitch *rotationZ;
@property (nonatomic, strong) UISlider *slider;

/**
 MTL缓冲区
 以应用程序定义的格式存储数据的资源。
 @协议MTLBuffer
 概述
 MTLBuffer 对象只能与创建它的 MTLDevice 一起使用。 不要自己实现这个协议； 相反，使用以下 MTLDevice 方法来创建 MTLBuffer 对象：
 newBufferWithLength:options：使用新的存储分配创建 MTLBuffer 对象。
 newBufferWithBytes:length:options：通过将数据从现有存储分配复制到新分配来创建 MTLBuffer 对象。
 newBufferWithBytesNoCopy:length:options:deallocator：创建一个 MTLBuffer 对象，该对象重用现有的存储分配，并且不分配任何新的存储。
 Metal 框架不知道 MTLBuffer 的内容，只知道它的大小。 您定义缓冲区中数据的格式，并确保您的应用程序和着色器知道如何读取和写入数据。 例如，您可以在着色器中创建一个结构体，用于定义要存储在缓冲区中的数据及其内存布局。
 如果您使用托管资源存储模式（MTLStorageModeManaged）创建缓冲区，则必须调用 didModifyRange: 来告诉 Metal 将任何更改复制到 GPU。
 */
@property (nonatomic, strong) id<MTLBuffer> indexBuffer;
@property (nonatomic, assign) NSUInteger indexCount;

@end

@implementation LJ3DRotateRender

- (void)initConfig {
    
    [self setupVertex];
    [self setupTexture];
    [self setUpSubviews];
}

- (void)setUpSubviews {
    
    UILabel *xL = [self createLabelWithFrame:CGRectMake(20, 100, 20, 20) text:@"X"];
    _rotationX = [[UISwitch alloc] initWithFrame:CGRectMake(60, 100, 100, 20)];
    
    UILabel *yL = [self createLabelWithFrame:CGRectMake(20, 140, 20, 20) text:@"Y"];
    _rotationY = [[UISwitch alloc] initWithFrame:CGRectMake(60, 140, 100, 20)];
    
    UILabel *zL = [self createLabelWithFrame:CGRectMake(20, 180, 20, 20) text:@"Z"];
    _rotationZ = [[UISwitch alloc] initWithFrame:CGRectMake(60, 180, 100, 20)];
    
    UILabel *sL = [self createLabelWithFrame:CGRectMake(20, 220, 30, 20) text:@"速度"];
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(60, 220, 200, 20)];
    
    [self.superView addSubview:xL];
    [self.superView addSubview:_rotationX];
    
    [self.superView addSubview:yL];
    [self.superView addSubview:_rotationY];
    
    [self.superView addSubview:zL];
    [self.superView addSubview:_rotationZ];
    
    [self.superView addSubview:sL];
    [self.superView addSubview:_slider];
}

- (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text {
    
    UILabel *l = [[UILabel alloc] initWithFrame:frame];
    l.lineBreakMode = NSLineBreakByTruncatingTail;
    l.textAlignment = NSTextAlignmentLeft;
    l.numberOfLines = 1;
    l.font = [UIFont systemFontOfSize:12];
    l.textColor = [UIColor blackColor];
    l.text = text;
    return l;
}

- (void)setUpPineline:(MTKView *)mtkView {
    
    id<MTLLibrary> defaultLibrary = [self.device newDefaultLibrary];
    id<MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"vertex3DRotateShader"];
    id<MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"sampling3DRotateShader"];
    
    MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
    
    /**
     管道调用处理顶点的顶点函数。
     @property(可为空、可读写、非原子、强) id<MTLFunction> vertexFunction;
     讨论
     默认值为 nil。 必须始终指定顶点函数。 顶点函数可以是常规顶点函数或曲面细分后顶点函数。
     */
    pipelineStateDescriptor.vertexFunction = vertexFunction;
    
    /**
     管道调用来处理片段的片元函数。
     @property(可为空、可读写、非原子、强) id<MTLFunction>fragmentFunction;
     讨论
     默认值为 nil。 如果该值为 nil，则不存在片元函数，因此不会发生对颜色渲染目标的写入。 深度和模板写入以及可见性结果计数仍然可以继续进行。
     */
    pipelineStateDescriptor.fragmentFunction = fragmentFunction;
    pipelineStateDescriptor.colorAttachments[0].pixelFormat = self.mtkView.colorPixelFormat;
    self.pipelineState = [self.device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:NULL];
}

- (void)setupVertex {
    
    static const LYVertex quadVertices[] =
    {  // 顶点坐标                          顶点颜色                    纹理坐标
        {{-0.5f, 0.5f, 0.0f, 1.0f},      {0.0f, 0.0f, 1.0f},       {0.0f, 1.0f}},//左上
        {{0.5f, 0.5f, 0.0f, 1.0f},       {1.0f, 0.0f, 0.0f},       {1.0f, 1.0f}},//右上
        {{-0.5f, -0.5f, 0.0f, 1.0f},     {0.0f, 1.0f, 0.0f},       {0.0f, 0.0f}},//左下
        {{0.5f, -0.5f, 0.0f, 1.0f},      {0.0f, 0.0f, 0.0f},       {1.0f, 0.0f}},//右下
        {{0.0f, 0.0f, 1.0f, 1.0f},       {1.0f, 1.0f, 1.0f},       {0.5f, 0.5f}},//顶点
    };
    self.vertices = [self.device newBufferWithBytes:quadVertices
                                             length:sizeof(quadVertices)
                                            options:MTLResourceStorageModeShared];
    
    static int indices[] =
    { // 索引
        0, 3, 2,
        0, 1, 3,
        0, 2, 4,
        0, 4, 1,
        2, 3, 4,
        1, 4, 3,
    };
    /**
     newBufferWithBytes:长度:选项:
     分配给定长度的新缓冲区，并通过将现有数据复制到其中来初始化其内容。
     - (id<MTLBuffer>)newBufferWithBytes:(const void *)pointer
                               length:(NSUInteger)length
                              options:(MTLResourceOptions)options；
     必需的
     参数
     指针
     指向该方法从中复制初始化数据的起始内存地址的指针。
     长度
     新缓冲区的大小（以字节为单位）以及该方法从指针复制的字节数。
     选项
     一个 MTLResourceOptions 实例，用于设置缓冲区的存储和危险跟踪模式。 有关详细信息，请参阅资源基础知识和设置资源存储模式。
     返回值
     如果该方法成功完成，则一个新的 MTLBuffer 实例； 否则为零。
     */
    self.indexBuffer = [self.device newBufferWithBytes:indices
                                                length:sizeof(indices)
                                               options:MTLResourceStorageModeShared];
    
    self.indexCount = sizeof(indices) / sizeof(int);
}

- (void)setupTexture {
    
    UIImage *image = [UIImage imageNamed:@"abc"];
    MTLTextureDescriptor *textureDescriptor = [[MTLTextureDescriptor alloc] init];
    textureDescriptor.pixelFormat = MTLPixelFormatRGBA8Unorm;
    textureDescriptor.width = image.size.width;
    textureDescriptor.height = image.size.height;
    self.texture = [self.device newTextureWithDescriptor:textureDescriptor];
    
    MTLRegion region = {{ 0, 0, 0 }, {image.size.width, image.size.height, 1}};
    Byte *imageBytes = LJLoadImage(image);
    if (imageBytes) {
        
        /**
         替换区域：mipmapLevel：withBytes：bytesPerRow：
         将像素块复制到纹理切片 0 的一部分中。
         - (void)replaceRegion:(MTLRegion)region
         mipmapLevel:(NSUInteger)level
         withBytes:(const void *)pixelBytes
         bytesPerRow:(NSUInteger)bytesPerRow;
         必需的
         参数
         region
         纹理切片中像素块的位置。 该区域必须在切片的尺寸范围内。
         level
         一个零索引值，指定哪个 mipmap 级别是目标。 如果纹理没有 mipmap，请使用 0。
         pixelBytes
         指向内存中要复制的字节的指针。
         bytesPerRow
         源数据中一行的步幅（以字节为单位）。 对于 MTLTextureType1D 和 MTLTextureType1DArray，请使用 0。对于原始像素类型和打包像素类型，步长是一行中的像素数。 对于压缩像素格式，步幅是从一行块的开头到下一行块的开头的字节数。 当源数据仅由一行组成时，请使用 0。
         您的数据类型决定了您应该如何计算 bytesPerRow：
         对于原始或打包像素数据，请使用大于或等于一行中数据大小且小于 max * 像素大小的值。
         对于压缩像素数据，请使用压缩块大小的倍数。 使用 PowerVR 纹理压缩 (PVRTC) 时，请使用 0。
         小于纹理宽度或不是像素大小的倍数的非零值会导致错误。
         讨论
         该方法在CPU上运行并立即将像素数据复制到纹理中。 它不会与任何 GPU 对纹理的访问同步。 使用以下方法之一，确保在读取纹理内容之前完成写入或渲染纹理的所有操作：
         在 GPU 上使用 MTLBlitCommandEncoder 中的 SynchronizeResource: 或 SynchronizeTexture:slice:level: 命令进行同步。
         通过传递给 addCompletedHandler: 方法的回调在 CPU 上同步以异步处理完成，或使用 waitUntilCompleted 方法来阻止线程执行，直到 GPU 工作完成。
         如果纹理图像具有压缩像素格式，则仅写入块对齐区域。 如果区域维度的大小不是块大小的倍数，则包括边缘块和纹理维度（以 bytesPerRow 为单位）的空间。
         要将数据复制到私有纹理，请将数据复制到具有非私有存储的临时纹理，然后使用 MTLBlitCommandEncoder 将数据复制到私有纹理以供 GPU 使用。
         */
        [self.texture replaceRegion:region
                        mipmapLevel:0
                          withBytes:imageBytes
                        bytesPerRow:4 * image.size.width];
        free(imageBytes);
        imageBytes = NULL;
    }
}

/**
 找了很多文档，都没有发现metalKit或者simd相关的接口可以快捷创建矩阵的，于是只能从GLKit里面借力
 @param matrix GLKit的矩阵
 @return metal用的矩阵
 */
- (matrix_float4x4)getMetalMatrixFromGLKMatrix:(GLKMatrix4)matrix {
    
    matrix_float4x4 ret = (matrix_float4x4) {
        simd_make_float4(matrix.m00, matrix.m01, matrix.m02, matrix.m03),
        simd_make_float4(matrix.m10, matrix.m11, matrix.m12, matrix.m13),
        simd_make_float4(matrix.m20, matrix.m21, matrix.m22, matrix.m23),
        simd_make_float4(matrix.m30, matrix.m31, matrix.m32, matrix.m33),
    };
    return ret;
}

// 配置渲染命令编辑器
- (void)setUpRenderCommandEncoder:(id<MTLRenderCommandEncoder>)renderCommandEncoder {
    
    [super setUpRenderCommandEncoder:renderCommandEncoder];
    
    CGSize size = self.superView.bounds.size;
    
    float aspect = fabs(size.width / size.height);
    
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90.0), aspect, 0.1f, 10.f);
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0f, 0.0f, -2.0f);
    
    static float x = 0.0, y = 0.0, z = M_PI;
    
    if (self.rotationX.isOn) {
        x += self.slider.value;
    }
    if (self.rotationY.isOn) {
        y += self.slider.value;
    }
    if (self.rotationZ.isOn) {
        z += self.slider.value;
    }
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, x, 1, 0, 0);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, y, 0, 1, 0);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, z, 0, 0, 1);
    
    LYMatrix matrix = {[self getMetalMatrixFromGLKMatrix:projectionMatrix], [self getMetalMatrixFromGLKMatrix:modelViewMatrix]};
    
    /**
     从字节创建一个缓冲区并将其分配给顶点着色器参数表中的一个条目。
     - (void)setVertexBytes:(const void *)bytes length:(NSUInteger)length atIndex:(NSUInteger)index
     必需的
     参数
     bytes
     指向参数数据的指针，该方法将其复制到 MTLBuffer 并分配给缓冲区的顶点着色器参数表中的条目。
     length
     该方法从字节指针复制的字节数。
     index
     一个整数，表示缓冲区的顶点着色器参数表中的条目，该缓冲区存储该方法从字节创建的 MTLBuffer 的记录。
     讨论
     该方法相当于创建一个包含与 bytes 相同数据的 MTLBuffer 实例并调用 setVertexBuffer:offset:atIndex: 方法。 但是，此方法避免了创建缓冲区来存储数据的开销； 相反，Metal 管理数据。
     重要的
     仅对小于 4 KB 的一次性数据调用此方法。
     对于超过 4 KB 的数据，创建一个 MTLBuffer 实例并将其传递给 setVertexBuffer:offset:atIndex:。
     默认情况下，每个索引处的缓冲区为零。
     */
    [renderCommandEncoder setVertexBytes:&matrix
                                  length:sizeof(matrix)
                                 atIndex:LYVertexInputIndexMatrix];  // 1
    
    /**
     将缓冲区分配给顶点着色器参数表中的条目。
     - (void)setVertexBuffer:(id<MTLBuffer>)buffer offset：(NSUInteger)offset atIndex:(NSUInteger)index；
     buffer
     该命令分配给缓冲区的顶点着色器参数表中的一个条目的 MTLBuffer 实例。
     offset
     一个整数，表示从顶点着色器参数数据开始的缓冲区起始位置开始的位置（以字节为单位）。
     请参阅 Metal 功能集表 (PDF)，检查设备和常量地址空间中缓冲区的偏移对齐要求。
     index
     一个整数，表示存储缓冲区和偏移记录的缓冲区的顶点着色器参数表中的条目。
     讨论
     默认情况下，每个索引处的缓冲区为零。
     */
    [renderCommandEncoder setVertexBuffer:self.vertices
                                   offset:0
                                  atIndex:LYVertexInputIndexVertices];  // 0
    
    /**
     配置图元（例如三角形）的哪个面是正面。
     - (void)setFrontFacingWinding:(MTLWinding)frontFacingWinding;
     必需的
     参数
     frontFacingWinding
     一个 MTLWinding 值，用于配置渲染管道如何定义基元的哪一侧是其前面。
     讨论
     渲染通道的默认正面模式是 MTLWindingClockwise。
     图元的缠绕方向决定渲染通道是否剔除它（请参阅 setCullMode:）。
     */
    [renderCommandEncoder setFrontFacingWinding:MTLWindingCounterClockwise];
    
    /**
     设置剔除模式：
     配置渲染管道如何确定要删除的图元。
     - (void)setCullMode:(MTLCullMode)cullMode;
     必需的
     参数
     cullMode
     一个 MTLCullMode 值，用于配置渲染管道如何确定要从管道中删除的图元。
     讨论
     此方法根据每个图元的面相对于场景相机的方向配置渲染管道删除哪些图元（如果有）。 例如，您可以正确剔除某些几何模型上的隐藏曲面，例如由填充三角形组成的球体（如果它使用可定向曲面）。 如果表面的基元始终对其顶点使用相同的顺序，则该表面是可定向的。 Metal 使用 MTLWinding 类型定义顶点排序，其中包括 MTLWindingClockwise 和 MTLWindingCounterClockwise。 您可以通过调用 setFrontFacingWinding: 方法来告诉渲染管道您的图元面向哪个方向，该方法会影响剔除模式删除的图元。
     渲染通道的默认剔除模式是 MTLCullModeNone。
     */
    [renderCommandEncoder setCullMode:MTLCullModeBack];
    
    /**
     将纹理分配给片元着色器参数表中的条目。
     - (void)setFragmentTexture:(id<MTLTexture>)texture atIndex:(NSUInteger)index；
     必需的
     参数
     texture
     该命令分配给纹理片段着色器参数表中的条目的 MTLTexture 实例。
     index
     一个整数，表示存储纹理记录的纹理的片段着色器参数表中的条目。
     讨论
     默认情况下，每个索引处的纹理为零。
     */
    [renderCommandEncoder setFragmentTexture:self.texture atIndex:LYFragmentInputIndexTexture]; // 0
    
    /**
     对绘制命令进行编码，该命令渲染具有索引顶点的几何基元的实例。
     - (void)drawIndexedPrimitives:(MTLPrimitiveType)primitiveType
                    indexCount:(NSUInteger)indexCount
                    indexType:(MTLIndexType)indexType
                    indexBuffer:(id<MTLBuffer>)indexBuffer
                    indexBufferOffset:(NSUInteger)indexBufferOffset;
     必需的
     参数
     primitiveType
     一个 MTLPrimitiveType 实例，表示命令如何解释顶点参数数据。
     有关在顶点着色器参数表中设置缓冲区条目的更多信息，请参阅 setVertexBuffer:offset:atIndex: 方法及其同级方法。
     indexCount
     一个整数，表示命令从 indexBuffer 读取的顶点数。
     indexType
     表示索引格式的 MTLIndexType 实例，包括 MTLIndexTypeUInt16 和 MTLIndexTypeUInt32。
     indexBuffer
     包含indexType格式的indexCount个顶点索引的MTLBuffer实例。
     indexBufferOffset
     一个整数，表示距离 indexBuffer 顶点索引开始处 4 字节倍数的位置。
     讨论
     您可以通过传递一个哨兵索引值来完成一个原语并开始一个新的原语，该索引值是indexType可能的最大无符号整数。 例如，MTLIndexTypeUInt16 和 MTLIndexTypeUInt32 的最大无符号整数分别是 0xFFFF 和 0xFFFFFFFF。 该命令完成当前基元，并在每次读取哨兵索引值时开始绘制新基元。
     该方法记录编码器的当前渲染状态以及命令运行时所需的资源。 调用此方法后，您可以安全地更改编码器的渲染管道状态以编码其他命令。 状态的后续更改不会影响编码器 MTLCommandBuffer 中已有的命令。
     */
    [renderCommandEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                                     indexCount:self.indexCount
                                      indexType:MTLIndexTypeUInt32
                                    indexBuffer:self.indexBuffer
                              indexBufferOffset:0];
}

// 配置渲染命令描述符
- (void)setUpRenderPassDescriptor:(MTLRenderPassDescriptor *)renderPassDescriptor {
    
    [super setUpRenderPassDescriptor:renderPassDescriptor];
}

@end
