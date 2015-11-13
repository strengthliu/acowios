//
//  MyTestViewController.m
//  TableViewRefresh
//
//  Created by Abby_Lin on 12-5-2.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyTestViewController.h"

@interface MyTestViewController ()

@end

@implementation MyTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // test data
    _totalNumberOfRows = 100;
    _refreshCount = 0;
    _dataSource = [[NSMutableArray alloc] initWithCapacity:4];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10.0, 0);

    // set header
    [self createHeaderView];
    
    // the footer should be set after the data of tableView has been loaded, the frame of footer is according to the contentSize of tableView
    // here, actually begin too load your data, eg: from the netserver

    [self showRefreshHeader:YES];
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:2.0f];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark overide UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource?1:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource?_dataSource.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
    if (_dataSource && indexPath.row < _dataSource.count) {
        cell.textLabel.text = [_dataSource objectAtIndex:indexPath.row];
    }
    
    return cell;
}

#pragma mark-
#pragma mark overide methods
-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
	[super beginToReloadData:aRefreshPos];
    
    if (aRefreshPos == EGORefreshHeader) {
        // pull down to refresh data
        [self performSelector:@selector(testRealRefreshDataSource) withObject:nil afterDelay:2.0];
    }else if(aRefreshPos == EGORefreshFooter){
        // pull up to load more data
        [self performSelector:@selector(testRealLoadMoreData) withObject:nil afterDelay:2.0];
    }
}

-(void)testRealRefreshDataSource{
    NSInteger count = _dataSource?_dataSource.count:0;
    
    [_dataSource removeAllObjects];
    _refreshCount ++;
    
    for (int i = 0; i < count; i++) {
        NSString *newString = [NSString stringWithFormat:@"%d_new label number %d", _refreshCount,i];
        [_dataSource addObject:newString];
    }
    
    // after refreshing data, call finishReloadingData to reset the header/footer view
    [_tableView reloadData];
    [self finishReloadingData];
}

-(void)testRealLoadMoreData{
    NSInteger count = _dataSource?_dataSource.count:0;
    NSString *stringFormat;
    if (_refreshCount == 0) {
        stringFormat = @"label number %d";
    }else {
        stringFormat = [NSString stringWithFormat:@"%d_new label number ", _refreshCount];
        stringFormat = [stringFormat stringByAppendingString:@"%d"];
    }
    
    for (int i = 0; i < 20; i++) {
        NSString *newString = [NSString stringWithFormat:stringFormat, i+count];
        if (_dataSource == nil) {
            _dataSource = [[NSMutableArray alloc] initWithCapacity:4];

        }
        [_dataSource addObject:newString];
    }
    
    _loadMoreCount ++;
    
    // after refreshing data, call finishReloadingData to reset the header/footer view
    if (_loadMoreCount > 3) {
        [self finishReloadingData];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
        [self removeFooterView];
    }else{
        [_tableView reloadData];
        [self finishReloadingData];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
        [self setFooterView];
    }
}

-(void)testFinishedLoadData{
    for (int i = 0; i < 20; i++) {
        NSString *tableString = [NSString stringWithFormat:@"label number %d", i];
        [_dataSource addObject:tableString];
    }
    
    // after loading data, should reloadData and set the footer to the proper position
    [self.tableView reloadData];
    [self finishReloadingData];
    [self setFooterView];
}

@end
