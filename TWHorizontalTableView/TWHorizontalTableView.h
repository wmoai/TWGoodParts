//
//  TWHorizontalTableView.h
//  horizonscroll
//
//  Created by wmoai on 12/11/28.
//  Copyright (c) 2012. All rights reserved.
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
