//
//  UIView+TWLinear.h
//

@interface UIView (TWLinear)

- (void)setHeight:(int)height;
- (int)height;

- (void)addSubviewLinear:(UIView *)view;
- (void)sizeToFitLinear;
- (void)sizeToFitLinearWithPaddingBottom:(NSInteger)padding;

@end
