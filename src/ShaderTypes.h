#pragma once

#include <simd/simd.h>

typedef enum VertexInputIndex {
  VertexInputIndexVertices = 0,
  VertexInputIndexViewportSize = 1,
} VertexInputIndex;

typedef enum TextureIndex {
  TextureIndexBaseColor = 0,
} TextureIndex;

typedef struct {
  vector_float2 position;
  vector_float2 textureCoordinate;
} Vertex;
