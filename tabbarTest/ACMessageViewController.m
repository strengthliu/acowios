//
//  FirstViewController.m
//  tabbarTest
//
//  Created by Kevin Lee on 13-5-6.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import "ACMessageViewController.h"
#import "ACLiveAPI.h"
#import "ACNetWorkAPI.h"
#import "ACUserInfo.h"
#import "YTKBaseRequest.h"
#import "YTKChainRequest.h"

@interface ACMessageViewController () {
    NSArray *_sections; // 段数
    NSMutableArray *_testArray; // 每一条cell
}

@property (nonatomic, weak) IBOutlet UITableView *tableView; // tableView
@property (nonatomic) BOOL useCustomCells; // 是否使用自定义Cell
@property (nonatomic, weak) UIRefreshControl *refreshControl; // 刷新菊花

@end

@implementation ACMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 设置tableView的代理及数据源。
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // 设置行高
//    self.tableView.rowHeight = 90;
    self.tableView.allowsSelection = NO; // We essentially implement our own selection
    // 导航条标题
    self.navigationItem.title = @"Pull to Toggle Cell Type";
    
    // Setup refresh control for example app
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(toggleCells:) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [UIColor blueColor];
    
//    self.tableView.frame = self.view.bounds;
//    CGRect rect = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height+50);
//    self.view.backgroundColor = [UIColor greenColor];
//    self.tableView.frame = rect;
//    UIImageView *img = [[UIImageView alloc]init];
//    img.frame = self.view.bounds;
//    img.backgroundColor = [UIColor blueColor];
    [self.tableView addSubview:refreshControl];
//    [self.view addSubview:img];
    self.refreshControl = refreshControl;
//    [self.tableView removeFromSuperview];
    
    // If you set the seperator inset on iOS 6 you get a NSInvalidArgumentException...weird
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0); // Makes the horizontal row seperator stretch the entire length of the table view
    }
    
// ======================= 初始化数据 =================
    // 改为只有1个section
//    _sections = [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
//    _sections = [[NSMutableArray alloc] init];
    
    _testArray = [[NSMutableArray alloc] init];
    
//    self.useCustomCells = NO;
    self.useCustomCells = YES;
    
    for (int i = 0; i < 1; ++i) {
        [_testArray addObject:[NSMutableArray array]];
    }
    
    for (int i = 0; i < 100; ++i) {
        NSString *string = [NSString stringWithFormat:@"%d", i];
        [_testArray[0] addObject:string];
    }

}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _testArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_testArray[section] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cell selected at index path %d:%d", indexPath.section, indexPath.row);
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return _sections[section];
//}

// Show index titles

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
//}

#pragma mark - UIRefreshControl Selector

- (void)toggleCells:(UIRefreshControl*)refreshControl
{
    // 开始刷新
    [refreshControl beginRefreshing];
    // 刷新一次，变换一次显示类型
//    self.useCustomCells = !self.useCustomCells;
    // 根据不同情况，选择不同的菊花颜色
    if (self.useCustomCells)
    {
        self.refreshControl.tintColor = [UIColor blueColor];
    }
    else
    {
        self.refreshControl.tintColor = [UIColor yellowColor];
    }
    
    // 重新加载数据
    [self.tableView reloadData];
    // 结束显示刷新状态
    [refreshControl endRefreshing];
}

#pragma mark - UIScrollViewDelegate

///*
// This makes it so cells will not scroll sideways when the table view is scrolling.
// */
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [SWTableViewCell setContainingTableViewIsScrolling:YES];
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    [SWTableViewCell setContainingTableViewIsScrolling:NO];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.useCustomCells)
    {
        ACMessageTableViewCell *cell;
//        cell = [self.tableView dequeueReusableCellWithIdentifier:@"ACMessageTableViewCell" forIndexPath:indexPath];
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"ACMessageTableViewCell"];
        if(cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ACMessageTableViewCell" owner:self options:nil] lastObject];
            [tableView registerNib:[UINib nibWithNibName:@"ACMessageTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ACMessageTableViewCell"];
        }
        
        [cell setCellHeight:cell.frame.size.height];
        cell.containingTableView = tableView;
//        cell.label.text = [NSString stringWithFormat:@"Section: %d, Seat: %d", indexPath.section, indexPath.row];
        
        cell.label.text = @"a";
        cell.leftUtilityButtons = [self leftButtons];
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
        
        return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"Cell";
        
        SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
           cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:cellIdentifier
                                      containingTableView:_tableView // Used for row height and selection
                                      leftUtilityButtons:[self leftButtons]
                                      rightUtilityButtons:[self rightButtons]];
            cell.delegate = self;
        }
        NSDate *dateObject = _testArray[indexPath.section][indexPath.row];
        
        cell.textLabel.text = [dateObject description];
        cell.textLabel.backgroundColor = [UIColor whiteColor];
        cell.detailTextLabel.backgroundColor = [UIColor whiteColor];
        cell.detailTextLabel.text = @"Some detail text";
        
        return cell;
    }
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"More"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                                icon:[UIImage imageNamed:@"check.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:1.0]
                                                icon:[UIImage imageNamed:@"clock.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0]
                                                icon:[UIImage imageNamed:@"cross.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.55f green:0.27f blue:0.07f alpha:1.0]
                                                icon:[UIImage imageNamed:@"list.png"]];
    
    return leftUtilityButtons;
}

// Set row height on an individual basis

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return [self rowHeightForIndexPath:indexPath];
//}
//
//- (CGFloat)rowHeightForIndexPath:(NSIndexPath *)indexPath {
//    return ([indexPath row] * 10) + 60;
//}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Set background color of cell here if you don't want default white
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            NSLog(@"left button 0 was pressed");
            break;
        case 1:
            NSLog(@"left button 1 was pressed");
            break;
        case 2:
            NSLog(@"left button 2 was pressed");
            break;
        case 3:
            NSLog(@"left btton 3 was pressed");
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            NSLog(@"More button was pressed");
            UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"More more more" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
            [alertTest show];
            
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            [_testArray[cellIndexPath.section] removeObjectAtIndex:cellIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)test:(UIButton *)sender {
    NSLog(@"test button.");
    YTKChainRequest *chainrq = [[YTKChainRequest alloc]init];
    ACLiveAPI *liveapi = [[ACLiveAPI alloc]init];
    liveapi.methodName = @"getMyWatchRecords";
    ACUserInfo *userinfo = [[ACUserInfo alloc]init];
    [liveapi setDataModel:userinfo];
    CCParams *param_userinfo = [[CCParams alloc]init];
    [param_userinfo addParam:@"" forKey:@"token"];
//    [liveapi addArgument:<#(id)#> forKey:<#(NSString *)#>]
    
}


- (void)chainRequestFinished:(YTKChainRequest *)chainRequest returnedBaseRequest:(YTKBaseRequest*)request andDataModel:(id)model{
    
}

- (void)chainRequestFinishedWithError:(YTKChainRequest *)chainRequest returnedBaseRequest:(YTKBaseRequest*)request andError:(NSDictionary*)error{
    
}

- (void)chainRequestFailed:(YTKChainRequest *)chainRequest failedBaseRequest:(YTKBaseRequest*)request{
    
}



@end
