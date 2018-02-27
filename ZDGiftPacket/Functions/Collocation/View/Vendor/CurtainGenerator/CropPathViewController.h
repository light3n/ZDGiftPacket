//
//  CropPathViewController.h
//  InJa
//
//  Created by Orville on 14-2-27.
//  Copyright (c) 2014年 Orville. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeometryPathDesignView.h"
#import "MovableButton.h"
#import "CCMRadarView.h"
#import "PathDisplayView.h"

@class CropPathViewController;
//@class CCMRadarView;

@protocol CropPathViewControllerDelegate <NSObject>

//-(void)finishedSelectionCropImage:(UIImage*)image;
-(void)finishedSelectionCropImage:(UIImage*)image withController:(CropPathViewController*)controller;

@end

@interface CropPathViewController : UIViewController<GeometryPathDesignViewDelegate>
{
    BOOL isFullRegionRevert;
    CGPoint anchorPoint;//缩放的锚点
    double currentScale;//缩放的锚点
}

-(IBAction)goBack:(id)sender;

@property (nonatomic, strong) IBOutlet MovableButton* backButton;
@property (nonatomic, strong) IBOutlet UISegmentedControl* segLineStyle;
@property (nonatomic, strong) IBOutlet UISegmentedControl* segPointDisplayStyle;
@property (nonatomic, strong) IBOutlet MovableButton* deletePointButton;
@property (nonatomic, strong) IBOutlet MovableButton* createRegionButton;
@property (nonatomic, strong) IBOutlet MovableButton* regionRevertButton;
@property (nonatomic, strong) IBOutlet MovableButton* regionSelectButton;
@property (nonatomic, strong) IBOutlet MovableButton* pointSelectButton;
@property (nonatomic, strong) IBOutlet MovableButton* verifyPathButton;
@property (nonatomic, strong) IBOutlet MovableButton* previewButton;
@property (nonatomic, strong) IBOutlet MovableButton* menuButton;
@property (nonatomic, strong) IBOutlet MovableButton* scaleBigButton;
@property (nonatomic, strong) IBOutlet MovableButton* scaleSmallButton;
@property (nonatomic, strong) IBOutlet CCMRadarView* currentPointRadar;

@property (nonatomic, strong) IBOutlet UIImageView* imageView;
@property (nonatomic, strong) IBOutlet GeometryPathDesignView* selectedAreaView;
@property (nonatomic, strong) IBOutlet PathDisplayView* bgPathDisplayView;
@property (nonatomic, weak) id<CropPathViewControllerDelegate> delegate;
@property (nonatomic, strong) UIImage* orgImage;

@property (nonatomic, strong) NSString* flagString;
@property (nonatomic, strong) BezierPaths* bezierPath;
@property (nonatomic, strong) NSArray* otherPaths;


-(void)cleanup;

@end
