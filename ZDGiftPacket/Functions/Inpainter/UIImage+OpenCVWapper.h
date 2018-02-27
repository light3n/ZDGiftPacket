//
//  UIImage+OpenCVWapper.h
//  InpaintDemo
//
//  Created by Joey on 2017/12/13.
//  Copyright © 2017年 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (OpenCVWapper)

+ (cv::Mat)cvMatFromUIImage:(UIImage *)image;
+ (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image;
+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;

+ (UIImage *)inpaintImage:(UIImage *)srcImage
                maskImage:(UIImage *)maskImage
             inpaintRange:(double)range;

@end
