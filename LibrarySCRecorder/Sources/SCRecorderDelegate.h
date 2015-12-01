//
//  SCRecorderDelegate.h
//  SCRecorder
//
//  Created by Simon CORSIN on 18/03/15.
//  Copyright (c) 2015 rFlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "SCRecorder.h"

typedef NS_ENUM(NSInteger, SCFlashMode) {
    SCFlashModeOff  = AVCaptureFlashModeOff,
    SCFlashModeOn   = AVCaptureFlashModeOn,
    SCFlashModeAuto = AVCaptureFlashModeAuto,
    SCFlashModeLight
};

@class SCRecorder;

@protocol SCRecorderDelegate <NSObject>

@optional

/**
 Called when the recorder has reconfigured the videoInput
 recorder重新配置视频输入设备时将被调用
 */
- (void)recorder:(SCRecorder *__nonnull)recorder didReconfigureVideoInput:(NSError *__nullable)videoInputError;

/**
 Called when the recorder has reconfigured the audioInput
 recorder重新配置音频输入设备时将被调用
 */
- (void)recorder:(SCRecorder *__nonnull)recorder didReconfigureAudioInput:(NSError *__nullable)audioInputError;

/**
 Called when the flashMode has changed
 闪光灯模式修改时被调用
 */
- (void)recorder:(SCRecorder *__nonnull)recorder didChangeFlashMode:(SCFlashMode)flashMode error:(NSError *__nullable)error;

/**
 Called when the recorder has lost the focus. Returning true will make the recorder
 automatically refocus at the center.
 recorder失去焦点时被调用。如果返回true，将使recorder自动聚焦到中心。
 */
- (BOOL)recorderShouldAutomaticallyRefocus:(SCRecorder *__nonnull)recorder;

/**
 Called before the recorder will start focusing
 recorder聚焦前被调用
 */
- (void)recorderWillStartFocus:(SCRecorder *__nonnull)recorder;

/**
 Called when the recorder has started focusing
 recorder开始聚焦时被调用
 */
- (void)recorderDidStartFocus:(SCRecorder *__nonnull)recorder;

/**
 Called when the recorder has finished focusing
 recorder聚焦结束时被调用
 */
- (void)recorderDidEndFocus:(SCRecorder *__nonnull)recorder;

/**
 Called before the recorder will start adjusting exposure
 recorder将开始调整曝光度时被调用
 */
- (void)recorderWillStartAdjustingExposure:(SCRecorder *__nonnull)recorder;

/**
 Called when the recorder has started adjusting exposure
 recorder已经开始调整曝光度时被调用
 */
- (void)recorderDidStartAdjustingExposure:(SCRecorder *__nonnull)recorder;

/**
 Called when the recorder has finished adjusting exposure
 recorder结束调整曝光度时被调用
 */
- (void)recorderDidEndAdjustingExposure:(SCRecorder *__nonnull)recorder;

/**
 Called when the recorder has initialized the audio in a session
 在一个session中，已经初始化音频时被调用
 */
- (void)recorder:(SCRecorder *__nonnull)recorder didInitializeAudioInSession:(SCRecordSession *__nonnull)session error:(NSError *__nullable)error;

/**
 Called when the recorder has initialized the video in a session
 在一个session中，已经初始化视频时被调用
 */
- (void)recorder:(SCRecorder *__nonnull)recorder didInitializeVideoInSession:(SCRecordSession *__nonnull)session error:(NSError *__nullable)error;

/**
 Called when the recorder has started a segment in a session
 在一全session中，recorder开始了一个段时，被调用
 */
- (void)recorder:(SCRecorder *__nonnull)recorder didBeginSegmentInSession:(SCRecordSession *__nonnull)session error:(NSError *__nullable)error;

/**
 Called when the recorder has completed a segment in a session
 在一全session中，recorder结束一个段时，被调用
 */
- (void)recorder:(SCRecorder *__nonnull)recorder didCompleteSegment:(SCRecordSessionSegment *__nullable)segment inSession:(SCRecordSession *__nonnull)session error:(NSError *__nullable)error;

/**
 Called when the recorder has appended a video buffer in a session
 在一个session中，recorder向视频缓冲区增加sample时，被调用。
 */
- (void)recorder:(SCRecorder *__nonnull)recorder didAppendVideoSampleBufferInSession:(SCRecordSession *__nonnull)session;

/**
 Called when the recorder has appended an audio buffer in a session
 */
- (void)recorder:(SCRecorder *__nonnull)recorder didAppendAudioSampleBufferInSession:(SCRecordSession *__nonnull)session;

/**
 Called when the recorder has skipped an audio buffer in a session
 */
- (void)recorder:(SCRecorder *__nonnull)recorder didSkipAudioSampleBufferInSession:(SCRecordSession *__nonnull)session;

/**
 Called when the recorder has skipped a video buffer in a session
 */
- (void)recorder:(SCRecorder *__nonnull)recorder didSkipVideoSampleBufferInSession:(SCRecordSession *__nonnull)session;

/**
 Called when a session has reached the maxRecordDuration
 */
- (void)recorder:(SCRecorder *__nonnull)recorder didCompleteSession:(SCRecordSession *__nonnull)session;

/**
 Gives an opportunity to the delegate to create an info dictionary for a record segment.
 */
- (NSDictionary *__nullable)createSegmentInfoForRecorder:(SCRecorder *__nonnull)recorder;

@end
