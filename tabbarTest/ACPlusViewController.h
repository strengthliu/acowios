//
//  PlusViewController.h
//  tabbarTest
//  这是聊天页面的主控制器，主要控制聊天内容列表。
//  下面有三个子控制器，一个是录制聊天控制器，一个是修改、设置聊天控制器，
//  最后一个是查看聊天人员控制器。
//  Created by lucifer on 15/11/13.
//  Copyright © 2015年 liuqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCTouchDetector.h"
#import "SCRecorder/SCRecorderDelegate.h"
#import "SCRecorder/SCImageView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SCRecordSessionManager.h"
#import "SWTableViewCell.h"

@interface ACPlusViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *recordPreview;

/**
 *  聊天内容列表
 */
@property (weak, nonatomic) IBOutlet UITableView *scenesList;

@end
