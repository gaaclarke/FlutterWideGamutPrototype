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
//    NSMutableData *data = [[NSMutableData alloc]
//        initWithLength:image.extent.size.width * image.extent.size.height * 16];
//    const float *inPtr = static_cast<const float *>(temp.bytes);
//    uint64_t *outPtr = static_cast<uint64_t *>(data.mutableBytes);
//
//    // Convert RGBAf to BGRA10_XR.
//    for (int i = 0; i < image.extent.size.height; ++i) {
//      for (int j = 0; j < image.extent.size.width; ++j) {
//        float r = inPtr[0];
//        float g = inPtr[1];
//        float b = inPtr[2];
//        float a = inPtr[3];
//
//        float min = -0.5271f;
//        float max = 1.66894f;
//        uint64_t r16 = static_cast<uint64_t>(
//                           ((r - min) / (max - min)) * 0x3ff)
//                       << 6;
//        uint64_t g16 = static_cast<uint64_t>(
//                           ((g - min) / (max - min)) * 0x3ff)
//                       << 6;
//        uint64_t b16 = static_cast<uint64_t>(
//                           ((b - min) / (max - min)) * 0x3ff)
//                       << 6;
//        uint64_t a16 = static_cast<uint64_t>(
//                           ((a - min) / (max - min)) * 0x3ff)
//                       << 6;
//
//        *outPtr = a16 << 48 | r16 << 32 | g16 << 16 | b16;
//
//        outPtr += 1;
//        inPtr += 4;
//      }
//    }
    _width = image.extent.size.width;
    _height = image.extent.size.height;
    _data = temp;
  }
  return self;
}

@end
