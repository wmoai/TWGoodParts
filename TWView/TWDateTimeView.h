//
//  TWDateTimeView.h
//

#import <UIKit/UIKit.h>

@protocol TWDateTimeDelegate <NSObject>

- (void)twDateTimeDidChanged:(UIDatePicker *)datePicker dateString:(NSString *)dateString;
- (void)twDateTimeDidCompleted:(UIDatePicker *)datePicker dateString:(NSString *)dateString;
- (void)twDateTimeDidShow;
- (void)twDateTimeDidHide;

@end

@interface TWDateTimeView : UIView

@property(weak, nonatomic) id <TWDateTimeDelegate> deleagte;

- (void)show;
- (void)hide;
- (void)setDate:(NSDate *)date;
- (void)setDateFormatter:(NSString *)format;
- (void)setMaximumDate:(NSDate *)date;
- (void)setMinimumDate:(NSDate *)date;

@end
