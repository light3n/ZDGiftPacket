//
// Author: Håvard Fossli <hfossli@agens.no>
//
// Copyright (c) 2013 Agens AS (http://agens.no/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QuadrilateralDesignView.h"


@class AGQuadControlsSample;


// 实景设计模式
typedef NS_ENUM(NSInteger, ZDDesignViewControllerDesignType) {
    ZDDesignViewControllerDesignTypeOrigin = 0, // 叠加设计（默认）
    ZDDesignViewControllerDesignTypeQuick = 1,  // 快速设计
};


@protocol CurtainLayerViewControllerDelegate <NSObject>
@required
-(void)tapOtherLayer:(CGPoint)point fromCurtainLayer:(AGQuadControlsSample*)layer;
@end

@interface AGQuadControlsSample : UIViewController <UIGestureRecognizerDelegate, QuadrilateralDesignViewDelegate> {
    int selectedState;
    IBOutlet UIImageView* qbImageView;
    BOOL noShowPoints;
}

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@property (nonatomic, weak) id<CurtainLayerViewControllerDelegate> delegate;

//@property (nonatomic, assign) iJADesignViewControllerSourceType type;
@property (nonatomic, assign) BOOL isFirstCurtainImage; // 是否为第一个窗帘贴图
@property (nonatomic, assign, getter=isLocked) BOOL lock; // 设计操作锁定
@property (nonatomic, assign) ZDDesignViewControllerDesignType designType; // 设计模式
@property (nonatomic, assign) int sampleIndex;

@property (nonatomic, strong) UIImage* curtainImage; // 窗帘图片
@property (nonatomic, strong) IBOutlet QuadrilateralDesignView* quadView; // 自定义的多边形

-(void)cleanup;

-(IBAction)backClick:(id)sender;
-(IBAction)selectPictureQB:(id)sender;
-(IBAction)selectPictureCL:(id)sender;

-(BOOL)containsPoint:(CGPoint)point;

-(void)setBackground;

@end
