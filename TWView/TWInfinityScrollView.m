//
//  TWInfinityScrollView.m
//

#import "TWInfinityScrollView.h"

@implementation TWInfinityScrollView
{
    NSMutableArray *_pageViews;
    UIScrollView *_innerScrollView;
    CGFloat _currentOriginX;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _pageViews = [NSMutableArray array];
        _innerScrollView = [[UIScrollView alloc] initWithFrame:frame];
        _innerScrollView.pagingEnabled = YES;
        _innerScrollView.delegate = self;
        _innerScrollView.bounces = NO;

        [self addSubview:_innerScrollView];
    }
    return self;
}

- (void)addPageView:(UIView *)view
{
    [_pageViews addObject:view];
    view.backgroundColor = [UIColor greenColor];
    [_innerScrollView addSubview:view];
    _innerScrollView.contentSize = CGSizeMake(_pageViews.count * self.frame.size.width, self.frame.size.height);
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

    NSLog(@"pageIndex %d", pageIndex);

    [self replacePageView:direction pageIndex:pageIndex];
}

- (void)replacePageView:(TWInfinityScrollDirection)direction pageIndex:(int)pageIndex
{
    UIView *replaceView;
    switch (direction) {
        case kTWInfinityScrollDirectionRight:
            for (int i = 0; i < abs(pageIndex); i++) {
                replaceView = [_pageViews lastObject];
                [_pageViews removeLastObject];
                [_pageViews insertObject:replaceView atIndex:0];
            }
            [self layoutSubviews];
            break;
        case kTWInfinityScrollDirectionLeft:
            for (int i = 0; i < abs(pageIndex); i++) {
                replaceView = [_pageViews objectAtIndex:0];
                [_pageViews removeObjectAtIndex:0];
                [_pageViews insertObject:replaceView atIndex:_pageViews.count];
            }
            [self layoutSubviews];
            break;
        default:
            break;
    }
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
