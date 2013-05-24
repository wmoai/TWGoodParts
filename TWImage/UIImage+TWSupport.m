//
//  UIImage+TWSupport.m
//

#import "UIImage+TWSupport.h"

@implementation UIImage (TWSupport)

+ (void)scaleAspectFillWithCenterCropping:(UIImage *)image size:(CGSize)size completion:(void(^)(UIImage *))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        CIImage *ciImage = [[CIImage alloc] initWithImage:image];

        CGFloat screenScale = [UIScreen mainScreen].scale;

        // resize with fill
        CGFloat scale = image.size.width < image.size.height ? size.width * screenScale / image.size.width : size.height * screenScale / image.size.height;
        CIImage *scaledCiImage = [ciImage imageByApplyingTransform:CGAffineTransformMakeScale(scale, scale)];

        // crop with center
        CGSize croppingSize = CGSizeMake(size.width * screenScale, size.height * screenScale);
        CGPoint origin = CGPointMake((image.size.width * scale - croppingSize.width) / 2, (image.size.height * scale - croppingSize.height) / 2);

        CIImage *croppedImage = [scaledCiImage imageByCroppingToRect:CGRectMake(origin.x, origin.y, croppingSize.width, croppingSize.height)];

        UIImage *newImage = [self uiImageFromCIImage:croppedImage scale:screenScale];

        dispatch_async(dispatch_get_main_queue(), ^{
            completion(newImage);
        });
    });
}

+ (UIImage*)uiImageFromCIImage:(CIImage*)ciImage scale:(CGFloat)scale
{
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:kCIContextUseSoftwareRenderer];
    CIContext *ciContext = [CIContext contextWithOptions:options];
    CGImageRef imgRef = [ciContext createCGImage:ciImage fromRect:[ciImage extent]];
    UIImage *newImg  = [UIImage imageWithCGImage:imgRef scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(imgRef);
    return newImg;

    /* iOS6.0以降だと以下が使用可能 */
    //  [[UIImage alloc] initWithCIImage:ciImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
}
@end
