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

@interface TWInfinityScrollView : UIView <UIScrollViewDelegate>

- (void)addPageView:(UIView *)view;

@end
