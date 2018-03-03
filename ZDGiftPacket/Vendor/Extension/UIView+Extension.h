//
//  UIView+Extension.h
//  ZhiDao
//
//  Created by Joey on 2016/11/21.
//  Copyright © 2016年 ZhiDao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

+ (UIImage *)snapshot:(UIView *)aView;

// iPhone 6 和 iPhone 6 Plus 屏幕适配
CGRect CGRectMake_Adaption(CGFloat x, CGFloat y, CGFloat width, CGFloat height);

@end
