//
//  UIImage+TWRemoteURL.m
//

#import "UIImage+TWRemoteURL.h"
#import <objc/runtime.h>
#import <sys/types.h>
#import <sys/stat.h>
#import <fts.h>
#import "AFImageRequestOperation.h"
#import "Crypt.h"

static char kAFImageRequestOperationObjectKey;

@interface ImageDownloader : NSObject 
{
    @private
    UIImage *_urlImage;
}
@property (readwrite, nonatomic, retain, setter = af_setImageRequestOperation:) AFImageRequestOperation *af_imageRequestOperation;
@property (readonly) UIImage *urlImage;
+ (NSOperationQueue *)af_sharedImageRequestOperationQueue;
@end

@implementation ImageDownloader
@dynamic af_imageRequestOperation;
@synthesize urlImage = _urlImage;

+ (NSOperationQueue *)af_sharedImageRequestOperationQueue
{
    static NSOperationQueue *_af_imageRequestOperationQueue = nil;
    
    if (!_af_imageRequestOperationQueue) {
        _af_imageRequestOperationQueue = [[NSOperationQueue alloc] init];
        [_af_imageRequestOperationQueue setMaxConcurrentOperationCount:8];
    }
    
    return _af_imageRequestOperationQueue;
}

- (AFHTTPRequestOperation *)af_imageRequestOperation
{
    return (AFHTTPRequestOperation *)objc_getAssociatedObject(self, &kAFImageRequestOperationObjectKey);
}

- (void)af_setImageRequestOperation:(AFImageRequestOperation *)af_imageRequestOperation
{
    objc_setAssociatedObject(self, &kAFImageRequestOperationObjectKey, af_imageRequestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)dataWithURLRequest:(NSURLRequest *)request
                   success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success 
                   failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
                 cacheData:(void (^)(NSURLRequest *request, NSData *data))cacheData
{   
    [self cancelImageRequestOperation];
    
    AFImageRequestOperation *requestOperation = [[AFImageRequestOperation alloc] initWithRequest:request];

    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([request isEqual:[self.af_imageRequestOperation request]]) {
            _urlImage = responseObject;

            if (success) {
                success(operation.request, operation.response, _urlImage);
            }

            if (cacheData) {
                cacheData(operation.request, operation.responseData);
            }

            if (self.af_imageRequestOperation == operation) {
                self.af_imageRequestOperation = nil;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([request isEqual:[self.af_imageRequestOperation request]]) {
            if (failure) {
                failure(operation.request, operation.response, error);
            }

            if (self.af_imageRequestOperation == operation) {
                self.af_imageRequestOperation = nil;
            }
        }
    }];
    
    self.af_imageRequestOperation = requestOperation;
    
    [[[self class] af_sharedImageRequestOperationQueue] addOperation:self.af_imageRequestOperation];
}

- (void)cancelImageRequestOperation {
    [self.af_imageRequestOperation cancel];
    self.af_imageRequestOperation = nil;
}

@end

@interface ImageCache : NSCache
{
    NSString *_cachePath;
}

+ (ImageCache *)sharedImageCache;
- (void)cachedImageForRequest:(NSURLRequest *)request
                     cacheTag:(NSString *)cacheTag
                      success:(void (^)(UIImage *))success
                      failure:(void (^)())failure;
- (void)cacheImage:(NSData *)data
        forRequest:(NSURLRequest *)request 
          cacheTag:(NSString *)cacheTag;

- (void)forceClearCache:(NSArray *)cacheTags;
- (void)clearCacheWithCapacity:(NSUInteger)capacity cacheTags:(NSArray *)cacheTags;

@end

@implementation ImageCache

+ (ImageCache *)sharedImageCache
{
    static ImageCache *_imageCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _imageCache = [[ImageCache alloc] init];
    });
    
    return _imageCache;
}

- (void)forceClearCache:(NSArray *)cacheTags
{
    [self clearCacheWithCapacity:0 cacheTags:cacheTags];
}

- (void)clearCacheWithCapacity:(NSUInteger)capacity cacheTags:(NSArray *)cacheTags
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        char *paths[cacheTags.count];

        NSMutableArray *cachePaths = [NSMutableArray arrayWithCapacity:cacheTags.count];

        int i = 0;
        for (NSString *cacheTag in cacheTags) {
            NSString *cachePath = [[self cachePath] stringByAppendingPathComponent:cacheTag];
            [cachePaths addObject:cachePath];
            paths[i] = (char *)[cachePath cStringUsingEncoding:NSUTF8StringEncoding];
            i++;
        }
        paths[i] = NULL;

        if (capacity == 0 || [self isOverCapacity:capacity paths:paths]) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            for (NSString *cachePath in cachePaths) {
                [fileManager removeItemAtPath:cachePath error:nil];
            }
        }
    });
}

- (BOOL)isOverCapacity:(NSUInteger)capacity paths:(char **)paths
{
    int cacheSize = [self cacheSize:paths];

    if (cacheSize > capacity) {
        return YES;
    }

    return NO;
}

- (int)cacheSize:(char **)paths
{
    int size = 0;
    FTS *fts;
    FTSENT *entry;
    fts = fts_open(paths, 0, NULL);
    while ((entry = fts_read(fts))) {
        if (entry->fts_info & FTS_DP || entry->fts_level == 0) {
            continue;
        }
        if (entry->fts_info & FTS_F) {
            size += entry->fts_statp->st_size;
        }
    }
    fts_close(fts);
    return size;
}

- (void)cachedImageForRequest:(NSURLRequest *)request cacheTag:(NSString *)cacheTag success:(void (^)(UIImage *))success failure:(void (^)())failure
{
    switch ([request cachePolicy]) {
        case NSURLRequestReloadIgnoringCacheData:
        case NSURLRequestReloadIgnoringLocalAndRemoteCacheData:
            failure();
            return;
        default:
            break;
    }
    
    [self cachedImage:request cacheTag:cacheTag success:success failure:failure];
}

- (void)cacheImage:(NSData *)data forRequest:(NSURLRequest *)request cacheTag:(NSString *)cacheTag
{
    if (data && request) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *key = [self imageCacheKeyFromURLRequest:request];
            NSString *path = [self imageCachePathFromKey:key cacheTag:cacheTag];

            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            if (![fileManager fileExistsAtPath:path]) {
                [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSString *filePath = [path stringByAppendingPathComponent:key];

            [fileManager createFileAtPath:filePath contents:data attributes:nil];
        });
    }
}

- (void)cachedImage:(NSURLRequest *)request cacheTag:(NSString *)cacheTag success:(void (^)(UIImage *))success failure:(void (^)())failure
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *key = [self imageCacheKeyFromURLRequest:request];
        NSString *path = [self imageCachePathFromKey:key cacheTag:cacheTag];
        NSString *filePath = [path stringByAppendingPathComponent:key];

        UIImage *image;
        if ([fileManager fileExistsAtPath:filePath]) {
            NSData *cachedData = [[NSData alloc] initWithContentsOfFile:filePath];
            UIImage *cachedImage = [[UIImage alloc] initWithData:cachedData];
            UIGraphicsBeginImageContext(cachedImage.size);
            [cachedImage drawInRect:CGRectMake(0, 0, cachedImage.size.width, cachedImage.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            if (image) {
                success(image);
            } else {
                failure();
            }
        });

    });
}

- (NSString *)imageCacheKeyFromURLRequest:(NSURLRequest *)request
{
    NSString *url = [[request URL] absoluteString];
    NSString *key = [NSString stringWithFormat:@"%@", [Crypt md5Str:url]];

    return key;
}

- (NSString *)imageCachePathFromKey:(NSString *)key cacheTag:(NSString *)cacheTag
{
    NSString *cachePath = [[self cachePath] stringByAppendingPathComponent:cacheTag];
    cachePath = [cachePath stringByAppendingPathComponent:[key substringToIndex:2]];
    return cachePath;
}

- (NSString *)cachePath
{
    if (!_cachePath) {
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                            NSUserDomainMask, YES);
        _cachePath = [NSString stringWithFormat:@"%@/%@", [path objectAtIndex:0], @"ImageCaches"];;
    }
    return _cachePath;
}

@end

@implementation UIImage (TWRemoteURL)

+ (void)clearCacheWithCapacity:(NSUInteger)capacity cacheTags:(NSArray *)cacheTags
{
    [[ImageCache sharedImageCache] clearCacheWithCapacity:capacity cacheTags:cacheTags];
}

+ (void)forceClearCache:(NSArray *)cacheTags
{
    [[ImageCache sharedImageCache] forceClearCache:cacheTags];
}

+ (void)imageWithURL:(NSURL *)url 
            cacheTag:(NSString *)cacheTag
             completion:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))completion;
{
    [self imageWithURL:url cacheTag:cacheTag placeholderImage:nil completion:completion];
}

+ (void)imageWithURL:(NSURL *)url 
            cacheTag:(NSString *)cacheTag
         placeholderImage:(UIImage *)placeholderImage 
                  completion:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))completion;
{
    if (!url) {
        completion(nil, nil, placeholderImage);
    } else {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:30.0];
        [request setHTTPShouldHandleCookies:NO];
        [request setHTTPShouldUsePipelining:YES];
        
        [self imageWithURLRequest:request cacheTag:cacheTag placeholderImage:placeholderImage completion:completion];
    }
}

+ (void)imageWithURLRequest:(NSURLRequest *)request 
                   cacheTag:(NSString *)cacheTag
           placeholderImage:(UIImage *)placeholderImage 
                 completion:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))completion;
{
    [[ImageCache sharedImageCache] cachedImageForRequest:request
                                                cacheTag:cacheTag
                                                 success:^(UIImage *cachedImage) {
                                                     //dispatch_queue_t queue = dispatch_get_current_queue();
                                                     //NSLog(@"block_thread %@", queue);
                                                     completion(request, nil, cachedImage);
                                                 } failure:^{
                                                     UIImage *cachedImage = placeholderImage;

                                                     ImageDownloader *downloader = [[ImageDownloader alloc] init];
                                                     [downloader dataWithURLRequest:request
                                                                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                completion(request, response, image);
                                                                            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                completion(request, response, cachedImage);
                                                                            } cacheData:^(NSURLRequest *request, NSData *data) {
                                                                                [[ImageCache sharedImageCache] cacheImage:data  forRequest:request cacheTag:cacheTag];
                                                                            }];
                                                 }];
}

@end