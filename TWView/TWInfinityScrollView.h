//
//  TWInfinityScrollView.h
//

#import <UIKit/UIKit.h>

enum {
    kTWInfinityScrollDirectionRight,
    kTWInfinityScrollDirectionLeft,
    kTWInfinityScrollDirectionNon
};
typedef NSUInteger TWInfinityScrollDirection;

@protocol TWInfinityScrollViewDelegate <NSObject>

- (void)movePageView:(UIView *)view pageIndex:(int)pageIndex;
- (void)pageDidScrolled:(int)currentPageIndex;

@end

@interface TWInfinityScrollView : UIView <UIScrollViewDelegate>
{
    __weak id<TWInfinityScrollViewDelegate> _delegate;
}

@property (nonatomic, weak) id<TWInfinityScrollViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *pageViews;

- (void)addPageView:(UIView *)view;
- (void)prevPageScrolle:(BOOL)animated;
- (void)nextPageScrolle:(BOOL)animated;

@end