//
//  TWHorizontalTableView.m
//

#import "TWHorizontalTableView.h"

@implementation TWHorizontalTableView

@synthesize datasource;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.width)];
    if (self) {
        self.transform = CGAffineTransformMakeRotation(M_PI * 90 / 180.0f);
        CGRect pre = self.frame;
        pre.origin.x = frame.origin.x;
        pre.origin.y = frame.origin.y;
        self.frame = pre;
        
        self.pagingEnabled = YES;
        self.dataSource = self;
        self.rowHeight = frame.size.width;
        self.allowsSelection = NO;
        
        [self setContentOffset:CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    }
    return self;
}

-(void) render {
    [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]
                atScrollPosition:UITableViewScrollPositionBottom
                        animated:NO];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [datasource numberOfRows:tableView];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [datasource hTableView: tableView
                                 cellForRowAtIndex: [datasource numberOfRows:tableView] - 1 - [indexPath indexAtPosition:1]];
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI * -90 / 180.0f);
    CGRect frame = cell.contentView.frame;
    frame.origin.x = cell.contentView.frame.origin.x;
    frame.origin.y = self.frame.size.width - cell.contentView.frame.size.height;
    cell.contentView.frame = frame;
    
    return cell;
}


@end
