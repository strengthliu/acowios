//
//  ACImageConverter.h
//  actest
//
//  Created by lucifer on 15/12/6.
//  Copyright © 2015年 liuqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <opencv2/opencv.hpp>

@interface ACImageConverter : NSObject

+ (UIImage*)cIImagetoUIImage:(CIImage*)cIImage;
+ (CIImage*)uIImagetoCIImage:(UIImage*)uIImage;

+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;
+ (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image;
+ (cv::Mat)cvMatFromUIImage:(UIImage *)image;
@end
