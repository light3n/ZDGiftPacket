//
//  TouchableImageView.h
//  LightBlog
//
//  Created by xj guo on 11-12-13.
//  Copyright (c) 2011年 51.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TouchableImageViewDelegate <NSObject>

-(void)xLoctionDidChanged;

@end

@interface TouchableImageView : UIImageView <UIGestureRecognizerDelegate> {
}

@property (nonatomic,assign) BOOL handleTouchEvent;
@property (nonatomic,assign) NSUInteger motiveStyle; // 0 for all,1 for lock y pos
@property (nonatomic,weak) id<TouchableImageViewDelegate> motionDelegate;
@property (nonatomic,assign) NSUInteger lockStyle; //0 for no lock,1 for lock height,2 for lock width
@end

