//
//  TWHorizontalTableView.h
//

#import <UIKit/UIKit.h>
#import "TWHorizontalTableViewDatasource.h"

@protocol TWHorizontalTableViewDatasource;

@interface TWHorizontalTableView : UITableView <UITableViewDataSource> {
    __weak id<TWHorizontalTableViewDatasource> datasource;
}

@property (weak) id datasource;


@end
