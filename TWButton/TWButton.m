//
//  TWButton.m
//

#import "TWButton.h"

@implementation TWButton

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
    [button setDefaultOptions:frame];

    return button;
}

+ (NSString *)highlightLayerName
{
    return @"highlight";
}

+ (NSString *)gradientLayerName
{
    return @"gradient";
}

- (void)setOptionsWithCornerRadius:(CGRect)frame
{
    [self setDefaultOptions:frame];
    [self setCornerRadius];
}

- (void)setDefaultOptions:(CGRect)frame
{
    self.frame = frame;
    if (![self highlightLayer]) {
        CALayer *highlightLayer = [CALayer layer];
        highlightLayer.frame = self.layer.bounds;
        highlightLayer.backgroundColor = [[UIColor clearColor] CGColor];
        highlightLayer.hidden = YES;
        highlightLayer.speed = 2.0;
        highlightLayer.zPosition = 1;
        highlightLayer.name = [[self class] highlightLayerName];
        [self.layer addSublayer:highlightLayer];
    }
    [self setHighlightColorBlack];
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
    UIColor *bottomColor = [UIColor colorWithWhite:0.7f alpha:0.9f];
    [self setGradient:topColor bottomColor:bottomColor];
}

- (void)setGradient:(UIColor *)topColor bottomColor:(UIColor *)bottomColor
{
    CAGradientLayer *gradientLayer;
    NSString *gradientLayerName = [[self class] gradientLayerName];

    for (CALayer *layer in self.layer.sublayers) {
        if ([layer.name isEqualToString:gradientLayerName]) {
            gradientLayer = (CAGradientLayer *)layer;
            break;
        }
    }

    if (!gradientLayer) {
        gradientLayer = [CAGradientLayer layer];
        gradientLayer.name = [[self class] gradientLayerName];
        gradientLayer.frame = self.layer.bounds;
        if (self.layer.cornerRadius) {
            gradientLayer.cornerRadius = self.layer.cornerRadius;
        }
        [self.layer insertSublayer:gradientLayer atIndex:0];
    }

    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)topColor.CGColor,
                            (id)bottomColor.CGColor,
                            nil];
    gradientLayer.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.0f],
                               [NSNumber numberWithFloat:1.0f],
                               nil];
}

- (CALayer *)highlightLayer
{
    CALayer *highlightLayer = nil;
    NSString *highlightLayerName = [[self class] highlightLayerName];
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer.name isEqualToString:highlightLayerName]) {
            highlightLayer = layer;
            break;
        }
    }
    return  highlightLayer;
}

- (void)setHighlightColorWhite
{
    CALayer *layer = [self highlightLayer];
    layer.backgroundColor = [[UIColor colorWithWhite:1.0f alpha:0.2f] CGColor];
}

- (void)setHighlightColorBlack
{
    CALayer *layer = [self highlightLayer];
    layer.backgroundColor = [[UIColor colorWithWhite:0.0f alpha:0.2f] CGColor];
}

- (void)setHighlightColorNone
{
    CALayer *layer = [self highlightLayer];
    layer.backgroundColor = [[UIColor clearColor] CGColor];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];

    CALayer *layer = [self highlightLayer];
    layer.hidden = !highlighted;
}

@end
