//
//  ACMyCharacterViewController.h
//  tabbarTest
//
//  Created by lucifer on 15/11/16.
//  Copyright © 2015年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SCRecorderFramework.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SCTouchDetector.h"
#import "SCRecorder/SCRecorderDelegate.h"
#import "SCRecorder/SCImageView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SCRecordSessionManager.h"
#import <MobileCoreServices/MobileCoreServices.h>

#import <MMProgressHUD/MMProgressHUD.h>
#import <MMProgressHUD/MMProgressHUDOverlayView.h>
#import <MMProgressHUD/MMRadialProgressView.h>
#import <MMProgressHUD/MMLinearProgressView.h>

@interface ACMyCharacterViewController : UIViewController <SCRecorderDelegate>

@property (weak, nonatomic) IBOutlet UIButton *recorderView;

@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (weak, nonatomic) IBOutlet SCFilterImageView *scimageView;
@property (strong, nonatomic) SCRecorderToolsView *focusView;

@property (weak, nonatomic) IBOutlet UILabel *timeRecordedLabel;
- (BOOL)checkRight;
@end
