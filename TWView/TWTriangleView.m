//
//  TWTriangleView.m
//

#import "TWTriangleView.h"

@implementation TWTriangleView
{
    UIImage *_image;
}

@synthesize fillColor = _fillColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _image = [UIImage imageNamed:@"rexstamp_01.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:_image];
        float margin = 3;
        imageView.frame = CGRectMake(frame.size.width / 2, margin, (frame.size.width / 2) - margin, frame.size.height / 2 - margin);
        [self addSubview:imageView];
    }

    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self.fillColor setFill];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, width, 0);
    CGContextAddLineToPoint(ctx, width, height);

    CGContextFillPath(ctx);
}

@end
