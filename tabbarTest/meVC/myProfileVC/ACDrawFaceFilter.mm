//
//  ACDrawFaceFilter.m
//  actest
//
//  Created by lucifer on 15/12/6.
//  Copyright © 2015年 liuqiang. All rights reserved.
//

#import "ACDrawFaceFilter.h"
#import "ACImageConverter.h"
#import <opencv2/opencv.hpp>

using namespace cv;
using namespace std;

@implementation ACDrawFaceFilter
/**
 Called when a parameter changed from the SCFilter instance.
 */
- (void)filter:(SCFilter *__nonnull)filter didChangeParameter:(NSString *__nonnull)parameterKey {
    
}

/**
 Called before the filter start processing an image.
 */
- (void)filter:(SCFilter *__nonnull)filter willProcessImage:(CIImage *__nullable)image atTime:(CFTimeInterval)time {
//    NSLog(@"");
//    UIImage *img = [ACImageConverter cIImagetoUIImage:image];
//    Mat mat = [ACImageConverter cvMatFromUIImage:img];
//    cv::Point *p1 = new cv::Point(10,10);
//    cv::Point *p2 = new cv::Point(50,50);
//    cv::rectangle(mat, *p1, *p2, cv::Scalar(0,0));
//    img = [ACImageConverter UIImageFromCVMat:mat];
//    image = [ACImageConverter uIImagetoCIImage:img];
#warning 需要释放内存。擦，不光是这里，图像转换也有问题。
//    mat.release();
//    free(p1);
//    free(p2);
//    free(&mat);
//    img = nil;
    image = [[CIImage alloc]init];
}

/**
 Called when the parameter values has been reset to defaults.
 */
- (void)filterDidResetToDefaults:(SCFilter *__nonnull)filter {
    
}

@end
