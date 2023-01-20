#import "ViewController.h"
#import "Renderer.h"

@implementation ViewController {
  MTKView *_view;

  Renderer *_renderer;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _view = (MTKView *)self.view;

  // Notice that here we are setting the rendering surface to a pixel
  // format that represents more than 2^24 colors.
  _view.colorPixelFormat = MTLPixelFormatBGR10_XR;
  CGColorSpaceRef srgb =
      CGColorSpaceCreateWithName(kCGColorSpaceExtendedSRGB);
  CAMetalLayer *layer = (CAMetalLayer *)_view.layer;
  layer.colorspace = srgb;
  CFRelease(srgb);

  _view.device = MTLCreateSystemDefaultDevice();

  NSAssert(_view.device, @"Metal is not supported on this device");

  _renderer = [[Renderer alloc] initWithMetalKitView:_view];

  NSAssert(_renderer, @"Renderer failed initialization");

  [_renderer mtkView:_view drawableSizeWillChange:_view.drawableSize];

  _view.delegate = _renderer;
}

@end
