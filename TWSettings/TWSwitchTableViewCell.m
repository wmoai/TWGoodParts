//
//  TWSwitchTableViewCell.m
//

#import "TWSwitchTableViewCell.h"

@implementation TWSwitchTableViewCell
{
    @private
    UISwitch *_switch;
}

@synthesize twSwitch = _switch;

- (id)initWithIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _switch = [[UISwitch alloc] init];
        _switch.on = NO;
        CGPoint point = [self settingViewPoint:_switch.frame.size];
        _switch.frame = CGRectMake(point.x, point.y, _switch.frame.size.width, _switch.frame.size.height);
        [self.contentView addSubview: _switch];
    }
    return self;
}

@end
