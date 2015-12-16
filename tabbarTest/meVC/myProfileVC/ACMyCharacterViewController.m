//
//  ACMyCharacterViewController.m
//  tabbarTest
//
//  Created by lucifer on 15/11/16.
//  Copyright © 2015年 Kevin. All rights reserved.
//

#import "ACMyCharacterViewController.h"
#import "ACDrawFaceFilter.h"

@interface ACMyCharacterViewController () {
    SCRecorder *_recorder;
    UIImage *_photo;
    SCRecordSession *_recordSession;
    UIImageView *_ghostImageView; // 叠在previewView上，是录制前视频显示视图。previewView是SCRecorder的显示视图。都是UIView。
    
}
- (IBAction)returnToMe:(UIButton *)sender;


@end

@implementation ACMyCharacterViewController

- (void)dealloc {
    _recorder.previewView = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_recorder startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_recorder stopRunning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  显示加载进度条
     */
    //random color
    CGFloat red =  arc4random_uniform(256)/255.f;
    CGFloat blue = arc4random_uniform(256)/255.f;
    CGFloat green = arc4random_uniform(256)/255.f;
    CGColorRef color = CGColorRetain([UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor);
    [[[MMProgressHUD sharedHUD] overlayView] setOverlayColor:color];
    CGColorRelease(color);
    [MMProgressHUD showWithTitle:@"初始化设备" status:@"开始初始化..."];
    [MMProgressHUD showWithTitle:@"初始化设备" status:@"初始化中..."];

    /**
     *  检查相机权限
     */
    [self checkRight];

//    // Do any additional setup after loading the view from its nib.
//            _ghostImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//            _ghostImageView.contentMode = UIViewContentModeScaleAspectFill;
//            _ghostImageView.alpha = 0.2;
//            _ghostImageView.userInteractionEnabled = NO;
//            _ghostImageView.hidden = YES;
    
    // 创建recorder
    _recorder = [SCRecorder recorder];
    _recorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetCompatibleWithAllDevices];
    //    _recorder.maxRecordDuration = CMTimeMake(10, 1);
    //    _recorder.fastRecordMethodEnabled = YES;

    // 设置session
    
    // 设置output
    
    _recorder.delegate = self;
    _recorder.autoSetVideoOrientation = YES;

    /**
     *  设置过滤器
     */
    if ([[NSProcessInfo processInfo] activeProcessorCount] > 1) {
        self.scimageView.contentMode = UIViewContentModeScaleAspectFill;
        
//        SCFilter *emptyFilter = [SCFilter emptyFilter];
//        emptyFilter.name = @"#nofilter";
//        self.scimageView.filter = emptyFilter;
        
        ACDrawFaceFilter *acDrawFaceFilter = [[ACDrawFaceFilter alloc]init];
        acDrawFaceFilter.delegate = acDrawFaceFilter;
    
        self.scimageView.filter = acDrawFaceFilter;
    }
//    SCFilterImageView *scimageview = self.scimageView;
//    SCFilter *filter = [[SCFilter alloc]init];
//    [self.scimageView setFilter:[self createAnimatedFilter]];
//    [scimageview setFilter:filter];
    //
    _recorder.SCImageView = self.scimageView;
    
    UIView *previewView = self.previewView;
    _recorder.previewView = previewView;
    //
    //        [self.retakeButton addTarget:self action:@selector(handleRetakeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    //        [self.stopButton addTarget:self action:@selector(handleStopButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    //        [self.reverseCamera addTarget:self action:@selector(handleReverseCameraTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // 为按下开始录像按钮添加侦听。
    [self.recorderView addGestureRecognizer:[[SCTouchDetector alloc] initWithTarget:self action:@selector(handleTouchDetected:)]];
    
    //********************** 进度条结束 **************
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [MMProgressHUD dismissWithSuccess:@"Success!"];
    });


    
    self.focusView = [[SCRecorderToolsView alloc] initWithFrame:previewView.bounds];
    self.focusView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    self.focusView.recorder = _recorder;
    [previewView addSubview:self.focusView];
    
    self.focusView.outsideFocusTargetImage = [UIImage imageNamed:@"capture_flip"];
    self.focusView.insideFocusTargetImage = [UIImage imageNamed:@"capture_flip"];
    
    _recorder.initializeSessionLazily = NO;
    
    NSError *error;
    if (![_recorder prepare:&error]) {
        NSLog(@"Prepare error: %@", error.localizedDescription);
    }
    
    //    _recorder.videoPreviewImage = self.mPreView;
    //    UIImage *img = [UIImage imageNamed:@"Play-Pressed-icon.png"];
    //    self.mPreView.image = img;
}

- (SCFilter *)createAnimatedFilter {
    SCFilter *animatedFilter = [SCFilter emptyFilter];
    animatedFilter.name = @"Animated Filter";
    
    SCFilter *gaussian = [SCFilter filterWithCIFilterName:@"CIGaussianBlur"];
    
    SCFilter *blackAndWhite = [SCFilter filterWithCIFilterName:@"CIColorControls"];
    
    [animatedFilter addSubFilter:gaussian];
    [animatedFilter addSubFilter:blackAndWhite];
    
    double duration = 0.5;
    double currentTime = 0;
    BOOL isAscending = YES;
    
    Float64 assetDuration = CMTimeGetSeconds(_recordSession.assetRepresentingSegments.duration);
    
    while (currentTime < assetDuration) {
        if (isAscending) {
            [blackAndWhite addAnimationForParameterKey:kCIInputSaturationKey startValue:@1 endValue:@0 startTime:currentTime duration:duration];
            [gaussian addAnimationForParameterKey:kCIInputRadiusKey startValue:@0 endValue:@10 startTime:currentTime duration:duration];
        } else {
            [blackAndWhite addAnimationForParameterKey:kCIInputSaturationKey startValue:@0 endValue:@1 startTime:currentTime duration:duration];
            [gaussian addAnimationForParameterKey:kCIInputRadiusKey startValue:@10 endValue:@0 startTime:currentTime duration:duration];
        }
        
        currentTime += duration;
        isAscending = !isAscending;
    }
    
    return animatedFilter;
}

- (BOOL)checkRight{
    // 获取相机访问权限状况
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    // 判断用户的权限
    if(authStatus == AVAuthorizationStatusAuthorized)
    {
        NSLog(@"允许状态");
    }
    else if (authStatus == AVAuthorizationStatusDenied)
    {
        NSLog(@"不允许状态，可以弹出一个alertview提示用户在隐私设置中开启权限");
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            NSLog(@"111");
        }];
    }
    else if (authStatus == AVAuthorizationStatusNotDetermined)
    {
        NSLog(@"系统还未知是否访问，第一次开启相机时");
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            NSLog(@"111");
        }];
        
    }

    return true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)returnToMe:(UIButton *)sender {
    NSLog(@"returnToMe clicked. ");
    [self.view removeFromSuperview];
}

// 按下开始录像
- (void)handleTouchDetected:(SCTouchDetector*)touchDetector {
    NSLog(@"handleTouchDetected");
    if (touchDetector.state == UIGestureRecognizerStateBegan) {
//        _ghostImageView.hidden = YES;
        [_recorder record];
    } else if (touchDetector.state == UIGestureRecognizerStateEnded) {
        [_recorder pause];
    }
}

//
- (void)showVideo {
    [self performSegueWithIdentifier:@"Video" sender:self];
}

- (void)prepareSession {
    if (_recorder.session == nil) {
        
        SCRecordSession *session = [SCRecordSession recordSession];
        session.fileType = AVFileTypeQuickTimeMovie;
        
        _recorder.session = session;
    }
    
    [self updateTimeRecordedLabel];
//    [self updateGhostImage];
}

- (void)recorder:(SCRecorder *)recorder didCompleteSession:(SCRecordSession *)recordSession {
    NSLog(@"didCompleteSession:");
    [self saveAndShowSession:recordSession];
}

- (void)saveAndShowSession:(SCRecordSession *)recordSession {
    [[SCRecordSessionManager sharedInstance] saveRecordSession:recordSession];
    
    _recordSession = recordSession;
    [self showVideo];
}

- (void)recorder:(SCRecorder *)recorder didInitializeAudioInSession:(SCRecordSession *)recordSession error:(NSError *)error {
    if (error == nil) {
        NSLog(@"Initialized audio in record session");
    } else {
        NSLog(@"Failed to initialize audio in record session: %@", error.localizedDescription);
    }
}

- (void)recorder:(SCRecorder *)recorder didInitializeVideoInSession:(SCRecordSession *)recordSession error:(NSError *)error {
    if (error == nil) {
        NSLog(@"Initialized video in record session");
    } else {
        NSLog(@"Failed to initialize video in record session: %@", error.localizedDescription);
    }
}

- (void)recorder:(SCRecorder *)recorder didBeginSegmentInSession:(SCRecordSession *)recordSession error:(NSError *)error {
    NSLog(@"Began record segment: %@", error);
}

- (void)recorder:(SCRecorder *)recorder didCompleteSegment:(SCRecordSessionSegment *)segment inSession:(SCRecordSession *)recordSession error:(NSError *)error {
    NSLog(@"Completed record segment at %@: %@ (frameRate: %f)", segment.url, error, segment.frameRate);
//    [self updateGhostImage];
}

//- (void)updateGhostImage {
//    UIImage *image = nil;
//    
//    if (_ghostModeButton.selected) {
//        if (_recorder.session.segments.count > 0) {
//            SCRecordSessionSegment *segment = [_recorder.session.segments lastObject];
//            image = segment.lastImage;
//        }
//    }
//    
//    
//    _ghostImageView.image = image;
//    //    _ghostImageView.image = [_recorder snapshotOfLastAppendedVideoBuffer];
//    _ghostImageView.hidden = !_ghostModeButton.selected;
//}

- (void)updateTimeRecordedLabel {
    CMTime currentTime = kCMTimeZero;
    
    if (_recorder.session != nil) {
        currentTime = _recorder.session.duration;
    }
    
    self.timeRecordedLabel.text = [NSString stringWithFormat:@"%.2f sec", CMTimeGetSeconds(currentTime)];
}

- (void)recorder:(SCRecorder *)recorder didAppendVideoSampleBufferInSession:(SCRecordSession *)recordSession {
    [self updateTimeRecordedLabel];
}

@end
