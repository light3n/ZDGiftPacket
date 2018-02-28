//
//  ZDMovableView.m
//  ZDGiftPacket
//
//  Created by Joey on 2018/2/26.
//  Copyright © 2018年 ZhiDao. All rights reserved.
//

#import "ZDMovableView.h"

@implementation ZDMovableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self addGestureRecognizer:panGes];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self addGestureRecognizer:panGes];
    }
    return self;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged ||
        recognizer.state == UIGestureRecognizerStateEnded) {
        UIView *draggingView = recognizer.view;
        CGPoint translation = [recognizer translationInView:self.superview];
        draggingView.frame = CGRectOffset(draggingView.frame, translation.x, translation.y);
        [recognizer setTranslation:CGPointZero inView:self.superview];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
//        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
//        layer
    }
    return view;
}

@end
