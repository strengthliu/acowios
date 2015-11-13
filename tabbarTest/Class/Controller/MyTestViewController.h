//
//  MyTestViewController.h
//  TableViewRefresh
//
//  Created by Abby_Lin on 12-5-2.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

@interface MyTestViewController : RootViewController{
    @private
    NSMutableArray *_dataSource;
    NSInteger _totalNumberOfRows;
    NSInteger _refreshCount;
    NSInteger _loadMoreCount;
}

@end
