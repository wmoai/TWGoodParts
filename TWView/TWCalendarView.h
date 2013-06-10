//
//  TWCalendarView.h
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TWInfinityScrollView.h"

@protocol TWCalendarViewDelegate <NSObject>

- (UIView *)contentWithDay:(NSInteger)day gridRect:(CGRect)gridRect;
- (void)prevCalendarButtonDidPush:(id)sender;
- (void)nextCalendarButtonDidPush:(id)sender;
- (void)calendarDidChange:(NSDate *)date;

@end

@interface TWCalendarView : UIView <TWInfinityScrollViewDelegate>
{
    __weak id<TWCalendarViewDelegate> _delegate;
}

@property (nonatomic, weak) id<TWCalendarViewDelegate> delegate;

- (id)initWithWidth:(CGFloat)width;
- (void)setDelegate:(id <TWCalendarViewDelegate>)delegate;
- (void)render;

@end

