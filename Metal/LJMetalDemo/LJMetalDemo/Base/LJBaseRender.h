//
//  LJCustomRender.h
//  MetalDemo
//
//  Created by Walg on 2024/1/15.
//

#import <Foundation/Foundation.h>
#import <MetalKit/MetalKit.h>
#import "LJShaderHeader.h"

NS_ASSUME_NONNULL_BEGIN

static Byte* LJLoadImage(UIImage *image) {
    
    // 1获取图片的CGImageRef
    CGImageRef spriteImage = image.CGImage;
    // 2 读取图片的大小
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    Byte * spriteData = (Byte *) calloc(width * height * 4, sizeof(Byte)); //rgba共4个byte
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    // 3在CGContextRef上绘图
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    CGContextRelease(spriteContext);
    
    return spriteData;
}

@interface LJBaseRender : NSObject <MTKViewDelegate>

@property (nonatomic, assign) NSUInteger numVertices;

@property (nonatomic, strong) id <MTLTexture> texture;

@property (nonatomic, assign) vector_uint2 viewportSize;

/**
 GPU 的主要 Metal 接口，应用程序使用它来绘制图形并并行运行计算。
 @协议MTLDevice
 概述
 您可以通过调用 MTLCreateSystemDefaultDevice 在运行时获取默认 MTLDevice（请参阅获取默认 GPU）。 每个 Metal 设备实例代表一个 GPU，并且是应用程序与其交互的主要起点。 使用 Metal 设备实例，您可以检查 GPU 的特性和功能（请参阅设备检查）并使用其工厂方法创建辅助类型实例。
 缓冲区、纹理和其他资源在 GPU 和 CPU 之间存储、同步和传递数据（请参阅资源基础知识）。
 输入/输出命令队列有效地从文件系统加载资源（请参阅资源加载）。
 命令队列创建命令编码器并为 GPU 安排工作，包括渲染和计算命令（请参阅渲染通道和计算通道）。
 管道状态存储渲染或计算管道配置（创建成本可能很高），以便您可以重复使用它们，甚至可能多次。
 如果您的应用程序使用多个 GPU（请参阅多 GPU 系统），请确保这些类型的实例仅与同一设备上的其他实例交互。 例如，您的应用程序只能将纹理传递到来自同一 Metal 设备的命令编码器，而不能传递到其他设备。
 */
@property (nonatomic, weak) id <MTLDevice> device;

/**
 MTL渲染管线状态
 表示渲染通道的图形管道配置的接口，该通道应用于您编码的绘制命令。
 概述
 MTLRenderPipelineState 协议是一个接口，表示图形渲染管道的特定配置，包括它使用的着色器。 通过调用 MTLRenderCommandEncoder 实例的 setRenderPipelineState: 方法，使用管道状态实例来配置渲染通道。
 要创建管道状态，请调用适当的 MTLDevice 方法（请参阅管道状态创建）。 您通常在非关键时间创建管道状态实例，例如应用程序首次启动时。 这是因为图形驱动程序可能需要时间来评估和构建每个管道状态。 但是，您可以在应用程序的整个生命周期中快速使用和重用每个管道状态。
 */
@property (nonatomic, strong) id <MTLRenderPipelineState> pipelineState;

/**
 MTL命令队列
 用于创建、提交命令缓冲区并将其调度到特定 GPU 设备以在这些缓冲区中运行命令的实例。
 @协议MTLCommandQueue
 概述
 命令队列维护命令缓冲区的有序列表。 您可以使用命令队列来：
 创建命令缓冲区，用创建队列的 GPU 设备的命令填充该缓冲区
 提交命令缓冲区以在该 GPU 上运行
 通过调用 MTLDevice 实例的 newCommandQueue 或 newCommandQueueWithMaxCommandBufferCount: 方法从 MTLDevice 实例创建命令队列。 通常，您会在应用程序启动时创建一个或多个命令队列，然后在应用程序的整个生命周期中保留它们。
 对于您创建的每个 MTLCommandQueue 实例，您可以通过调用其 commandBuffer 或 commandBufferWithUnretainedReferences 方法为该队列创建 MTLCommandBuffer 实例。
 笔记
 每个命令队列都是线程安全的，允许您同时在多个命令缓冲区中编码命令。
 有关命令缓冲区和对其编码 GPU 命令的更多信息（例如并行渲染图像和计算数据），请参阅设置命令结构。
 */
@property (nonatomic, strong) id <MTLCommandQueue> commandQueue;

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
@property (nonatomic, strong) id <MTLBuffer> vertices;

@property (nonatomic, weak) MTKView *mtkView;

@property (nonatomic, weak) UIView *superView;


/// 初始化
- (instancetype)initWithMetalKitView:(MTKView *)mtkView superView:(UIView *)superView;

/// 初始化
- (void)initConfig;

/// 设置MTL渲染管线状态
- (void)setUpPineline:(MTKView *)mtkView;

/// 配置渲染命令描述符
- (void)setUpRenderPassDescriptor:(MTLRenderPassDescriptor *)renderPassDescriptor;

/// 配置MTL渲染命令编码器
- (void)setUpRenderCommandEncoder:(id <MTLRenderCommandEncoder>)renderCommandEncoder;

@end

NS_ASSUME_NONNULL_END
