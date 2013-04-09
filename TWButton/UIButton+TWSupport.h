//
//  UIButton+TWSupport.h
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIButton (TWSupport)

+ (id)buttonWithGradient:(CGRect)frame;
+ (id)buttonWithGradient:(CGRect)frame topColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor;
+ (id)buttonWithCornerRadius:(CGRect)frame;
- (void)setTypeWithCornerRadius:(CGRect)frame;
- (void)setGradient;
- (void)setGradient:(UIColor *)topColor bottomColor:(UIColor *)bottomColor;
- (void)setBorder;
- (void)setBorderWidth:(CGFloat)width;
- (void)setBorderColor:(UIColor *)color;
- (void)setCornerRadius;
- (void)setCornerRadius:(CGFloat)radius;
- (void)setHighlightFilter;
- (void)setHighlightColorWhite;
- (void)setHighlightColorBlack;
- (void)setHighlightColorNone;

@end
