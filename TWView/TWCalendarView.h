//
//  TWCalendarView.h
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol TWCalendarViewDelegate <NSObject>

- (void)contentWithDay:(NSInteger)day;

@end

@interface TWCalendarView : UIView
{
    __weak id<TWCalendarViewDelegate> _delegate;
}

@property (nonatomic, weak) id<TWCalendarViewDelegate> delegate;

- (id)initWithWidth:(CGFloat)width year:(NSUInteger)year month:(NSUInteger)month;

@end

