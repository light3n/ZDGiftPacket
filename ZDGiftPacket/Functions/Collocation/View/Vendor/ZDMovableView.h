//
//  ZDMovableView.h
//  ZDGiftPacket
//
//  Created by Joey on 2018/2/26.
//  Copyright © 2018年 ZhiDao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDMovableView : UIView

@property (nonatomic, assign, getter=isFocus) BOOL focus;

- (void)resignFocus;
- (void)cancelFocus;

@end

