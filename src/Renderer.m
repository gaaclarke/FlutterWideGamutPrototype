@import simd;
@import MetalKit;

#import "Renderer.h"
#import "Image.h"
#import "ShaderTypes.h"

@implementation Renderer {
  id<MTLDevice> _device;
  id<MTLRenderPipelineState> _pipelineState;
  id<MTLCommandQueue> _commandQueue;
  id<MTLTexture> _texture;
  id<MTLBuffer> _vertices;
  NSUInteger _numVertices;
  vector_uint2 _viewportSize;
  NSMutableArray* _completionHandlers;
}

- (id<MTLTexture>)loadTextureUsingImage:(NSURL *)url {
  Image *image = [[Image alloc] initWithPNGFileAtLocation:url];

  NSAssert(image, @"Failed to create the image from %@", url.absoluteString);

  MTLTextureDescriptor *textureDescriptor = [MTLTextureDescriptor
      texture2DDescriptorWithPixelFormat:image.pixelFormat
                                   width:image.width
                                  height:image.height
                               mipmapped:NO];

  id<MTLTexture> texture = [_device newTextureWithDescriptor:textureDescriptor];

  NSUInteger bytesPerRow = image.pixelWidth * image.width;

  MTLRegion region = {
      {0, 0, 0},                     // MTLOrigin
      {image.width, image.height, 1} // MTLSize
  };

  [texture replaceRegion:region
             mipmapLevel:0
               withBytes:image.data.bytes
             bytesPerRow:bytesPerRow];
  return texture;
}

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView {
  self = [super init];
  if (self) {
    _device = mtkView.device;

    BOOL supportsBGRA10 =
        UIScreen.mainScreen.traitCollection.displayGamut == UIDisplayGamutP3;
    NSAssert(supportsBGRA10, @"The sample needs a device with BGRA10 support.");

    NSURL *imageFileLocation =
        [[NSBundle mainBundle] URLForResource:@"logo"
                                withExtension:@"png"];

    _texture = [self loadTextureUsingImage:imageFileLocation];

    static const Vertex quadVertices[] = {
        {{250, -250}, {1.f, 1.f}}, {{-250, -250}, {0.f, 1.f}},
        {{-250, 250}, {0.f, 0.f}},

        {{250, -250}, {1.f, 1.f}}, {{-250, 250}, {0.f, 0.f}},
        {{250, 250}, {1.f, 0.f}},
    };

    _vertices = [_device newBufferWithBytes:quadVertices
                                     length:sizeof(quadVertices)
                                    options:MTLResourceStorageModeShared];

    _numVertices = sizeof(quadVertices) / sizeof(Vertex);

    id<MTLLibrary> defaultLibrary = [_device newDefaultLibrary];
    id<MTLFunction> vertexFunction =
        [defaultLibrary newFunctionWithName:@"vertexShader"];
    id<MTLFunction> fragmentFunction =
        [defaultLibrary newFunctionWithName:@"samplingShader"];

    MTLRenderPipelineDescriptor *pipelineStateDescriptor =
        [[MTLRenderPipelineDescriptor alloc] init];
    pipelineStateDescriptor.label = @"Texturing Pipeline";
    pipelineStateDescriptor.vertexFunction = vertexFunction;
    pipelineStateDescriptor.fragmentFunction = fragmentFunction;
    pipelineStateDescriptor.colorAttachments[0].pixelFormat =
        mtkView.colorPixelFormat;

    NSError *error = NULL;
    _pipelineState =
        [_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor
                                                error:&error];

    NSAssert(_pipelineState, @"Failed to create pipeline state: %@", error);

    _commandQueue = [_device newCommandQueue];
    
    _completionHandlers = [[NSMutableArray alloc] init];
  }

  return self;
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
  _viewportSize.x = size.width;
  _viewportSize.y = size.height;
}

- (void)drawInMTKView:(nonnull MTKView *)view {
  id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
  commandBuffer.label = @"MyCommand";

  MTLRenderPassDescriptor *renderPassDescriptor =
      view.currentRenderPassDescriptor;

  if (renderPassDescriptor != nil) {
    id<MTLRenderCommandEncoder> renderEncoder =
        [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
    renderEncoder.label = @"MyRenderEncoder";

    [renderEncoder setViewport:(MTLViewport){0.0, 0.0, _viewportSize.x,
                                             _viewportSize.y, -1.0, 1.0}];

    [renderEncoder setRenderPipelineState:_pipelineState];

    [renderEncoder setVertexBuffer:_vertices
                            offset:0
                           atIndex:VertexInputIndexVertices];

    [renderEncoder setVertexBytes:&_viewportSize
                           length:sizeof(_viewportSize)
                          atIndex:VertexInputIndexViewportSize];

    [renderEncoder setFragmentTexture:_texture atIndex:TextureIndexBaseColor];

    [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
                      vertexStart:0
                      vertexCount:_numVertices];

    [renderEncoder endEncoding];

    [commandBuffer presentDrawable:view.currentDrawable];
    for (dispatch_block_t handler in _completionHandlers) {
      [commandBuffer addCompletedHandler:^(id<MTLCommandBuffer> _Nonnull x) {
        handler();
      }];
    }
    [_completionHandlers removeAllObjects];
  }

  [commandBuffer commit];
}

- (void)addCompletionHandler:(dispatch_block_t)handler {
  [_completionHandlers addObject:handler];
}

@end
