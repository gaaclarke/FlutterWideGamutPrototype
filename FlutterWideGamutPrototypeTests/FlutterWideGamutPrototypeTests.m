#import "ViewController.h"
#import <XCTest/XCTest.h>

@interface FlutterWideGamutPrototypeTests : XCTestCase
@end

static float DecodeBGR10(uint32_t x) {
  float max = 1.25098f;
  float min = -0.752941f;
  float intercept = min;
  float slope = (max - min) / 1024.f;
  return (((float)x) * slope) + intercept;
}

static bool Almost(float x, float y) { return fabsf(x - y) < 0.01; }

@implementation FlutterWideGamutPrototypeTests

- (void)setUp {
}

- (void)tearDown {
}

- (void)testExample {
  UIViewController *rootViewController;
      
  if (@available(iOS 13.0, *)) {
    UIWindowScene* windowScene =
        (UIWindowScene*)[[UIApplication sharedApplication].connectedScenes anyObject];
    XCTAssertTrue([windowScene isKindOfClass:[UIWindowScene class]]);
    rootViewController = windowScene.windows[0].rootViewController;
  } else {
    rootViewController = [UIApplication sharedApplication].windows[0].rootViewController;
  }
  
  ViewController *viewController = (ViewController *)rootViewController;
  XCTAssertTrue([viewController isKindOfClass:[ViewController class]]);
  MTKView *view = (MTKView *)viewController.view;
  XCTAssertTrue([view isKindOfClass:[MTKView class]]);

  id<MTLTexture> texture = view.currentDrawable.texture;
  XCTAssertNotNil(texture);
  int bytesPerPixel = 0;
  switch (texture.pixelFormat) {
  case MTLPixelFormatBGR10_XR:
    bytesPerPixel = 4;
    break;
  default:
    NSAssert(false, @"not supported");
  }

  XCTestExpectation *expectation = [self expectationWithDescription:@"foo"];
  [viewController.renderer addCompletionHandler:^{
    uint32_t *bytes =
        (uint32_t *)malloc(texture.width * texture.height * bytesPerPixel);
    [texture getBytes:bytes
          bytesPerRow:texture.width * bytesPerPixel
           fromRegion:MTLRegionMake2D(0, 0, texture.width, texture.height)
          mipmapLevel:0];
    bool foundDeepRed = false;
    for (int i = 0; i < texture.width * texture.height; ++i) {
      float b = DecodeBGR10(bytes[i] & 0x3ff);
      float g = DecodeBGR10((bytes[i] >> 10) & 0x3ff);
      float r = DecodeBGR10((bytes[i] >> 20) & 0x3ff);

      if (Almost(r, 1.0931f) && Almost(g, -0.2268f) &&
          Almost(b, -0.1501f)) {
        foundDeepRed = true;
        break;
      }
    }
    free(bytes);
    XCTAssertTrue(foundDeepRed);
    [expectation fulfill];
  }];

  [self waitForExpectations:@[ expectation ] timeout:20];
}

- (void)testPerformanceExample {
  // This is an example of a performance test case.
  [self measureBlock:^{
      // Put the code you want to measure the time of here.
  }];
}

@end
