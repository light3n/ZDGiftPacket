//
//  GeometryPathDesignView.h
//  ija
//
//  Created by Orville on 13-12-22.
//  Copyright (c) 2013年 Orville. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignPath.h"
#import "CCMRadarView.h"
@class GeometryPathDesignView;

typedef enum _PathDesignMode {
    PathDesignModeNone = 0,
    PathDesignModeSelection = 1,
    PathDesignModeCurtain = 2,
} PathDesignMode;

typedef enum _DesignLineStyle {
    DesignLineStyleLine = 0,//直线
    DesignLineStyleQuadCurve = 1,//1个控制点
    DesignLineStyleCurve = 2,//2个控制点
} DesignLineStyle;

typedef enum _PointDisplayStyle {
    PointDisplayStylePoint = 0, //只显示小点
    PointDisplayStyleControlPoint = 1,//只显示小点，控制点显示大点
    PointDisplayStyleBigPoint = 2,//所有点显示大点
} PointDisplayStyle;

typedef enum : NSUInteger {
    DesignPanStatusNone = 0,
    DesignPanStatusBegin,
    DesignPanStatusMove,
    DesignPanStatusEnd,
    DesignPanStatusFailed,
    DesignPanStatusCancelled,
    DesignPanStatusUnknown
} DesignPanStatus;

@protocol GeometryPathDesignViewDelegate <NSObject>

@required
-(void)selectionRegionValidChanged:(BOOL)isValid;
-(void)selectionGeometryChanged;
// sp add
- (void)updateUndoAndRedoButtons;
// 以下两个方法暂时未用上
- (void)designView:(GeometryPathDesignView *)view didUndoWithLastType:(CGPathElementType)type;
- (void)designView:(GeometryPathDesignView *)view didRedoWithLastType:(CGPathElementType)type;

@end

//@class CCMRadarView;

@interface GeometryPathDesignView : UIControl
{
    CGPoint orgPoint;
    int panIndex;
}

//@property (nonatomic, strong) NSMutableArray* points;
//@property (nonatomic, assign) CGPoint activePoint;
//@property (nonatomic, assign) int activeIndex;
@property (nonatomic, assign) DesignLineStyle lineStyle;
@property (nonatomic, assign) PointDisplayStyle pointDisplayStyle;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) DesignPath* pathData;
@property (nonatomic, assign) PathDesignMode designMode;
@property (nonatomic, readonly) BOOL isSelectionMode;
@property (nonatomic, strong) NSMutableArray* pointViews;
@property (nonatomic, strong) UIColor *pointColor;
@property (nonatomic, weak) id<GeometryPathDesignViewDelegate> delegate;
@property (nonatomic, strong) IBOutlet CCMRadarView* currentPointRadar;
@property (nonatomic, assign) DesignPanStatus panStatus;
@property (nonatomic, assign) CGPoint movingPoint;

// 划线取点
@property (nonatomic, assign, getter=isLineation) BOOL lineation;
@property (nonatomic, retain) ACMagnifyingGlass *magnifyingGlass;

// 当前缩放大小（添加素材模块中的放大抠图功能）
@property (nonatomic, assign) CGFloat currentScale;

-(void)closedPath;
-(void)deleteLastPoint;
-(void)generatePointViews;
-(void)setDesignPath:(BezierPaths*)thePath;
-(void)setPathIndex:(int)index;
-(void)setCurrentElementToIndex:(int)index;

-(void)createNewRegion;

- (void)sp_updateDisplay;
// 撤销
// 撤销操作需存储：历史编辑point的数值、缩放大小
// 撤销时：当前缩放大小 / 历史缩放大小 * point数值
- (void)sp_backToLastestEditionUsingCurrentScale:(CGFloat)scale;

@end
