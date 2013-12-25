//
//  TWCalendarView.m
//
#import "TWCalendarView.h"
#import "TWCalendarDaysView.h"

@implementation TWCalendarView
{
    float _selecterViewHeight;
    float _calendarButtonWidth;
    int _calendarTerm;
    UIView *_selecterView;
    UILabel *_calendarLabel;
    UIButton *_calendarPrevButton;
    UIButton *_calendarNextButton;
    TWInfinityScrollView *_scrollView;
    TWCalendarDaysView *_latestCalendarView;
}

@synthesize delegate = _delegate;

- (id)initWithWidth:(CGFloat)width
{
    self = [super init];
    if (self) {
        _calendarTerm = 5;
        _selecterViewHeight = 50;
        _calendarButtonWidth = 180;
        _selecterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, _selecterViewHeight)];
        _calendarLabel = [[UILabel alloc] initWithFrame:CGRectMake(_calendarButtonWidth / 2, 0, width - _calendarButtonWidth, _selecterView.frame.size.height)];
        _calendarLabel.textAlignment = UITextAlignmentCenter;
        _calendarLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        _calendarLabel.textColor = [UIColor whiteColor];
        _calendarLabel.backgroundColor = [UIColor clearColor];
        _calendarPrevButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_calendarPrevButton setImage:[UIImage imageNamed:@"tw_arrow_left.png"] forState:UIControlStateNormal];
        _calendarPrevButton.frame = CGRectMake(0, 0, _calendarButtonWidth / 2, _selecterViewHeight);
        _calendarPrevButton.backgroundColor = [UIColor clearColor];
        [_calendarPrevButton addTarget:self action:@selector(prevCalendarButtonDidPush:) forControlEvents:UIControlEventTouchUpInside];
        _calendarNextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_calendarNextButton setImage:[UIImage imageNamed:@"tw_arrow_right.png"] forState:UIControlStateNormal];
        _calendarNextButton.frame = CGRectMake(_calendarLabel.frame.origin.x + _calendarLabel.frame.size.width, 0, _calendarButtonWidth / 2, _selecterViewHeight);
        _calendarNextButton.backgroundColor = [UIColor clearColor];
        [_calendarNextButton addTarget:self action:@selector(nextCalendarButtonDidPush:) forControlEvents:UIControlEventTouchUpInside];

        [_selecterView addSubview:_calendarLabel];
        [_selecterView addSubview:_calendarPrevButton];
        [_selecterView addSubview:_calendarNextButton];

        _scrollView = [[TWInfinityScrollView alloc] initWithFrame:CGRectMake(0, _selecterViewHeight, width, 480)];
        _scrollView.delegate = self;

        // 2 months ago
        float calendarDaysHeight;
        for (int i = 0; i < _calendarTerm; i++) {
            NSDate *date = [self dateFromCurrent:-2 + i];
            NSDateComponents *comps = [self dateComponents:date];
            NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
            TWCalendarDaysView *calendarDaysView = [[TWCalendarDaysView alloc] initWithWidth:_scrollView.frame.size.width numOfDays:range.length month:[comps month]];
            calendarDaysView.backgroundColor = [UIColor clearColor];
            calendarDaysHeight = calendarDaysView.frame.size.height;
            [_scrollView addPageView:calendarDaysView];
        }

        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, calendarDaysHeight);

        [self addSubview:_scrollView];

        self.backgroundColor = [UIColor clearColor];
        _selecterView.backgroundColor = [UIColor colorWithWhite:0.1f alpha:0.9f];

        self.frame = CGRectMake(0, 0, width, _selecterViewHeight + _scrollView.frame.size.height);

        [self addSubview:_selecterView];
        [self render];
    }
    return self;
}

- (void)setDelegate:(id<TWCalendarViewDelegate>)delegate
{
    _delegate = delegate;
    for (TWCalendarDaysView *view in _scrollView.pageViews) {
        view.delegate = delegate;
    }
}

- (void)setCalendarLabelBackgroundColor:(UIColor *)color
{
    _calendarLabel.backgroundColor = color;
}

- (void)setCalendarLabelTextColor:(UIColor *)color
{
    _calendarLabel.textColor = color;
}

- (void)setCalendarBackgroundColor:(UIColor *)color
{
    _scrollView.backgroundColor = color;
    for (TWCalendarDaysView *view in _scrollView.pageViews) {
        view.backgroundColor = color;
    }
}

- (void)setCalendarNextButtonTitleColor:(UIColor *)color
{
    _calendarNextButton.titleLabel.textColor = color;
}

- (void)setCalendarNextButtonBackgroundColor:(UIColor *)color
{
    _calendarNextButton.backgroundColor = color;
}

- (void)setCalendarPrevButtonTitleColor:(UIColor *)color
{
    _calendarPrevButton.titleLabel.textColor = color;
}

- (void)setCalendarPrevButtonBackgroundColor:(UIColor *)color
{
    _calendarPrevButton.backgroundColor = color;
}

- (void)setCalendarPrevButtonImage:(NSString *)image
{
    [_calendarPrevButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
}

- (void)setCalendarNextButtonImage:(NSString *)image
{
    [_calendarNextButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
}

- (BOOL)isThisMonth:(NSDateComponents *)comps
{
    NSDateComponents *nowComps = [self dateComponents:[NSDate date]];
    if ([nowComps year] == [comps year] && [nowComps month] == [comps month]) {
        return YES;
    }
    return NO;
}

- (void)render
{
    [self pageDidScrolled:0];
}

- (void)contentsLoad
{
    [_latestCalendarView addGridContents];
}

- (void)pageDidScrolled:(int)currentPageIndex
{
    NSDate *date = [self dateFromCurrent:currentPageIndex];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSArray *langs = [NSLocale preferredLanguages];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:[langs objectAtIndex:0]];
    [formatter setLocale:locale];
    [formatter setDateFormat:NSLocalizedString(@"MonthDateFormat", nil)];
    _calendarLabel.text = [formatter stringFromDate:date];

    [_calendarNextButton setEnabled:YES];

    if (_latestCalendarView) {
        [_latestCalendarView removeGridContents];
    }
    NSUInteger visibleIndex = ceil((float)_calendarTerm / 2) - 1;
    _latestCalendarView = (TWCalendarDaysView *)[_scrollView.pageViews objectAtIndex:visibleIndex];
    [_delegate calendarDidChange:date];
}

- (void)movePageView:(UIView *)view pageIndex:(int)pageIndex
{
    TWCalendarDaysView *calendarDaysView = (TWCalendarDaysView *)view;
    NSDate *date = [self dateFromCurrent:pageIndex];
    NSDateComponents *comps = [self dateComponents:date];
    NSRange range = [self currentRangeFromDate:date];
    [calendarDaysView setNumOfDays:range.length month:[comps month]];
    [calendarDaysView reload];
}

- (void)prevCalendarButtonDidPush:(id)sender
{
    [_scrollView prevPageScrolle:YES];
}

- (void)nextCalendarButtonDidPush:(id)sender
{
    [_scrollView nextPageScrolle:YES];
}

- (NSDate *)dateFromCurrent:(int)passedMonth
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:passedMonth];
    return [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:[NSDate date] options:0];
}

- (NSDateComponents *)dateComponents:(NSDate *)date
{
    return [[NSCalendar currentCalendar] components:NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
}

- (NSRange)currentRangeFromDate:(NSDate *)date
{
    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
}

@end