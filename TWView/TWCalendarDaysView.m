//
//  TWCalendarDaysView.m
//

#import "TWCalendarDaysView.h"
#import "TWPinLabel.h"

@implementation TWCalendarDaysView
{
    int _row;
    int _col;
    int _maxRow;
    NSUInteger _month;
    NSUInteger _numOfDays;
    int _maxNumOfDays;
    float _gridWidth;
    float _gridHeight;
    NSMutableArray *_gridContentTags;
    NSMutableArray *_dayLabels;
}

@synthesize delegate = _delegate;

- (id)initWithWidth:(CGFloat)width numOfDays:(NSUInteger)numOfDays month:(NSUInteger)month
{
    self = [super init];
    if (self) {
        [self setNumOfDays:numOfDays month:month];
        _maxNumOfDays = 31;
        _dayLabels = [NSMutableArray arrayWithCapacity:_maxNumOfDays];
        _gridContentTags = [NSMutableArray arrayWithCapacity:_maxNumOfDays];
        _maxRow = ceil((float)_maxNumOfDays / 4);
        _col = 4;
        _gridWidth = width / _col;
        _gridHeight = _gridWidth;

        self.frame = CGRectMake(0, 0, width, _gridHeight * _maxRow);

        [self addDayLabel];
    }
    return self;
}

- (void)setNumOfDays:(NSUInteger)numOfDays month:(NSUInteger)month
{
    _numOfDays = numOfDays;
    _row = ceil((float)_numOfDays / 4);
    _month = month;
}

- (void)addDayLabel
{
    float y = 0;
    float x = 0;
    int index = 0;

    for (int i = 0; i < _maxRow; i++) {
        y = _gridHeight * i;
        for (int j = 0; j < _col; j++) {
            index++;

            if (index <= _maxNumOfDays) {
                x = _gridWidth * j;

                TWPinLabel *label;
                if (_dayLabels.count < _maxNumOfDays) {
                    label = [[TWPinLabel alloc] initWithFrame:CGRectMake(x, y, 20, 20)];
                    label.textColor = [UIColor whiteColor];
                    label.text = [NSString stringWithFormat:@"%d", index];
                    label.font = [UIFont fontWithName:@"Baskerville-SemiBoldItalic" size:11.0f];
                    label.layer.zPosition = 1;
                    [self addSubview:label];
                    [_dayLabels addObject:label];
                } else {
                    label = [_dayLabels objectAtIndex:index - 1];
                }

                if (index <= _numOfDays) {
                    label.hidden = NO;
                } else {
                    label.hidden = YES;
                }
            }
        }
    }
}

- (void)reload
{
    [self addDayLabel];
}

- (void)addGridContents
{
    float y = 0;
    float x = 0;
    int index = 0;

    for (int i = 0; i < _row; i++) {
        y = _gridHeight * i;
        for (int j = 0; j < _col; j++) {
            index++;
            x = _gridWidth * j;

            if (index <= _numOfDays) {
                UIView *view = [_delegate contentWithDay:index month:_month gridRect:CGRectMake(x, y, _gridWidth, _gridHeight)];

                if (view) {
                    view.tag = index;
                    [self addSubview:view];
                    [_gridContentTags addObject:[NSNumber numberWithInt:index]];
                }
            }
        }
    }
}

- (void)removeGridContents
{
    for (NSNumber *number in _gridContentTags) {
        UIView *view = [self viewWithTag:[number integerValue]];
        [view removeFromSuperview];
    }

    [_gridContentTags removeAllObjects];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGContextSetRGBStrokeColor(ctx, 0.75, 0.75, 0.75, 1.0f);

    for (int i = 0; i < _maxRow + 1; i++) {
        float y = _gridHeight * i;
        CGContextMoveToPoint(ctx, 0, y);
        CGContextAddLineToPoint(ctx, self.frame.size.width, y);
    }
    for (int j = 0; j < _col + 1; j++) {
        float x = _gridWidth * j;
        CGContextMoveToPoint(ctx, x, 0);
        CGContextAddLineToPoint(ctx, x, self.frame.size.height);
    }

    CGContextStrokePath(ctx);
}

@end
