//
//  UIImage+TWSupport.h
//

#import <UIKit/UIKit.h>

@interface UIImage (TWSupport)

+ (void)scaleAspectFillWithCenterCropping:(UIImage *)image size:(CGSize)size completion:(void(^)(UIImage *))completion;

@end
