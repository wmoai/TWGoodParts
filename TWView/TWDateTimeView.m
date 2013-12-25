//
//  TWDateTimeView.m
//

#import "TWDateTimeView.h"
#import "TWButton.h"

@implementation TWDateTimeView
{
    UIDatePicker *_dateTimePicker;
    UIView *_controllView;
    TWButton *_backButton;
    TWButton *_nextButton;
    NSDateFormatter *_formatter;
    NSDate *_date;
}

@synthesize deleagte = _deleagte;

- (id)initWithFrame:(CGRect)frame
{
    _controllView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 45)];
    _dateTimePicker = [[UIDatePicker alloc] init];
    _dateTimePicker.frame = CGRectMake(0, _controllView.frame.size.height, _dateTimePicker.frame.size.width, _dateTimePicker.frame.size.height);
    
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, _controllView.frame.size.height + _dateTimePicker.frame.size.height)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        
        _controllView.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.9f];
        
        _backButton = [TWButton buttonWithGradient:CGRectMake(5, 5, 75, 35)
                                          topColor:[UIColor colorWithWhite:0.1f alpha:1.0f]
                                       bottomColor:[UIColor colorWithWhite:0.3f alpha:1.0f]];
        _backButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        _nextButton = [TWButton buttonWithGradient:CGRectMake(frame.size.width - 75 - 5, 5, 75, 35)
                                          topColor:[UIColor colorWithWhite:0.1f alpha:1.0f]
                                       bottomColor:[UIColor colorWithWhite:0.3f alpha:1.0f]];
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [self setDateControllView];
        [_controllView addSubview:_backButton];
        [_controllView addSubview:_nextButton];

        NSDate *date = [NSDate date];
        _dateTimePicker.datePickerMode = UIDatePickerModeDate;
        _dateTimePicker.maximumDate = date;
        _dateTimePicker.date = date;
        _dateTimePicker.calendar = [NSCalendar currentCalendar];
        [_dateTimePicker addTarget:self action:@selector(dateTimeDidChanged:) forControlEvents:UIControlEventValueChanged];

        [self addSubview:_dateTimePicker];
        [self addSubview:_controllView];
    }
    return self;
}

- (void)setDateFormatter:(NSString *)format
{
    [_formatter setDateFormat:format];
}

- (void)setMaximumDate:(NSDate *)date
{
    _dateTimePicker.maximumDate = date;
}

- (void)setMinimumDate:(NSDate *)date
{
    _dateTimePicker.minimumDate = date;
}

- (void)setDate:(NSDate *)date
{
    _dateTimePicker.date = date;
}

- (void)setDateControllView
{
    [_backButton removeTarget:self action:@selector(backButtonDidPush:) forControlEvents:UIControlEventTouchUpInside];
    [_nextButton removeTarget:self action:@selector(completeDidPush:) forControlEvents:UIControlEventTouchUpInside];
    [_backButton addTarget:self action:@selector(closeDidPush:) forControlEvents:UIControlEventTouchUpInside];
    [_nextButton addTarget:self action:@selector(nextButtonDidPush:) forControlEvents:UIControlEventTouchUpInside];
    [_backButton setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    [_nextButton setTitle:NSLocalizedString(@"Next", nil) forState:UIControlStateNormal];
    _dateTimePicker.datePickerMode = UIDatePickerModeDate;
    [_dateTimePicker reloadInputViews];
}

- (void)setTimeControllView
{
    [_backButton removeTarget:self action:@selector(closeDidPush:) forControlEvents:UIControlEventTouchUpInside];
    [_nextButton removeTarget:self action:@selector(nextButtonDidPush:) forControlEvents:UIControlEventTouchUpInside];
    [_backButton addTarget:self action:@selector(backButtonDidPush:) forControlEvents:UIControlEventTouchUpInside];
    [_nextButton addTarget:self action:@selector(completeDidPush:) forControlEvents:UIControlEventTouchUpInside];
    [_backButton setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
    [_nextButton setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    _dateTimePicker.datePickerMode = UIDatePickerModeTime;
    [_dateTimePicker reloadInputViews];
}

- (void)nextButtonDidPush:(id)sender
{
    [self setTimeControllView];
}

- (void)backButtonDidPush:(id)sender
{
    [self setDateControllView];
}

- (void)closeDidPush:(id)sender
{
    [self hide];
}

- (void)completeDidPush:(id)sender
{
    [self hide];
    NSString *date = [_formatter stringFromDate:_dateTimePicker.date];
    [_deleagte twDateTimeDidCompleted:_dateTimePicker dateString:date];
}

- (void)show
{
    CGRect parentRect = self.superview.frame;
    CGRect rect = CGRectMake(parentRect.origin.x, parentRect.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    self.hidden = NO;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.frame = rect;
                         [_deleagte twDateTimeDidShow];
                     }];
    [self setDateControllView];
}

- (void)hide
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [self layoutSubviews];
                         [_deleagte twDateTimeDidHide];
                     } completion:^(BOOL finished) {
                         self.hidden = YES;
                         [self setDateControllView];
                     }];
}

- (void)dateTimeDidChanged:(id)sender
{
    NSString *date = [_formatter stringFromDate:_dateTimePicker.date];
    [_deleagte twDateTimeDidChanged:sender dateString:date];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect parentRect = self.superview.frame;
    CGRect rect = CGRectMake(parentRect.origin.x, parentRect.size.height, self.frame.size.width, self.frame.size.height);
    self.frame = rect;
}

@end