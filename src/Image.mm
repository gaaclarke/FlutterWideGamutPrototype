#import "Image.h"
#import <CoreImage/CoreImage.h>
#include <simd/simd.h>

@implementation Image

- (NSUInteger)pixelWidth {
  return 8;
}

- (MTLPixelFormat)pixelFormat {
  return MTLPixelFormatRGBA16Float;
}

- (nullable instancetype)initWithPNGFileAtLocation:(nonnull NSURL *)location {
  self = [super init];
  if (self) {
    CIImage *image = [CIImage imageWithContentsOfURL:location];
    CIContext *context = [[CIContext alloc] init];
    CGColorSpaceRef rgb =
        CGColorSpaceCreateWithName(kCGColorSpaceExtendedSRGB);
    NSMutableData *temp = [[NSMutableData alloc]
        initWithLength:image.extent.size.width * image.extent.size.height * 8];
    [context render:image
           toBitmap:temp.mutableBytes
           rowBytes:image.extent.size.width * 8
             bounds:CGRectMake(0, 0, image.extent.size.width,
                               image.extent.size.height)
             format:kCIFormatRGBAh
         colorSpace:rgb];
    CFRelease(rgb);

    // TODO: Investigate using MTLPixelFormatBGR10_XR_sRGB with an optional MTLPixelFormatA8Unorm.
    
    _width = image.extent.size.width;
    _height = image.extent.size.height;
    _data = temp;
  }
  return self;
}

@end
