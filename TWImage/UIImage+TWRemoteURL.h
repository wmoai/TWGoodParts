//
//  UIImage+TWRemoteURL.h
//

#import <UIKit/UIKit.h>

@interface UIImage (TWRemoteURL)

+ (void)imageWithURL:(NSURL *)url 
            cacheTag:(NSString *)cacheTag
             completion:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))completion;
+ (void)imageWithURL:(NSURL *)url 
            cacheTag:(NSString *)cacheTag
    placeholderImage:(UIImage *)placeholderImage 
             completion:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))completion;
+ (void)clearCacheWithCapacity:(NSUInteger)capacity cacheTags:(NSArray *)cacheTags;
+ (void)forceClearCache:(NSArray *)cacheTags;

@end
