#if defined(TARGET_IOS) || defined(TARGET_TVOS)
#import "AppDelegate.h"
#import <Availability.h>
#import <TargetConditionals.h>
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

#if defined(TARGET_IOS) || defined(TARGET_TVOS)

int main(int argc, char *argv[]) {

#if TARGET_OS_SIMULATOR && (!defined(__IPHONE_13_0) || !defined(__TVOS_13_0))
#error No simulator support for Metal API for this SDK version.  Must build for a device
#endif

  @autoreleasepool {
    return UIApplicationMain(argc, argv, nil,
                             NSStringFromClass([AppDelegate class]));
  }
}

#elif defined(TARGET_MACOS)

int main(int argc, const char *argv[]) { return NSApplicationMain(argc, argv); }

#endif
