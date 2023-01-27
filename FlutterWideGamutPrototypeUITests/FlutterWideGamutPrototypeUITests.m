#import <CoreGraphics/CoreGraphics.h>
#import <XCTest/XCTest.h>

@interface FlutterWideGamutPrototypeUITests : XCTestCase

@end

@implementation FlutterWideGamutPrototypeUITests

- (void)setUp {
  self.continueAfterFailure = NO;
}

- (void)tearDown {
}

- (void)testExample {
  XCUIApplication *app = [[XCUIApplication alloc] init];
  [app launch];

  sleep(10);

  XCUIScreenshot *screenshot = [app screenshot];

  // Note: Looking at this screenshot in xcode, it can be seen that the
  // screenshot is in sRGB values, so it is not possible to verify wide gamut
  // support this way.
  XCTAttachment *screenshotAttachment =
      [XCTAttachment attachmentWithImage:screenshot.image];
  screenshotAttachment.name = @"screenshot";
  screenshotAttachment.lifetime = XCTAttachmentLifetimeKeepAlways;
  [self addAttachment:screenshotAttachment];
}

- (void)testLaunchPerformance {
  if (@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *)) {
    [self measureWithMetrics:@[ [[XCTApplicationLaunchMetric alloc] init] ]
                       block:^{
                         [[[XCUIApplication alloc] init] launch];
                       }];
  }
}

@end
