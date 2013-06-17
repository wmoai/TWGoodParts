//
//  TWCalendarDaysView.h
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TWCalendarView.h"

@interface TWCalendarDaysView : UIView
{
    __weak id<TWCalendarViewDelegate> _delegate;
}

@property (nonatomic, weak) id<TWCalendarViewDelegate> delegate;

- (id)initWithWidth:(CGFloat)width numOfDays:(NSUInteger)numOfDays month:(NSUInteger)month;
- (void)setNumOfDays:(NSUInteger)numOfDays month:(NSUInteger)month;
- (void)reload;
- (void)addGridContents;
- (void)removeGridContents;

@end