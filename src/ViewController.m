#import "ViewController.h"
#import "Renderer.h"

@implementation ViewController {
  MTKView *_view;

  Renderer *_renderer;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _view = (MTKView *)self.view;

  _view.colorPixelFormat = MTLPixelFormatBGR10_XR;
  CGColorSpaceRef linearRgb =
      CGColorSpaceCreateWithName(kCGColorSpaceGenericRGBLinear);
  CAMetalLayer *layer = (CAMetalLayer *)_view.layer;
  layer.colorspace = linearRgb;
  CFRelease(linearRgb);

  _view.device = MTLCreateSystemDefaultDevice();

  NSAssert(_view.device, @"Metal is not supported on this device");

  _renderer = [[Renderer alloc] initWithMetalKitView:_view];

  NSAssert(_renderer, @"Renderer failed initialization");

  [_renderer mtkView:_view drawableSizeWillChange:_view.drawableSize];

  _view.delegate = _renderer;
}

@end
