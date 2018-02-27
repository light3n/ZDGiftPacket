//
//  GeometryDesignView.h
//  ija
//
//  Created by Orville on 13-12-22.
//  Copyright (c) 2013年 Orville. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PathData.h"
#import "ACMagnifyingGlass.h"

typedef enum _DesignMode {
    DesignModeNone = 0,
    DesignModeSelection = 1,
    DesignModeCurtain = 2,
} DesignMode;

@protocol GeometryDesignViewDelegate <NSObject>

@required
-(void)selectionRegionValidChanged:(BOOL)isValid;
-(void)selectionGeometryChanged;

@end

@interface GeometryDesignView : UIControl
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
@property (nonatomic, weak) id<GeometryDesignViewDelegate> delegate;

// 划线取点
@property (nonatomic, assign, getter=isLineation) BOOL lineation;
// MARK: 放大镜
@property (nonatomic, retain) ACMagnifyingGlass *magnifyingGlass;

// 当前缩放大小（添加素材模块中的放大抠图功能）
@property (nonatomic, assign) CGFloat currentScale;

-(void)closedPath;
-(void)deleteLastPoint;

- (void)sp_updateDisplay;
// 撤销
// 撤销操作需存储：历史编辑point的数值、缩放大小
// 撤销时：当前缩放大小 / 历史缩放大小 * point数值
- (void)sp_backToLastestEditionUsingCurrentScale:(CGFloat)scale;

@end
