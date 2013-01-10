//
//  TWTableViewCell.m
//  Exstamp
//
//  Created by 東郷 晃典 on 12/12/17.
//
//

#import "TWTableViewCell.h"

@implementation TWTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellEditingStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (CGPoint)settingViewPoint:(CGSize)settingViewSize
{
    CGPoint point = CGPointMake(self.contentView.frame.size.width - settingViewSize.width - 30,
                                (self.contentView.frame.size.height - settingViewSize.height) / 2);
    return point;
}

@end
