//
//  TWButton.m
//

#import "TWButton.h"
#import "UIView+TWSupport.h"

@implementation TWButton
{
    CAGradientLayer *_gradientLayer;
    CALayer *_highlightLayer;
    CGSize _maxSize;
    CGFloat _gradientBorderWidth[4];
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

+ (id)buttonWithColor:(CGRect)frame color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius
{
    TWButton *button = [self buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    [button setCornerRadius:cornerRadius];
    [button setOptions:frame];

    return button;
}

- (void)setOptions:(CGRect)frame
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
}

- (void)setOptionsWithCornerRadius:(CGRect)frame
{
    [self setOptions:frame];
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

- (void)setMaxSize:(CGSize)size
{
    _maxSize = size;
}

- (void)widthToFit
{
    CGSize constrainedToSize;
    if (_maxSize.width == 0 && _maxSize.height == 0) {
        constrainedToSize = self.frame.size;
    } else {
        constrainedToSize = _maxSize;
    }

    CGSize sizeToFit = [self.titleLabel.text sizeWithFont:self.titleLabel.font
                                        constrainedToSize:constrainedToSize
                                            lineBreakMode:UILineBreakModeTailTruncation];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, sizeToFit.width, self.frame.size.height)];
}

- (void)setGradientBorder:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right
{
    _gradientBorderWidth[0] = top;
    _gradientBorderWidth[1] = left;
    _gradientBorderWidth[2] = bottom;
    _gradientBorderWidth[3] = right;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();

    UIColor * whiteColor = [UIColor colorWithWhite:0.2f alpha:0.5f];
    UIColor * lightGrayColor = [UIColor colorWithWhite:0.1f alpha:0.5f];
    if (_gradientBorderWidth[0] > 0.0f) {
        CGSize topSize;
//        if (_gradientBorderWidth[1] > 0.0f) {
//            topSize = CGSizeMake(self.frame.size.width - _gradientBorderWidth[1], _gradientBorderWidth[0]);
//        } else {
            topSize = CGSizeMake(self.frame.size.width, _gradientBorderWidth[0]);
//        }
        [self drawLinearGradient:context rect:CGRectMake(0, 0, topSize.width, topSize.height) startColor:lightGrayColor.CGColor endColor:whiteColor.CGColor vertical:NO];
    }
    if (_gradientBorderWidth[1] > 0.0f) {
        CGSize leftSize;
//        if (_gradientBorderWidth[2] > 0.0f) {
//            leftSize = CGSizeMake(_gradientBorderWidth[1], self.frame.size.height - _gradientBorderWidth[2]);
//        } else {
            leftSize = CGSizeMake(_gradientBorderWidth[1], self.frame.size.height);
//        }
        [self drawLinearGradient:context rect:CGRectMake(self.frame.size.width - _gradientBorderWidth[1], 0, leftSize.width, leftSize.height) startColor:lightGrayColor.CGColor endColor:whiteColor.CGColor vertical:YES];
    }
    if (_gradientBorderWidth[2] > 0.0f) {
        CGSize bottomSize;
//        if (_gradientBorderWidth[3] > 0.0f) {
//            bottomSize = CGSizeMake(self.frame.size.width - _gradientBorderWidth[3], _gradientBorderWidth[2]);
//        } else {
            bottomSize = CGSizeMake(self.frame.size.width, _gradientBorderWidth[2]);
//        }
        [self drawLinearGradient:context rect:CGRectMake(0, self.frame.size.height - _gradientBorderWidth[2], bottomSize.width, bottomSize.height) startColor:lightGrayColor.CGColor endColor:whiteColor.CGColor vertical:NO];
    }
    if (_gradientBorderWidth[3] > 0.0f) {
        CGSize rightSize;
//        if (_gradientBorderWidth[0] > 0.0f) {
//            rightSize = CGSizeMake(_gradientBorderWidth[3], self.frame.size.height - _gradientBorderWidth[0]);
//        } else {
            rightSize = CGSizeMake(_gradientBorderWidth[3], self.frame.size.height);
//        }
        [self drawLinearGradient:context rect:CGRectMake(0, 0, rightSize.width, rightSize.height) startColor:lightGrayColor.CGColor endColor:whiteColor.CGColor vertical:YES];
    }
}

@end
