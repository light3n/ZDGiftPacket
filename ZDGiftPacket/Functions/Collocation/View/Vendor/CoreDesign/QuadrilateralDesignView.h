//
//  GeometryDesignView.h
//  ija
//
//  Created by Orville on 13-12-22.
//  Copyright (c) 2013年 Orville. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PathData.h"
#import "GeometryDesignView.h"
#import "Quadrilateral.h"
@class QuadrilateralDesignView;

//typedef enum _DesignMode {
//    DesignModeNone = 0,
//    DesignModeSelection = 1
//} DesignMode;

@protocol QuadrilateralDesignViewDelegate <NSObject>

- (void)quadChanged:(Quadrilateral*)quad;


@end

@interface QuadrilateralDesignView : UIControl
{
    CGPoint orgPoint;
    int panIndex;
}

//@property (nonatomic, strong) NSMutableArray* points;
//@property (nonatomic, assign) CGPoint activePoint;
//@property (nonatomic, assign) int activeIndex;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) PathData* pathData;
@property (nonatomic, assign) DesignMode designMode;
@property (nonatomic, readonly) BOOL isSelectionMode;
@property (nonatomic, strong) NSMutableArray* pointViews;
@property (nonatomic, strong) UIColor *pointColor;
@property (nonatomic, strong) Quadrilateral* quadrilateral;
@property (nonatomic, weak) id<QuadrilateralDesignViewDelegate> delegate;
@property (nonatomic, assign) BOOL isNotShowPoint;

-(void)refreshQuad;

@end
