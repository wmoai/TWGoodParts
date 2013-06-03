//
//  TWSwitchView.m
//

#import "TWSegmentedView.h"

@implementation TWSegmentedView

- (id)initWithItems:(CGRect)frame items:(NSArray *)items
{
    self = [super initWithFrame:frame row:1 col:items.count];
    if (self) {
        for (int i = 0; i < items.count; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.gridSize.width, self.gridSize.height)];
            button.tag = i;
            [super addSubviewWithIndex:button index:i];
        }
    }

    return self;
}

@end
