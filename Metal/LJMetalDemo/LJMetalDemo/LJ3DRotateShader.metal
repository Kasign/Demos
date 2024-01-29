//
//  LJ3DRotateShader.metal
//  LJMetalDemo
//
//  Created by Walg on 2024/1/17.
//

#include <metal_stdlib>
#import "LJShaderHeader.h"
using namespace metal;

typedef struct
{
    float4 clipSpacePosition [[position]];
    float3 pixelColor;
    float2 textureCoordinate;
} RasterizerData;

// 顶点着色器
vertex RasterizerData vertex3DRotateShader(uint vertexID [[ vertex_id ]], constant LYVertex *vertexArray [[ buffer(LYVertexInputIndexVertices) ]], constant LYMatrix *matrix [[ buffer(LYVertexInputIndexMatrix) ]]) {
    
    RasterizerData out;
    out.clipSpacePosition = matrix->projectionMatrix * matrix->modelViewMatrix * vertexArray[vertexID].position;
    out.textureCoordinate = vertexArray[vertexID].textureCoordinate;
    out.pixelColor = vertexArray[vertexID].color;
    
    return out;
}

// 片元着色器
fragment float4 sampling3DRotateShader(RasterizerData input [[stage_in]], texture2d<half> textureColor [[ texture(LYFragmentInputIndexTexture) ]]) {
    
    constexpr sampler textureSampler(mag_filter::linear, min_filter::linear);
    half4 colorTex = textureColor.sample(textureSampler, input.textureCoordinate);
//    half4 colorTex = half4(input.pixelColor.x, input.pixelColor.y, input.pixelColor.z, 1);
    return float4(colorTex);
}
