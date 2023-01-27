#import <XCTest/XCTest.h>

@interface FlutterWideGamutPrototypeUITestsLaunchTests : XCTestCase

@end

@implementation FlutterWideGamutPrototypeUITestsLaunchTests

+ (BOOL)runsForEachTargetApplicationUIConfiguration {
  return YES;
}

- (void)setUp {
  self.continueAfterFailure = NO;
}

- (void)testLaunch {
  XCUIApplication *app = [[XCUIApplication alloc] init];
  [app launch];

  XCTAttachment *attachment =
      [XCTAttachment attachmentWithScreenshot:XCUIScreen.mainScreen.screenshot];
  attachment.name = @"Launch Screen";
  attachment.lifetime = XCTAttachmentLifetimeKeepAlways;
  [self addAttachment:attachment];
}

@end
