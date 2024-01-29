//
//  LJCustomRender.m
//  MetalDemo
//
//  Created by Walg on 2024/1/15.
//

#import "LJBaseRender.h"


@interface LJBaseRender ()

@end

@implementation LJBaseRender

//初始化方法
- (instancetype)initWithMetalKitView:(MTKView *)mtkView superView:(UIView *)superView {
    
    self = [super init];
    if (self) {
        //拿到外界传进来的device
        self.device = mtkView.device;
        self.mtkView = mtkView;
        self.superView = superView;
        self.viewportSize = (vector_uint2){mtkView.drawableSize.width, mtkView.drawableSize.height};
        [self setupCommandQueue];
        [self setUpPineline:mtkView];
        [self initConfig];
    }
    return self;
}

- (void)initConfig {
    
    
}

// 初始化commandQueue
- (void)setupCommandQueue {
    
    self.commandQueue = [self.device newCommandQueue];
}

// 初始化pipelineState
- (void)setUpPineline:(MTKView *)mtkView {
    
    /**
     MTL渲染管线描述符
     传递给 GPU 设备以获取渲染管道状态的选项参数。
     @interface MTLRenderPipelineDescriptor : NSObject
     概述
     MTLRenderPipelineDescriptor 实例配置渲染通道期间使用的状态，包括光栅化（例如多重采样）、可见性、混合、曲面细分和图形函数状态。 使用标准分配和初始化技术创建 MTLRenderPipelineDescriptor 对象。 然后，您配置并使用描述符来创建 MTLRenderPipelineState 对象。
     要在渲染管道描述符中指定顶点或片段函数，请将 vertexFunction 或fragmentFunction 属性分别设置为所需的 MTLFunction 对象。 如果您未将 vertexFunction 属性设置为曲面细分后顶点函数，系统将忽略曲面细分阶段属性。 如果 [[ patch(patch-type, N) ]] 属性位于 Metal Shading Language 源中的函数签名之前，则顶点函数是曲面细分后顶点函数。 有关详细信息，请参阅金属着色语言规范的“后镶嵌顶点函数”部分。
     将fragmentFunction 属性设置为nil 会禁用将像素光栅化到颜色附件中。 此操作通常用于将顶点函数数据输出到缓冲区对象或用于仅深度渲染。
     如果顶点着色器具有带有每个顶点输入属性的参数，请将 vertexDescriptor 属性设置为描述该顶点数据的组织的 MTLVertexDescriptor 对象。
     多重采样和渲染管线
     如果颜色附件支持多重采样（本质上，附件是 MTLTextureType2DMultisample 类型颜色纹理），则可以为每个片段创建多个样本，并且以下渲染管道描述符属性确定覆盖范围：
     SampleCount 是每个像素的样本数。
     如果 alphaToCoverageEnabled 为 YES，则 GPU 使用 colorAttachments 的 alpha 通道片段输出来计算覆盖遮罩，该遮罩会影响 GPU 写入所有附件（颜色、深度和模板）的值。
     如果 alphaToOneEnabled 为 YES，GPU 会将 colorAttachments 的 alpha 通道片段值更改为 1.0，这是最大的可表示值。
     如果 alphaToCoverageEnabled 为 YES，则实现定义的coverageToMask 函数使用来自 colorAttachments 的 alpha 通道片段输出来创建中间覆盖掩码，该掩码将其输出中的位数设置为与浮点输入的值成比例。 例如，如果输入为 0.0f，则该函数将输出设置为 0x0。 如果输入为 1.0f，则该函数设置所有输出位（实际上为 ~0x0）。 如果输入为 0.5f，则根据通常使用抖动模式的实现，该函数会设置一半的位。
     为了确定最终的覆盖遮罩，该函数对生成的覆盖遮罩 alphaCoverageMask 与来自光栅器和片段着色器的遮罩执行逻辑 AND，如以下代码所示：
     清单 1 计算覆盖掩模的伪代码
     if (alphaToCoverageEnabled) 那么
     alphaCoverageMask =coverageToMask(colorAttachment0.alpha);
     最终覆盖掩码 = 原始光栅化覆盖掩码
     & alphaCoverageMask & fragShaderSampleMaskOutput;
     */
//    MTLRenderPipelineDescriptor *pinelineDesc = [MTLRenderPipelineDescriptor new];
//    id <MTLLibrary> library = [self.device newDefaultLibrary];
//    pinelineDesc.vertexFunction = [library newFunctionWithName:@"vertexShader"];
//    pinelineDesc.fragmentFunction = [library newFunctionWithName:@"fragmentShader"];
//    pinelineDesc.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
//    self.pipelineState = [self.device newRenderPipelineStateWithDescriptor:pinelineDesc error:nil];
}

#pragma mark - MTKViewDelegate
// MTKView的大小改变
- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
    
    self.viewportSize = (vector_uint2){size.width, size.height};
}

// 用于向着色器传递数据
- (void)drawInMTKView:(MTKView *)view {
    
    /**
     命令缓冲区
     从命令队列返回命令缓冲区，该缓冲区维护对资源的强引用。
     - (id<MTLCommandBuffer>)commandBuffer;
     必需的
     讨论
     使用此方法创建的命令缓冲区保留对编码到其中的资源的强引用，包括缓冲区、纹理、采样器和管道状态。 命令缓冲区在 GPU 上运行完成后会释放这些引用。
     此方法将其创建的命令缓冲区的retainedReferences 属性设置为YES。
     每个命令队列在其生命周期内都有固定数量的命令缓冲区（请参阅 newCommandQueueWithMaxCommandBufferCount:）。 当队列没有任何空闲命令缓冲区时，此方法会阻塞调用 CPU 线程，并在 GPU 执行完毕后返回。
     */
    id <MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    
    /**
     当前渲染通道描述符
     用于绘制到当前可绘制对象中的渲染通道描述符。
     @property(非原子，只读，可为空) MTLRenderPassDescriptor *currentRenderPassDescriptor;
     讨论
     读取此属性会创建并返回一个新的渲染通道描述符，以渲染到当前可绘制的纹理中。 MTKView 不使用此描述符，并且不要求您的应用程序使用它。
     如果未设置视图的设备属性或者 currentDrawable 为 nil，则此属性为 nil。 您的应用程序应在尝试使用 currentRenderPassDescriptor 之前检查它是否不为零。
     视图按如下方式配置渲染通道：
     如果未启用多重采样 - 渲染通道描述符索引 0 处的颜色附件指向分配给当前可绘制对象的纹理，具有 MTLLoadActionClear 的加载操作和 MTLStoreActionStore 的存储操作。
     如果您已启用多重采样 - 渲染通道描述符索引 0 处的颜色附件指向多重采样纹理，解析纹理指向分配给当前可绘制对象的纹理，并且附件具有 MTLLoadActionClear 的加载操作和存储操作 MTLStoreActionMultisampleResolve 的。
     如果您已指定深度或模板目标 - 渲染通道将使用 MTLLoadActionClear 的加载操作和 MTLStoreActionDontCare 的存储操作配置适当的目标。
     
     MTL渲染通道描述符
     一组保存渲染通道结果的渲染目标。
     概述
     MTLRenderPassDescriptor 对象包含一组附件，用作渲染通道生成的像素的渲染目标。 MTLRenderPassDescriptor 对象还为渲染通道生成的可见性信息设置目标缓冲区。
     重要的
     配置 MTLTextureDescriptor 对象以与附件一起使用时，如果您已经知道打算在附件中使用生成的 MTLTexture 对象，请将其使用值设置为 MTLTextureUsageRenderTarget。 这可能会显着提高应用程序在某些硬件上的性能。
     */
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    
    if (!renderPassDescriptor) {
        [commandBuffer commit];
        return;
    }
    
    [self setUpRenderPassDescriptor:renderPassDescriptor];
    
    /**
     MTL渲染命令编码器
     将渲染通道编码到命令缓冲区的接口，包括其所有绘制调用和配置。
     @协议MTLRenderCommandEncoder
     概述
     MTLRenderCommandEncoder 协议定义了一个配置和编码渲染通道的接口。 使用渲染通道将场景或场景中的组件绘制到其渲染附件（渲染通道的输出）。 您可以使用各种方法来渲染这些输出，包括应用以下内容的技术：
     原始图画
     网格绘制
     光线追踪
     平铺着色器调度
     要创建 MTLRenderCommandEncoder 实例，请调用 MTLCommandBuffer 实例的 renderCommandEncoderWithDescriptor: 或 MTLParallelRenderCommandEncoder 实例的 renderCommandEncoder 方法。
     要为第一个绘图命令配置渲染通道，请从管道状态开始，将 MTLRenderPipelineState 实例传递给编码器的 setRenderPipelineState: 方法。 您通常通过调用一个或多个 MTLDevice 方法提前创建渲染通道所需的管道状态（请参阅管道状态创建）。
     提示
     通过在非关键时间（例如启动期间）创建管道状态来避免视觉卡顿，因为创建它们可能需要时间。
     通过调用“渲染通道配置”页面上的方法来设置编码器配置的任何其他适用部分。 例如，您可能需要配置通道的视口、剪刀矩形以及深度和模板测试的设置。
     为依赖于它们的着色器分配资源，例如缓冲区和纹理。 有关更多信息，请参阅资源准备部分中特定于着色器的页面，例如顶点着色器资源准备命令和片段着色器资源准备命令。 如果您的着色器通过参数缓冲区访问资源，请确保传递通过加载驻留在 GPU 内存中的资源来驻留这些资源。 您可以通过调用“参数缓冲区资源准备命令”页面上的方法来执行此操作。
     配置命令所依赖的状态和资源后，通过调用“渲染通道绘图命令”页面上的方法对绘图命令进行编码。 编码器保持其当前状态并将其应用于所有后续绘制命令。 对于需要不同状态或资源的绘制命令，请适当地重新配置渲染通道，然后对这些绘制命令进行编码。 对依赖于相同渲染通道配置和资源的每批绘图命令重复此过程。
     完成渲染通道命令的编码后，通过调用编码器的 endEncoding 方法将其最终确定到命令缓冲区中。
     */
    id <MTLRenderCommandEncoder> renderCommandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
    
    // 配置MTL渲染命令编码器
    [self setUpRenderCommandEncoder:renderCommandEncoder];
    
    /**
     渲染命令编码器标识结束编码
     声明编码器的所有命令生成已完成。
     调用 endEncoding 后，命令编码器就不再使用。 您不能使用此编码器对任何其他命令进行编码。
     */
    [renderCommandEncoder endEncoding];
    
    /**
     呈现可绘制：
     尽早呈现可绘制对象。
     - (void)presentDrawable:(id<MTLDrawable>)drawable;
     必需的
     参数
     可绘制的
     一个 MTLDrawable 实例，包含系统可以在显示器上显示的纹理。
     讨论
     在命令队列安排命令缓冲区执行后，此便捷方法会调用可绘制对象的 Present 方法。 命令缓冲区通过调用自己的 addScheduledHandler: 方法来添加完成处理程序来完成此操作。
     重要的
     您只能在调用命令缓冲区的 commit 方法之前调用此方法。
     */
    [commandBuffer presentDrawable:view.currentDrawable];
    
    /**
     提交命令缓冲区以在 GPU 上运行。
     -（无效）提交；
     必需的
     讨论
     commit 方法将命令缓冲区发送到拥有它的 MTLCommandQueue 实例，然后安排它在 GPU 上运行。 如果您的应用程序对未排队的命令缓冲区调用 commit，则该方法实际上会为您调用 enqueue。
     commit 方法有几个限制，包括：
     您只能将命令缓冲区提交到其命令队列一次。
     您只能在命令缓冲区没有活动编码器时提交命令缓冲区（请参阅 MTLCommandBuffer 和 MTLCommandEncoder）。
     提交后，您无法将其他命令编码到命令缓冲区。
     提交命令缓冲区后，您无法调用 addScheduledHandler: 或 addCompletedHandler: 方法。
     GPU 在启动同一命令队列中位于其前面的任何命令缓冲区后启动命令缓冲区。
     */
    [commandBuffer commit];
}

// 配置渲染命令描述符
- (void)setUpRenderPassDescriptor:(MTLRenderPassDescriptor *)renderPassDescriptor {
    
    // 设置背景色
    renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.5, 0.5, 0.5, 1);
    renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
}

// 配置MTL渲染命令编码器
- (void)setUpRenderCommandEncoder:(id <MTLRenderCommandEncoder>)renderCommandEncoder {
    
    /**
     设置视口：
     使用应用变换和剪切矩形的视口配置渲染管道。
     渲染管道通过在光栅化阶段应用视口，将顶点位置从标准化设备坐标线性映射到视口坐标。 它首先应用变换，然后光栅化图元，同时剪切剪刀矩形（请参阅 setScissorRect:）或渲染目标范围之外的任何片段。
     视口的 originX 和 originY 属性默认为 0.0，表示距渲染目标左上角的像素数。 正的 originX 值向右移动，正的 originY 值向下移动。 其宽度和高度属性的默认值分别是渲染目标的宽度和高度。 其 znear 和 zfar 属性的默认值分别为 0.0 和 1.0，您可以翻转该值。
     笔记
     您可以通过再次调用此方法或调用 setViewports:count: 方法来更改渲染通道的视口配置。
     */
    [renderCommandEncoder setViewport:(MTLViewport){0, 0, self.viewportSize.x, self.viewportSize.y, -1, 1}];
    
    /**
     设置渲染管道状态：
     使用适用于后续绘制命令的渲染或切片管道状态实例配置编码器。
     - (void)setRenderPipelineState:(id<MTLRenderPipelineState>)pipelineState;
     必需的
     参数
     pipelineState
     通过调用 MTLDevice 方法创建的渲染管道状态实例（请参阅管道状态创建）。
     讨论
     在通过调用此方法对任何绘制或平铺命令进行编码之前设置渲染通道的渲染管道状态，因为默认管道状态为 nil。
     您可以更改编码器在其生命周期内多次使用的管道状态。 例如，您的应用程序可能希望使用顶点着色器渲染某些内容，并使用对象和网格着色器渲染其他内容。 更改管道状态仅影响后续命令，对更改状态之前编码的命令没有影响。
     您传递给此方法的渲染管道需要与渲染通道的附件兼容。 您可以使用 MTLRenderPassDescriptor 实例的属性来配置这些附件，包括 colorAttachments、depthAttachment 和 stencilAttachment。
     */
    [renderCommandEncoder setRenderPipelineState:self.pipelineState];
    // 设置顶点数据
//    [renderCommandEncoder setVertexBuffer:self.vertices offset:0 atIndex:0];
    // 设置纹理数据
//    [renderCommandEncoder setFragmentTexture:self.texture atIndex:0];
    // 开始绘制
//    [renderCommandEncoder drawPrimitives:MTLPrimitiveTypeTriangleStrip vertexStart:0 vertexCount:self.numVertices];
}

@end
