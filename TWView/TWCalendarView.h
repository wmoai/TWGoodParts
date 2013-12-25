//
//  TWCalendarView.h
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TWInfinityScrollView.h"

@protocol TWCalendarViewDelegate <NSObject>

- (UIView *)contentWithDay:(NSInteger)day month:(NSUInteger)month gridRect:(CGRect)gridRect;
- (void)calendarDidChange:(NSDate *)date;

@end

@interface TWCalendarView : UIView <TWInfinityScrollViewDelegate>
{
    __weak id<TWCalendarViewDelegate> _delegate;
}

@property (nonatomic, weak) id<TWCalendarViewDelegate> delegate;

- (id)initWithWidth:(CGFloat)width;
- (void)setDelegate:(id <TWCalendarViewDelegate>)delegate;
- (void)contentsLoad;
- (void)setCalendarLabelBackgroundColor:(UIColor *)color;
- (void)setCalendarLabelTextColor:(UIColor *)color;
- (void)setCalendarNextButtonTitleColor:(UIColor *)color;
- (void)setCalendarNextButtonBackgroundColor:(UIColor *)color;
- (void)setCalendarNextButtonImage:(NSString *)image;
- (void)setCalendarPrevButtonTitleColor:(UIColor *)color;
- (void)setCalendarPrevButtonBackgroundColor:(UIColor *)color;
- (void)setCalendarPrevButtonImage:(NSString *)image;
@end

