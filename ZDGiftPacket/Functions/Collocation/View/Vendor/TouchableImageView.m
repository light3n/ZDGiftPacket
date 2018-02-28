//
//  TouchableImageView.m
//  LightBlog
//
//  Created by xj guo on 11-12-13.
//  Copyright (c) 2011年 51.com. All rights reserved.
//

#import "TouchableImageView.h"
#import <QuartzCore/QuartzCore.h>
@implementation TouchableImageView

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

- (void)panPiece:(UIPanGestureRecognizer *)gestureRecognizer {
    
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ((gestureRecognizer.state == UIGestureRecognizerStateChanged) ||
        (gestureRecognizer.state == UIGestureRecognizerStateEnded)) {
        CGPoint location = [gestureRecognizer locationInView:[self superview]];
        if (self.motiveStyle == 0) {
            self.center = location;
        } else if (self.motiveStyle == 1) {
            self.center = CGPointMake(location.x, self.center.y);
            if (self.motionDelegate) {
                NSLog(@"preloc=%@,newloc=%@",[[NSNumber numberWithFloat:self.center.x] description],[[NSNumber numberWithFloat:self.center.x] description]);
                [self.motionDelegate performSelector:@selector(xLoctionDidChanged)];
            }
        }
        // limit location from superview
        CGRect limitRect = self.frame;
        if (self.frame.origin.x < 0) {
            limitRect.origin.x = 0;
        }
        if (self.frame.origin.y < 0) {
            limitRect.origin.y = 0;
        }
        if (CGRectGetMaxX(self.frame) > CGRectGetWidth(self.superview.frame)) {
            limitRect.origin.x = CGRectGetWidth(self.superview.frame) - CGRectGetWidth(self.frame);
        }
        if (CGRectGetMaxY(self.frame) > CGRectGetHeight(self.superview.frame)) {
            limitRect.origin.y = CGRectGetHeight(self.superview.frame) - CGRectGetHeight(self.frame);
        }
        self.frame = limitRect;
    }
}

- (void)rotatePiece:(UIRotationGestureRecognizer *)gestureRecognizer {
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [gestureRecognizer view].transform = CGAffineTransformRotate([[gestureRecognizer view] transform], [gestureRecognizer rotation]);
        [gestureRecognizer setRotation:0];
    }
}
- (void)scalePiece:(UIPinchGestureRecognizer *)gestureRecognizer {
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGFloat scale = [gestureRecognizer scale];
        
        [gestureRecognizer setScale:1];
        if (self.lockStyle == 0) {
            [gestureRecognizer view].transform = CGAffineTransformScale([[gestureRecognizer view] transform], scale, scale);
        } else if (self.lockStyle == 1) {
            [gestureRecognizer view].transform = CGAffineTransformScale([[gestureRecognizer view] transform], scale, 1);
        } else if (self.lockStyle == 2) {
            [gestureRecognizer view].transform = CGAffineTransformScale([[gestureRecognizer view] transform], 1, scale);
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // if the gesture recognizers are on different views, don't allow simultaneous recognition
    if (gestureRecognizer.view != otherGestureRecognizer.view)
        return NO;
    // if either of the gesture recognizers is the long press, don't allow simultaneous recognition
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] || [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
        return NO;
    return YES;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
        [panRecognizer setMinimumNumberOfTouches:1];
        [panRecognizer setMaximumNumberOfTouches:1];
        [panRecognizer setDelegate:self];
        [self addGestureRecognizer:panRecognizer];
#if 0
        UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotatePiece:)];
        [rotationRecognizer setDelegate:self];
        [self addGestureRecognizer:rotationRecognizer];
#endif
        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scalePiece:)];
        [pinchRecognizer setDelegate:self];
        [self addGestureRecognizer:pinchRecognizer];
        
        self.handleTouchEvent = YES;
        self.motiveStyle = 0; //0 for all,1 for lock width
        self.lockStyle = 0;
    }
    return self;
}

@end
