#import <Foundation/Foundation.h>

@interface Image : NSObject

- (nullable instancetype)initWithPNGFileAtLocation:(nonnull NSURL *)location;

@property(nonatomic, readonly) NSUInteger width;
@property(nonatomic, readonly) NSUInteger height;
@property(nonatomic, readonly, nonnull) NSData *data;

@end
