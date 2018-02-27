//
//  MovableButton.m
//  InJa
//
//  Created by Orville on 14-2-13.
//  Copyright (c) 2014年 Orville. All rights reserved.
//

#import "MovableButton.h"

@implementation MovableButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code        
        UIPanGestureRecognizer *pangr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pangr];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        UIPanGestureRecognizer *pangr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pangr];
    }
    return self;
}

- (void)pan:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateChanged ||
        recognizer.state == UIGestureRecognizerStateEnded) {
        
        UIView *draggedButton = recognizer.view;
        CGPoint translation = [recognizer translationInView:self.superview];
//        CGRect newButtonFrame = draggedButton.frame;
//        newButtonFrame.origin.x += translation.x;
//        newButtonFrame.origin.y += translation.y;
//        draggedButton.frame = newButtonFrame;
        draggedButton.frame = CGRectOffset(draggedButton.frame, translation.x, translation.y);
        
        [recognizer setTranslation:CGPointZero inView:self.superview];
    }
}

////手指按下开始触摸
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    //获得触摸在按钮的父视图中的坐标
//    UITouch *touch = [touches anyObject];
//    CGPoint currentPoint = [touch locationInView:self.superview];
//    
//    xDistance =  self.center.x - currentPoint.x;
//    yDistance = self.center.y - currentPoint.y;
//    
//}
////手指按住移动过程
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if (xDistance+yDistance>5) {
//        isDrag = YES;
//    }
//    
//    if(isDrag)
//    {
//        //获得触摸在按钮的父视图中的坐标
//        UITouch *touch = [touches anyObject];
//        CGPoint currentPoint = [touch locationInView:self.superview];
//        
//        //移动按钮到当前触摸位置
//        CGPoint newCenter = CGPointMake(currentPoint.x + xDistance, currentPoint.y + yDistance);
//        self.center = newCenter;
//    }
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    isDrag = NO;
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    isDrag = NO;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
