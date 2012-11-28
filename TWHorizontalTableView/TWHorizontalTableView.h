//
//  TWHorizontalTableView.h
//  horizonscroll
//
//  Created by 琢也 渡瀬 on 12/11/28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWHorizontalTableViewDatasource.h"

@protocol TWHorizontalTableViewDatasource;

@interface TWHorizontalTableView : UIView <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    __weak id<TWHorizontalTableViewDatasource> datasource;
}

@property (weak) id datasource;
-(void) render;

@end
