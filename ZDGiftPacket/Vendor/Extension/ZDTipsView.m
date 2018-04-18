//
//  ZDTipsView.m
//  ZhiDao
//
//  Created by Joey on 2017/5/26.
//  Copyright © 2017年 ZhiDao. All rights reserved.
//

#import "ZDTipsView.h"

@interface ZDTipsView ()
@property(nonatomic, weak) UILabel *label;
@end

@implementation ZDTipsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *bgView = [[UIImageView alloc] init];
        bgView.image = [UIImage imageNamed:@"tips_view_bg"];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.font = [UIFont boldSystemFontOfSize:18];
        label.textColor = UIColorBlack;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"提示";
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(260*SCREEN_RATE, 200*SCREEN_RATE));
        }];
        _label = label;
        
        UIButton *dismissButton = [[UIButton alloc] init];
        [dismissButton setImage:[UIImage imageNamed:@"Shopping_button_delete"] forState:UIControlStateNormal];
        [dismissButton addTarget:self action:@selector(handleDismissButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:dismissButton];
        [dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-30*SCREEN_RATE);
            make.size.mas_equalTo(CGSizeMake(40*SCREEN_RATE, 40*SCREEN_RATE));
        }];
        
    }
    return self;
}

- (instancetype)initWithText:(NSString *)text {
    for (id subview in KEY_WINDOW.subviews) {
        if ([subview isKindOfClass:[ZDTipsView class]]) {
            [subview removeFromSuperview];
        }
    }
    ZDTipsView *view = [[ZDTipsView alloc] initWithFrame:CGRectMake(0, 0, 400*SCREEN_RATE, 375*SCREEN_RATE)];
    view.center = KEY_WINDOW.center;
    view.text = text;
    [KEY_WINDOW addSubview:view];
    return view;
}

+ (instancetype)tipsViewWithText:(NSString *)text {
    return [[ZDTipsView alloc] initWithText:text];
}

#pragma mark - Button Event Handle
- (void)handleDismissButtonClickEvent {
    [self removeFromSuperview];
}

#pragma mark - Lazy Initialize
- (void)setText:(NSString *)text {
    _text = text;
    _label.text = text;
}


// convenient method
+ (instancetype)showUseLimitTip {
    return [self tipsViewWithText:@"您正在使用的是智能工具箱试用版, 如需要使用更多功能请联系您的销售经理或客服。"];
}



@end
