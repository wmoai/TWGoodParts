//
//  TWHorizontalTableViewDatasource.h
//

#import <Foundation/Foundation.h>

@protocol TWHorizontalTableViewDatasource <NSObject>

@required
-(UITableViewCell*)hTableView:(UITableView *)tableView cellForRowAtIndex:(NSInteger)index;
-(NSInteger)numberOfRows:(UITableView *)tableView;

@end
