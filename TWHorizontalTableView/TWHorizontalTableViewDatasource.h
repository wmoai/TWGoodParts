//
//  TWHorizontalTableViewDatasource.h
//  horizonscroll
//
//  Created by wmoai on 12/11/28.
//  Copyright (c) 2012. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TWHorizontalTableViewDatasource <NSObject>

@required
-(UITableViewCell*)hTableView:(UITableView *)tableView cellForRowAtIndex:(NSInteger)index;
-(NSInteger)numberOfRows:(UITableView *)tableView;

@end
