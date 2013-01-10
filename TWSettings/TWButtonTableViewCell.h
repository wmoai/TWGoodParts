//
//  TWButtonTableViewCell.h
//

#import "TWTableViewCell.h"

@class TWButton;

@interface TWButtonTableViewCell : TWTableViewCell

@property (nonatomic, readonly) TWButton *twButton;

- (id)initWithIdentifier:(NSString *)reuseIdentifier;

@end