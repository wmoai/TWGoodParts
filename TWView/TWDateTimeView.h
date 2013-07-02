//
//  TWDateTimeView.h
//

#import <UIKit/UIKit.h>

@protocol TWDateTimeDelegate <NSObject>

- (void)twDateTimeDidChanged:(UIDatePicker *)datePicker dateString:(NSString *)dateString;
- (void)twDateTimeDidCompleted:(UIDatePicker *)datePicker dateString:(NSString *)dateString;

@end

@interface TWDateTimeView : UIView

@property(weak, nonatomic) id <TWDateTimeDelegate> deleagte;

- (void)show;
- (void)hide;

@end
