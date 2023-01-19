#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

@interface Image : NSObject

- (nullable instancetype)initWithPNGFileAtLocation:(nonnull NSURL *)location;

@property(nonatomic, readonly) NSUInteger width;
@property(nonatomic, readonly) NSUInteger height;
@property(nonatomic, readonly, nonnull) NSData *data;
@property(nonatomic, readonly) MTLPixelFormat pixelFormat;
@property(nonatomic, readonly) NSUInteger pixelWidth;

@end
