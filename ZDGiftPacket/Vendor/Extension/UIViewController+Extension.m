//
//  UIViewController+Extension.m
//  ZDGiftPacket
//
//  Created by Joey on 2018/2/24.
//  Copyright © 2018年 ZhiDao. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

- (void)dismiss {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
