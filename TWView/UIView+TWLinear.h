//
//  UIView+TWLinear.h
//

@interface UIView (TWLinear)

- (void)twViewSetHeight:(int)height;
- (int)twViewHeight;

- (void)addSubviewLinear:(UIView *)view;
- (void)sizeToFitLinear;
- (void)sizeToFitLinearWithPaddingBottom:(NSInteger)padding;

@end
