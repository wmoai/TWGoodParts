//
//  UIView+TWSupport.m
//

#import "UIView+TWSupport.h"
#import <objc/runtime.h>

static char *kTWViewKey;
@implementation UIView (TWSupport)

- (void)sizeToFitSubviews {
    CGRect subFrame = CGRectZero;
    for (UIView *v in [self subviews]) {
        subFrame = CGRectUnion(subFrame, v.frame);
    }
    CGRect frame = self.frame;
    if (frame.size.width < subFrame.size.width) {
        frame.size.width = subFrame.size.width;
    }
    frame.size.height = subFrame.size.height;
    self.frame = frame;
}

- (void)heightToFitSubviews {
    CGRect subFrame = CGRectZero;
    for (UIView *v in [self subviews]) {
        subFrame = CGRectUnion(subFrame, v.frame);
    }
    CGRect frame = self.frame;
    frame.size.height = subFrame.size.height;
    self.frame = frame;
}
- (void)heightToFitSubviewsWithPadding:(CGFloat)padding {
    [self heightToFitSubviews];
    CGRect frame = self.frame;
    frame.size.height += padding;
    self.frame = frame;
}

-(void)twViewSetLinearHeight:(int)height {
    objc_setAssociatedObject(self, &kTWViewKey, [NSNumber numberWithInt:height], OBJC_ASSOCIATION_RETAIN);
}
-(CGFloat)twViewLinearHeight {
    NSNumber *num = (NSNumber*)objc_getAssociatedObject(self, &kTWViewKey);
    if (!num) {
        return 0.0f;
    }
    return num.floatValue;
}
-(void)addSubviewLinear:(UIView *)view {
    int height = [self twViewLinearHeight];
    CGRect r = view.frame;
    r.origin.y = height + view.frame.origin.y;
    height += view.frame.origin.y + view.frame.size.height;
    view.frame = r;
    [self addSubview:view];
    [self twViewSetLinearHeight:height];
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size.width = size.width;
    frame.size.height = size.height;
    self.frame = frame;
}
- (void)setPoint:(CGPoint)point {
    CGRect frame = self.frame;
    frame.origin.x = point.x;
    frame.origin.y = point.y;
    self.frame = frame;
}
- (void)addHeight:(CGFloat)height {
    [self setHeight:self.frame.size.height + height];
}

- (void)drawLinearGradient:(CGContextRef)context rect:(CGRect)rect startColor:(CGColorRef)startColor endColor:(CGColorRef)endColor vertical:(BOOL)vertical
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };

    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];

    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);

    CGPoint startPoint;
    CGPoint endPoint;
    if (vertical) {
        startPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect));
        endPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));
    } else {
        startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
        endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    }

    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);

    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

@end
