//
//  UIView+Extension.m
//  ZhiDao
//
//  Created by Joey on 2016/11/21.
//  Copyright © 2016年 ZhiDao. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

+ (UIImage *)snapshot:(UIView *)aView {
    // 把当前的整个画面导入到context中，然后通过context输出UIImage，这样就可以把view转化为图片
    UIGraphicsBeginImageContextWithOptions(aView.frame.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    // 参数：YES-代表视图的属性改变渲染完毕后截屏，NO-代表立刻将当前状态的视图截图
    [aView snapshotViewAfterScreenUpdates:YES];

    if( [aView respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        // 一般都调用这里
        [aView drawViewHierarchyInRect:aView.bounds afterScreenUpdates:YES];
    } else {
        [aView.layer renderInContext:context];
    }

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

CGRect CGRectMake_Adaption(CGFloat x, CGFloat y, CGFloat width, CGFloat height) {
    CGRect rect = CGRectZero;
    if (IS_IPHONE) { // iPhone
        if ([UIScreen mainScreen].bounds.size.height == 375) { //iPhone 6
            rect = CGRectMake(x, y, width, height);
        } else if ([UIScreen mainScreen].bounds.size.height == 414) { //iPhone 6 Plus
            CGFloat rate = 736 / 667.0;
            rect = CGRectMake(x * rate, y * rate, width * rate, height * rate);
        }
    } else { // iPad
        rect = CGRectMake(x, y, width, height);
    }
    return rect;
}

@end
