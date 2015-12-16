//
//  ACMessageTableViewCell.h
//  actest
//
//  Created by lucifer on 15/12/15.
//  Copyright © 2015年 liuqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface ACMessageTableViewCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
