//
//  LJTextureShader.metal
//  LJMetalDemo
//
//  Created by Walg on 2024/1/17.
//

#include <metal_stdlib>
#import "LJShaderHeader.h"
using namespace metal;

typedef struct {
    float4 vertexPosition [[ position ]];
    float2 textureCoor;
} RasterizerData;

// 顶点着色器
vertex RasterizerData vertexShader(uint vertexId [[ vertex_id ]], constant LJVertex *vertexArray [[ buffer(0) ]]) {
    RasterizerData out;
    out.vertexPosition = vertexArray[vertexId].position;
    out.textureCoor = vertexArray[vertexId].textureCoordinate;
    return out;
}

// 片元着色器
fragment float4 fragmentShader(RasterizerData input [[ stage_in ]], texture2d <float> colorTexture [[ texture(0) ]]) {
    
    constexpr sampler textureSampler (mag_filter::linear, min_filter::linear);
    float4 colorSample = colorTexture.sample(textureSampler, input.textureCoor);
    return float4(colorSample);
}

