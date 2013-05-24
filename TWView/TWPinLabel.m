//
//  TWPinLabel.m
//

#import "TWPinLabel.h"

@implementation TWPinLabel

@synthesize fillColor = _fillColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textAlignment = UITextAlignmentCenter;
    }

    return self;
}

- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 3, 3);
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

- (void)drawRect:(CGRect)rect
{
    //[self.fillColor setFill];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    float width = self.bounds.size.width;

    CGContextSetRGBFillColor(ctx, 0.906, 0.271, 0.541, 0.9f);
    CGContextAddArc(ctx, 0, 0, width, -M_PI_4, M_PI, 0);

    CGContextFillPath(ctx);

    [super drawRect:rect];
}

@end
