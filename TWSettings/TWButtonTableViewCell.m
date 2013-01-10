//
//  TWButtonTableViewCell.m
//

#import "TWButtonTableViewCell.h"
#import "TWButton.h"

@implementation TWButtonTableViewCell
{
    @private
    TWButton *_button;
}

@synthesize twButton = _button;

- (id)initWithIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _button = [TWButton buttonWithGradient:CGRectMake(0, 0, 75, 25)];
        CGPoint point = [self settingViewPoint:_button.frame.size];
        _button.frame = CGRectMake(point.x, point.y, _button.frame.size.width, _button.frame.size.height);
        [self.contentView addSubview: _button];
    }
    return self;
}

@end
