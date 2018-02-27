//
//  DesignPath.h
//  Ija
//
//  Created by Orville on 15/2/9.
//  Copyright (c) 2015年 Orville. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BezierPaths.h"
#import "BezierPath.h"
#import "BezierElement.h"

@interface DesignPath : NSObject
{
    NSMutableArray* _points;
    NSMutableArray* _controlPointIndexes;
}

@property (nonatomic, readonly) BOOL isSinglePath;
@property (nonatomic, strong) BezierPaths* dataPath;
@property (nonatomic, strong, readonly) UIBezierPath* drawPath;
//点集
@property (nonatomic, strong, readonly) NSArray* points;// all points for currentPath
@property (nonatomic, strong, readonly) NSArray* controlPointIndexes;// all points for currentPath

@property (nonatomic, assign, readonly) int currentPathIndex;
@property (nonatomic, assign, readonly) int currentElementIndex;
@property (nonatomic, assign, readonly) int currentPointIndex;
@property (nonatomic, strong, readonly) BezierPath* currentPath;
@property (nonatomic, strong, readonly) BezierElement* currentPointElement;

-(void)addNewPath;

-(void)addPoint:(CGPoint)point;
-(void)addPointQuadCurve:(CGPoint)point;//一个控制点的曲线
-(void)addPointCurve:(CGPoint)point;//两个控制点的曲线

//把当前的element设置成
-(void)setToPoint;
-(void)setToQuadCurve;//一个控制点的曲线
-(void)setToCurve;//两个控制点的曲线

//-(void)deleteLastPoint;

-(BOOL)isControlPointAtIndex:(int)index;
-(void)setPathIndex:(int)index;
-(void)setCurrentElementToIndex:(int)index;
-(int)currentPathElementCount;


@property (nonatomic, assign) int selectedPathIndex;
//当前选中的点
@property (nonatomic, assign) int selectedIndex;//selected point index of the selectedPath

//是否闭合
@property (nonatomic, assign) BOOL hasClosed;

@property (nonatomic, assign) BOOL noneAutoDelete;
@property (nonatomic, readonly) BOOL selectionRegionValid;

//获取最近的点
-(int)getClosedPointIndex:(CGPoint)point;

//-(void)addPoint:(CGPoint)point;
-(void)addPoint:(CGPoint)point atIndex:(int)index;
-(CGPoint)replacePoint:(CGPoint)point atIndex:(int)index;
-(void)moveToFirstPoint;
-(void)refresh;

-(UIBezierPath*)toBezierPath;

////Path 转换为string
//-(NSString*)pathToString;
////String转Path
//+(NSMutableArray*)pointsFromString:(NSString*)str;
////String转Path对象
//+(DesignPath*)pathFromString:(NSString*)str;

-(void)deleteLastPoint;

-(void)setDesignPath:(BezierPaths*)thePath;

-(void)updatePointState;

@end
