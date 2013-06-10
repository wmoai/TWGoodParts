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

@end

@interface TWCalendarView : UIView <TWInfinityScrollViewDelegate>

- (id)initWithWidth:(CGFloat)width;
- (void)setDelegate:(id)delegate;
- (void)render;

@end

