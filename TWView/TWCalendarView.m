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
        _calendarLabel.font = [UIFont boldSystemFontOfSize:23.0f];
        _calendarLabel.textColor = [UIColor darkGrayColor];
        _calendarLabel.backgroundColor = [UIColor clearColor];
        _calendarPrevButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_calendarPrevButton setImage:[UIImage imageNamed:@"arrow_left.png"] forState:UIControlStateNormal];
        _calendarPrevButton.frame = CGRectMake(0, 0, _calendarButtonWidth / 2, _selecterViewHeight);
        _calendarPrevButton.backgroundColor = [UIColor clearColor];
        _calendarNextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_calendarNextButton setImage:[UIImage imageNamed:@"arrow_right.png"] forState:UIControlStateNormal];
        _calendarNextButton.frame = CGRectMake(_calendarLabel.frame.origin.x + _calendarLabel.frame.size.width, 0, _calendarButtonWidth / 2, _selecterViewHeight);
        _calendarNextButton.backgroundColor = [UIColor clearColor];

        [_selecterView addSubview:_calendarLabel];
        [_selecterView addSubview:_calendarPrevButton];
        [_selecterView addSubview:_calendarNextButton];

        _scrollView = [[TWInfinityScrollView alloc] initWithFrame:CGRectMake(0, _selecterViewHeight, width, 480)];
        _scrollView.delegate = self;

        // 2 months ago
        float calendarDaysHeight;
        for (int i = 0; i < _calendarTerm; i++) {
            NSDate *date = [self dateFromCurrent:-2 + i];
            NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
            TWCalendarDaysView *calendarDaysView = [[TWCalendarDaysView alloc] initWithWidth:_scrollView.frame.size.width numOfDays:range.length];
            calendarDaysView.backgroundColor = [UIColor whiteColor];
            calendarDaysHeight = calendarDaysView.frame.size.height;
            [_scrollView addPageView:calendarDaysView];
        }

        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, calendarDaysHeight);

        [self addSubview:_scrollView];

        self.backgroundColor = [UIColor whiteColor];
        _selecterView.backgroundColor = [UIColor whiteColor];

        self.frame = CGRectMake(0, 0, width, _selecterViewHeight + _scrollView.frame.size.height);

        [self addSubview:_selecterView];
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

- (void)pageDidScrolled:(int)currentPageIndex
{
    NSDate *date = [self dateFromCurrent:currentPageIndex];
    NSDateComponents *currentPageComps = [self dateComponents:date];
    _calendarLabel.text = [NSString stringWithFormat:@"%d / %d", [currentPageComps year], [currentPageComps month]];
    if ([self isThisMonth:currentPageComps]) {
        [_calendarNextButton setEnabled:NO];
    }

    if (_latestCalendarView) {
        [_latestCalendarView removeGridContents];
    }
    NSUInteger visibleIndex = ceil((float)_calendarTerm / 2) - 1;
    _latestCalendarView = (TWCalendarDaysView *)[_scrollView.pageViews objectAtIndex:visibleIndex];
    [_delegate calendarDidChange:date];
    [_latestCalendarView addGridContents];
    [self render];
}

- (void)movePageView:(UIView *)view pageIndex:(int)pageIndex
{
    TWCalendarDaysView *calendarDaysView = (TWCalendarDaysView *)view;
    NSDate *date = [self dateFromCurrent:pageIndex];
    NSRange range = [self currentRangeFromDate:date];
    [calendarDaysView setNumOfDays:range.length];
    [calendarDaysView reload];
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