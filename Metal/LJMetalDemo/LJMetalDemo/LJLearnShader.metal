//
//  LJLearnShader.metal
//  LJMetalDemo
//
//  Created by Walg on 2024/3/13.
//

#include <metal_stdlib>
#import "LJShaderHeader.h"
using namespace metal;

typedef struct
{
    float4 clipSpacePosition [[position]];
    float3 pixelColor;
} RasterizerData;

// 顶点着色器
vertex RasterizerData vertexLearnShader(uint vertexID [[ vertex_id ]], constant vector_float4 *vertexArray [[ buffer(0) ]]) {
    
    RasterizerData out;
    out.clipSpacePosition = vertexArray[vertexID];
    return out;
}

// 片元着色器
fragment float4 fragmentLearnShader(RasterizerData input [[stage_in]]) {
    
//    half4 colorTex = half4(input.pixelColor.r, input.pixelColor.g, input.pixelColor.b, 1);
    half4 colorTex = half4(0, 0, 1, 1);
    return float4(colorTex);
}

