//
//  friendsViewController.h
//  tabbarTest
//
//  Created by lucifer on 15/11/14.
//  Copyright © 2015年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACViewController.h"
#import "SWTableViewCell.h"
#import "YTKChainRequest.h"
#import "ACFriendsTableViewCell.h"

@interface ACFriendsViewController : ACViewController<UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate,YTKChainRequestDelegate>

- (IBAction)test:(UIButton *)sender;
@end
