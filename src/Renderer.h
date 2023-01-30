@import MetalKit;

@interface Renderer : NSObject <MTKViewDelegate>

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView;
- (void)addCompletionHandler:(nonnull dispatch_block_t)handler;
@end
