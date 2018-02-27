//
//  UIImage+OpenCVWapper.m
//  InpaintDemo
//
//  Created by Joey on 2017/12/13.
//  Copyright © 2017年 Joey. All rights reserved.
//

#import "UIImage+OpenCVWapper.h"

@implementation UIImage (OpenCVWapper)


+ (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 3 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

+ (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image
{
//    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
//    CGFloat cols = image.size.width;
//    CGFloat rows = image.size.height;
//
//    cv::Mat cvMat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels
//
//    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to data
//                                                    cols,                       // Width of bitmap
//                                                    rows,                       // Height of bitmap
//                                                    8,                          // Bits per component
//                                                    cvMat.step[0],              // Bytes per row
//                                                    colorSpace,                 // Colorspace
//                                                    kCGImageAlphaNoneSkipLast |
//                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
//
//    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
//    CGContextRelease(contextRef);
//
//    return cvMat;
    
    cv::Mat cvMat = [self cvMatFromUIImage:image];
    cv::Mat grayMat;
    
    if (cvMat.channels() == 1) {
        grayMat = cvMat;
    } else{
        grayMat = cv :: Mat(cvMat.rows,cvMat.cols, CV_8UC1);
        cv::cvtColor(cvMat, grayMat, CV_BGR2GRAY);
    }
    return grayMat;
}

+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

+ (UIImage *)inpaintImage:(UIImage *)srcImage
                maskImage:(UIImage *)maskImage
             inpaintRange:(double)range {
    // convert 4 channel to 3 cannel
    cv::Mat src = [self cvMatFromUIImage:srcImage];
    cv::Mat bgrSrc;
    cv::cvtColor(src, bgrSrc, CV_RGB2BGR);

    cv::Mat mask = [self cvMatGrayFromUIImage:maskImage];
    cv::Mat bgrInpaintedImage;
    cv::inpaint(bgrSrc, mask, bgrInpaintedImage, range, CV_INPAINT_NS);
    // convert 3 channel to 4 cannel
    cv::Mat rgbInpaintedImage;
    cv::cvtColor(bgrInpaintedImage, rgbInpaintedImage, CV_BGR2RGB);
    
    return [self UIImageFromCVMat:rgbInpaintedImage];
}




@end


