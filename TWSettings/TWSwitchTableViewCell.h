//
//  TWSwitchTableViewCell.h
//  Exstamp
//
//  Created by 東郷 晃典 on 12/12/17.
//
//

#import "TWTableViewCell.h"

@interface TWSwitchTableViewCell : TWTableViewCell

@property (nonatomic, readonly) UISwitch *twSwitch;

- (id)initWithIdentifier:(NSString *)reuseIdentifier;

@end
