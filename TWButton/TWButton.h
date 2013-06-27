//
//  TWButton.h
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface TWButton : UIButton

+ (id)buttonWithGradient:(CGRect)frame;
+ (id)buttonWithGradient:(CGRect)frame topColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor;
+ (id)buttonWithCornerRadius:(CGRect)frame;
+ (id)buttonWithColor:(CGRect)frame color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;
+ (id)buttonWithColor:(CGRect)frame color:(UIColor *)color;
- (void)setFrame:(CGRect)frame;
- (void)setGradient;
- (void)setGradient:(UIColor *)topColor bottomColor:(UIColor *)bottomColor;
- (void)setBorder;
- (void)setBorderWidth:(CGFloat)width;
- (void)setBorderColor:(UIColor *)color;
- (void)setCornerRadius;
- (void)setCornerRadius:(CGFloat)radius;
- (void)setHighlightColorWhite;
- (void)setHighlightColorBlack;
- (void)setHighlightColorNone;
- (void)setMaxSize:(CGSize)size;
- (void)widthToFit;
- (void)setGradientBorder:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;

@end