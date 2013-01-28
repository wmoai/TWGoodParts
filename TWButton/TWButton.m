//
//  TWButton.m
//

#import "TWButton.h"

@implementation TWButton
{
    CAGradientLayer *_gradientLayer;
    CALayer *_highlightLayer;
}

+ (id)buttonWithGradient:(CGRect)frame
{
    TWButton *button = [self buttonWithCornerRadius:frame];
    [button setBorder];
    [button setGradient];
    return button;
}

+ (id)buttonWithGradient:(CGRect)frame topColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor
{
    TWButton *button = [self buttonWithCornerRadius:frame];
    [button setBorder];
    [button setGradient:topColor bottomColor:bottomColor];
    return button;
}

+ (id)buttonWithCornerRadius:(CGRect)frame
{
    TWButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button setOptionsWithCornerRadius:frame];

    return button;
}

+ (id)buttonWithColor:(CGRect)frame color:(UIColor *)color
{
    TWButton *button = [self buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    [button setOptionsWithCornerRadius:frame];

    return button;
}

- (void)setOptionsWithCornerRadius:(CGRect)frame
{
    self.frame = frame;
    if (!_highlightLayer) {
        _highlightLayer = [CALayer layer];
        _highlightLayer.frame = self.layer.bounds;
        _highlightLayer.backgroundColor = [[UIColor clearColor] CGColor];
        _highlightLayer.hidden = YES;
        _highlightLayer.speed = 2.0;
        _highlightLayer.zPosition = 1;
        [self.layer addSublayer:_highlightLayer];
    }
    [self setHighlightColorBlack];
    [self setCornerRadius];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _highlightLayer.frame = self.layer.bounds;
    _gradientLayer.frame = self.layer.bounds;
}

- (void)setBorder
{
    [self setBorderWidth:0.5f];
    [self setBorderColor:[UIColor lightGrayColor]];
}

- (void)setBorderWidth:(CGFloat)width
{
    self.layer.borderWidth = width;
}

- (void)setBorderColor:(UIColor *)color
{
    self.layer.borderColor = [color CGColor];
}

- (void)setCornerRadius
{
    [self setCornerRadius:3.0f];
}

- (void)setCornerRadius:(CGFloat)radius
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
}

- (void)setGradient
{
    UIColor *topColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
    UIColor *bottomColor = [UIColor colorWithWhite:0.8f alpha:0.9f];

    [self setGradient:topColor bottomColor:bottomColor];
}

- (void)setGradient:(UIColor *)topColor bottomColor:(UIColor *)bottomColor
{
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.layer.bounds;
        _gradientLayer.zPosition = -1;
        if (self.layer.cornerRadius) {
            _gradientLayer.cornerRadius = self.layer.cornerRadius;
        }
        [self.layer insertSublayer:_gradientLayer atIndex:0];
    }

    _gradientLayer.colors = [NSArray arrayWithObjects:
                             (id)topColor.CGColor,
                             (id)bottomColor.CGColor,
                             nil];
    _gradientLayer.locations = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:0.0f],
                                [NSNumber numberWithFloat:1.0f],
                                nil];
}

- (void)setHighlightColorWhite
{
    _highlightLayer.backgroundColor = [[UIColor colorWithWhite:1.0f alpha:0.2f] CGColor];
}

- (void)setHighlightColorBlack
{
    _highlightLayer.backgroundColor = [[UIColor colorWithWhite:0.0f alpha:0.2f] CGColor];
}

- (void)setHighlightColorNone
{
    _highlightLayer.backgroundColor = [[UIColor clearColor] CGColor];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];

    _highlightLayer.hidden = !highlighted;
}

@end
