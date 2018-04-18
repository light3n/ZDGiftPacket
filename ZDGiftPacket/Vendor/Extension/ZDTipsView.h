//
//  ZDTipsView.h
//  ZhiDao
//
//  Created by Joey on 2017/5/26.
//  Copyright © 2017年 ZhiDao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDTipsView : UIView

@property(nonatomic, copy) NSString *text;

- (instancetype)initWithText:(NSString *)text;
+ (instancetype)tipsViewWithText:(NSString *)text;

// convenient method
+ (instancetype)showUseLimitTip;

@end
