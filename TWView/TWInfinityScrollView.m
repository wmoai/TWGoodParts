//
//  TWInfinityScrollView.m
//

#import "TWInfinityScrollView.h"

@implementation TWInfinityScrollView
{
    NSMutableArray *_pageViews;
    UIScrollView *_innerScrollView;
    CGFloat _currentOriginX;
    int _currentPageIndex;
}

@synthesize delegate = _delegate;
@synthesize pageViews = _pageViews;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _pageViews = [NSMutableArray array];
        _innerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _innerScrollView.pagingEnabled = YES;
        _innerScrollView.delegate = self;
        _innerScrollView.bounces = NO;
        _currentPageIndex = 0;

        [self addSubview:_innerScrollView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _innerScrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)addPageView:(UIView *)view
{
    [_pageViews addObject:view];
    [_innerScrollView addSubview:view];
    _innerScrollView.contentSize = CGSizeMake(_pageViews.count * self.frame.size.width, view.frame.size.height);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    TWInfinityScrollDirection direction;
    int pageIndex = roundf((scrollView.contentOffset.x - _currentOriginX) / scrollView.frame.size.width);

    if (pageIndex < 0) {
        direction = kTWInfinityScrollDirectionRight;
    } else if (pageIndex > 0) {
        direction = kTWInfinityScrollDirectionLeft;
    } else {
        direction = kTWInfinityScrollDirectionNon;
    }

    if (direction != kTWInfinityScrollDirectionNon) {
        [self replacePageView:direction pageIndex:pageIndex];
        _currentPageIndex += pageIndex;
        [_delegate pageDidScrolled:_currentPageIndex];
    }
}

- (void)replacePageView:(TWInfinityScrollDirection)direction pageIndex:(int)pageIndex
{
    UIView *replaceView;
    switch (direction) {
        case kTWInfinityScrollDirectionRight:
        {
            int leftEndIndex = _currentPageIndex - (_pageViews.count / 2);
            for (int i = 0; i < abs(pageIndex); i++) {
                replaceView = [_pageViews lastObject];
                [_pageViews removeLastObject];
                [_pageViews insertObject:replaceView atIndex:0];
                [_delegate movePageView:replaceView pageIndex:leftEndIndex - (i + 1)];
            }
        }
            break;
        case kTWInfinityScrollDirectionLeft:
        {
            int rightEndIndex = _currentPageIndex + (_pageViews.count / 2);
            for (int i = 0; i < abs(pageIndex); i++) {
                replaceView = [_pageViews objectAtIndex:0];
                [_pageViews removeObjectAtIndex:0];
                [_pageViews insertObject:replaceView atIndex:_pageViews.count];
                [_delegate movePageView:replaceView pageIndex:rightEndIndex + (i + 1)];
            }
        }
            break;
        default:
            return;
            break;
    }

    [self layoutSubviews];
}

- (void)nextPageScrolle:(BOOL)animated
{
    CGPoint origin = _innerScrollView.contentOffset;
    [_innerScrollView setContentOffset:CGPointMake(origin.x + _innerScrollView.frame.size.width, origin.y) animated:YES];
}

- (void)prevPageScrolle:(BOOL)animated
{
    CGPoint origin = _innerScrollView.contentOffset;
    [_innerScrollView setContentOffset:CGPointMake(origin.x - _innerScrollView.frame.size.width, origin.y) animated:YES];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    int index = 0;
    float ctx = self.frame.size.width / 2;
    float cty = self.frame.size.height / 2;

    for (UIView *view in _pageViews) {
        view.center = CGPointMake(ctx + (self.frame.size.width * index), cty);
        index++;
    }

    int half = ceil(_pageViews.count / 2);
    [_innerScrollView setContentOffset:CGPointMake(_innerScrollView.frame.size.width * half, _innerScrollView.frame.origin.y)];
    _currentOriginX = _innerScrollView.contentOffset.x;
}


@end
