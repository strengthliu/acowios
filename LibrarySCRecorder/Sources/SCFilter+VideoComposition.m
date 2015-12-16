//
//  SCFilter+VideoComposition.m
//  SCRecorder
//
//  Created by Simon Corsin on 10/17/15.
//  Copyright © 2015 rFlex. All rights reserved.
//

#import "SCFilter+VideoComposition.h"

@implementation SCFilter (VideoComposition)


/**
 *  视频合并
 *
 *  @param asset AVAsset是定时的视听媒体，它可以是视频、影片、歌曲、播客节目；可以是本地或者远程的；也可以是限定或者非限定的流
 *
 *  @return <#return value description#>
 */
- (AVMutableVideoComposition *)videoCompositionWithAsset:(AVAsset *)asset {
    if ([[AVVideoComposition class] respondsToSelector:@selector(videoCompositionWithAsset:applyingCIFiltersWithHandler:)]) {
        CIContext *context = [CIContext contextWithOptions:@{kCIContextWorkingColorSpace : [NSNull null], kCIContextOutputColorSpace : [NSNull null]}];
        return [AVMutableVideoComposition videoCompositionWithAsset:asset applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest * _Nonnull request) {
            CIImage *image = [self imageByProcessingImage:request.sourceImage atTime:CMTimeGetSeconds(request.compositionTime)];

            [request finishWithImage:image context:context];
        }];

    }
    return nil;
}

@end
