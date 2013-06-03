//
//  TWCalendarView.m
//
#import "TWCalendarView.h"
#import "UIColor+Support.h"
#import "TWPinLabel.h"
#import "UIImage+TWRemoteURL.h"
#import "UIImage+TWSupport.h"

@implementation TWCalendarView
{
    int _row;
    int _col;
    int _lastDay;
    float _calendarWidth;
    float _calendarHeight;
    float _gridWidth;
    float _gridHeight;
    CGPoint _calendarOrigin;
    UIColor *_calendarColor;
    UIColor *_selectorColor;
    UIView *_selecterView;
    UILabel *_calendarLabel;
    UIButton *_calendarPrevButton;
    UIButton *_calendarNextButton;
}

@synthesize delegate;

- (id)initWithWidth:(CGFloat)width year:(NSUInteger)year month:(NSUInteger)month
{
    self = [super init];
    if (self) {
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:year];
        [comps setMonth:month];

        _selecterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 50)];
        _calendarLabel = [[UILabel alloc] initWithFrame:CGRectMake(180 / 2, 0, width - 180, _selecterView.frame.size.height)];
        _calendarLabel.text = [NSString stringWithFormat:@"%d / %d", year, month];
        _calendarLabel.textAlignment = UITextAlignmentCenter;
        _calendarLabel.font = [UIFont boldSystemFontOfSize:23.0f];
        _calendarLabel.textColor = [UIColor mainTextColor];
        _calendarLabel.backgroundColor = [UIColor clearColor];
        _calendarPrevButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_calendarPrevButton setImage:[UIImage imageNamed:@"arrow_left.png"] forState:UIControlStateNormal];
        _calendarPrevButton.frame = CGRectMake(0, 0, 90, 50);
        _calendarPrevButton.backgroundColor = [UIColor clearColor];
        _calendarNextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_calendarNextButton setImage:[UIImage imageNamed:@"arrow_right.png"] forState:UIControlStateNormal];
        _calendarNextButton.frame = CGRectMake(_calendarLabel.frame.origin.x + _calendarLabel.frame.size.width, 0, 90, 50);
        _calendarNextButton.backgroundColor = [UIColor clearColor];

        [_selecterView addSubview:_calendarLabel];
        [_selecterView addSubview:_calendarPrevButton];
        [_selecterView addSubview:_calendarNextButton];

        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDate *date = [cal dateFromComponents:comps];

        NSRange range = [cal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];

        _lastDay = range.length;

        // 切り上げ
        _row = ceil((float)_lastDay / 4);
        _col = 4;
        _gridWidth = width / _col;
        _gridHeight = _gridWidth;
        _calendarWidth = width;
        _calendarHeight = _gridHeight * _row + _selecterView.frame.size.height;

        _calendarOrigin = CGPointMake(0, _selecterView.frame.size.height);

        [self addGridContents];

        self.backgroundColor = [UIColor whiteColor];
        _selecterView.backgroundColor = [UIColor whiteColor];

        self.frame = CGRectMake(0, 0, _calendarWidth, _calendarHeight);

        [self addSubview:_selecterView];
    }
    return self;
}

- (void)addGridContents
{
    float y = 0;
    float x = 0;
    int index = 0;

    for (int i = 0; i < _row; i++) {
        y = _calendarOrigin.y + (_gridHeight * i);
        for (int j = 0; j < _col; j++) {
            index++;
            x = _calendarOrigin.x + _gridWidth * j;

            if (index <= _lastDay) {

                [delegate contentWithDay:index];

                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x + 5, y + 5, _gridWidth - 10, _gridHeight - 10)];
                imageView.contentMode = UIViewContentModeCenter;
                imageView.backgroundColor = [UIColor imageBackgroundColor];
                imageView.layer.borderWidth = 2.0f;
                imageView.layer.borderColor = [UIColor imageBorderColor].CGColor;
                imageView.layer.masksToBounds = NO;
                imageView.layer.shadowOffset = CGSizeMake(2, 2);
                imageView.layer.shadowOpacity = 0.5;

                [UIImage imageWithURL:[NSURL URLWithString:@"https://s3-ap-northeast-1.amazonaws.com/exstamp-dev/uploads/experience/image/2/size_200_dokupe.jpg"]
                             cacheTag:@"experiences"
                           completion:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                               [UIImage scaleAspectFillWithCenterCropping:image size:imageView.frame.size completion:^(UIImage *image) {
                                   [imageView setImage:image];
                               }];
                           }];

                [self addSubview:imageView];

                TWPinLabel *label = [[TWPinLabel alloc] initWithFrame:CGRectMake(x, y, 20, 20)];
                label.text = [NSString stringWithFormat:@"%d", index];
                label.textColor = [UIColor whiteColor];
                label.font = [UIFont fontWithName:@"Baskerville-SemiBoldItalic" size:11.0f];
                [self addSubview:label];
            }
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGContextSetRGBStrokeColor(ctx, 0.75, 0.75, 0.75, 1.0f);

    for (int i = 0; i < _row + 1; i++) {
        float y = _calendarOrigin.y + (_gridHeight * i);
        CGContextMoveToPoint(ctx, _calendarOrigin.x, y);
        CGContextAddLineToPoint(ctx, _calendarOrigin.x + _calendarWidth, y);
    }
    for (int j = 0; j < _col + 1; j++) {
        float x = _calendarOrigin.x + _gridWidth * j;
        CGContextMoveToPoint(ctx, x, _calendarOrigin.y);
        CGContextAddLineToPoint(ctx, x, _calendarOrigin.y + _calendarHeight);
    }

    CGContextStrokePath(ctx);
}

@end