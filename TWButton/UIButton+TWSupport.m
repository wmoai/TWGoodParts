//
//  UIButton+TWSupport.m
//

#import "UIButton+TWSupport.h"

@implementation UIButton (TWSupport)

+ (id)buttonWithGradient:(CGRect)frame
{
    UIButton *button = [self buttonWithCornerRadius:frame];
    [button setBorder];
    [button setGradient];
    return button;
}

+ (id)buttonWithGradient:(CGRect)frame topColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor
{
    UIButton *button = [self buttonWithCornerRadius:frame];
    [button setBorder];
    [button setGradient:topColor bottomColor:bottomColor];
    return button;
}

+ (id)buttonWithCornerRadius:(CGRect)frame
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTypeWithCornerRadius:frame];
    
    return button;
}

+ (NSString *)highlightLayerName
{
    return @"highlight";
}

- (void)setTypeWithCornerRadius:(CGRect)frame
{
    self.frame = frame;
    [self setHighlightFilter];
    [self setCornerRadius];
    [self setHighlightColorBlack];
}
- (void)setHighlightFilter {
    if (![self highlightLayer]) {
        CALayer *highlightLayer = [CALayer layer];
        highlightLayer.frame = self.layer.bounds;
        highlightLayer.backgroundColor = [[UIColor clearColor] CGColor];
        highlightLayer.hidden = YES;
        highlightLayer.speed = 10.0;
        highlightLayer.zPosition = 1;
        highlightLayer.name = [[self class] highlightLayerName];
        [self.layer addSublayer:highlightLayer];
    }
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
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.layer.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)topColor.CGColor,
                            (id)bottomColor.CGColor,
                            nil];
    gradientLayer.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.0f],
                               [NSNumber numberWithFloat:1.0f],
                               nil];

    if (self.layer.cornerRadius) {
        gradientLayer.cornerRadius = self.layer.cornerRadius;
    }

    [self.layer insertSublayer:gradientLayer atIndex:0];
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
