//
//  CCMRadarView.h
//  Ija
//
//  Created by Orville on 15/5/26.
//  Copyright (c) 2015年 Orville. All rights reserved.
//

#import <UIKit/UIKit.h>


IB_DESIGNABLE
@interface CCMRadarView : UIView

@property (nonatomic, strong) UIColor* color;
@property (nonatomic, assign) BOOL animating;
@property (nonatomic, strong) NSMutableArray* circleArray;

@property (nonatomic, assign) IBInspectable BOOL reversedRadar;
@property (nonatomic, assign) IBInspectable int numberOfWaves;
@property (nonatomic, strong) IBInspectable UIColor* radarColor;
@property (nonatomic, assign) IBInspectable double innerRadius;
@property (nonatomic, strong) IBInspectable UIImage* iconImage;
@property (nonatomic, assign) IBInspectable CGSize iconSize;
@property (nonatomic, assign) IBInspectable CGFloat waveWidth;
@property (nonatomic, assign) IBInspectable CGFloat maxWaveAlpha;

-(void)startAnimation;
-(void)stopAnimation;
-(void)initialSetup;
-(void)restoreInitialAlphas;
-(void)animationDidStart:(CAAnimation*)anim;
-(void)animationDidStop:(CAAnimation*)anim finished:(BOOL)flag;

@end
