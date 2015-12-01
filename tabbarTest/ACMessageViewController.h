//
//  FirstViewController.h
//  tabbarTest
//
//  Created by Kevin Lee on 13-5-6.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTKChainRequest.h"
#import "UMTableViewCell.h"

@interface ACMessageViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate,YTKChainRequestDelegate>
- (IBAction)test:(UIButton *)sender;

@end
