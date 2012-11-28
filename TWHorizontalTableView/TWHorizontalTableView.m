//
//  TWHorizontalTableView.m
//  horizonscroll
//
//  Created by 琢也 渡瀬 on 12/11/28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TWHorizontalTableView.h"

@implementation TWHorizontalTableView

@synthesize datasource;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.width)];
        [self addSubview:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = frame.size.width;
        _tableView.allowsSelection = NO;
        
        _tableView.center = self.center;
        _tableView.transform = CGAffineTransformMakeRotation(M_PI * 90 / 180.0f);
        _tableView.pagingEnabled = YES;
        
        return self;
    }
    return self;
}

-(void) render {
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]
                  atScrollPosition:UITableViewScrollPositionBottom
                          animated:NO];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [datasource numberOfRows:tableView];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [datasource hsList:tableView 
                             cellForRowAtIndex: [datasource numberOfRows:tableView] - 1 - [indexPath indexAtPosition:1]];
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI * -90 / 180.0f);
    CGRect frame = cell.contentView.frame;
    frame.origin.x = cell.contentView.frame.origin.x;
    frame.origin.y = self.frame.size.width - cell.contentView.frame.size.height;
    cell.contentView.frame = frame;
    
    return cell;
}


@end
