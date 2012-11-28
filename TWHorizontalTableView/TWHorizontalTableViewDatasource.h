//
//  TWHorizontalTableViewDatasource.h
//  horizonscroll
//
//  Created by 琢也 渡瀬 on 12/11/28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TWHorizontalTableViewDatasource <NSObject>

@required
-(UITableViewCell*)hsList:(UITableView *)tableView cellForRowAtIndex:(NSInteger)index;
-(NSInteger)numberOfRows:(UITableView *)tableView;

@end
