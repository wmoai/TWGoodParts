//
//  UIView+TWSupport.h
//

#import <UIKit/UIKit.h>

@interface UIView (TWSupport)

- (void)twViewSetLinearHeight:(int)height;
- (CGFloat)twViewLinearHeight;

- (void)addSubviewLinear:(UIView *)view;
- (void)sizeToFitSubviews;
- (void)heightToFitSubviews __attribute__((deprecated));
- (void)heightToFitSubviewsWithPadding:(CGFloat)padding __attribute__((deprecated));
- (void)setHeight:(CGFloat)height;
- (void)setWidth:(CGFloat)width;
- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setSize:(CGSize)size;
- (void)setPoint:(CGPoint)point;
- (void)addHeight:(CGFloat)height;

@end
