//
//  DesignPath.m
//  Ija
//
//  Created by Orville on 15/2/9.
//  Copyright (c) 2015年 Orville. All rights reserved.
//

#import "DesignPath.h"
#import "CoreMath.h"
#import "BezierPath.h"
#import "BezierElement.h"

#define ClosedDistance 15

@interface DesignPath()

-(BezierPath*)currentPath;

@end

@implementation DesignPath
@synthesize dataPath;
@synthesize drawPath;
@synthesize points = _points;
@synthesize controlPointIndexes = _controlPointIndexes;
@synthesize selectedIndex;
@synthesize hasClosed;
@synthesize currentPathIndex;
@synthesize currentElementIndex;
@synthesize currentPointIndex;

- (instancetype)init
{
    self = [super init];
    if (self) {
        dataPath = [[BezierPaths alloc] init];
        self.selectedPathIndex = 0;
        self.selectedIndex = -1;
        _points = [NSMutableArray array];
        self.noneAutoDelete = YES;
        
        currentPathIndex = [dataPath addEmptyPath];
        currentElementIndex = -1;
        currentPointIndex = -1;
    }
    return self;
}

-(void)setDesignPath:(BezierPaths*)thePath
{
    UIBezierPath* bzp = [thePath toBezierPath];
    
    BezierPaths* path = [[BezierPaths alloc] initWithBezierPath:bzp];
    
    self.dataPath = path;
    
    currentPathIndex = (int)(dataPath.paths.count - 1);
    BezierPath* currentPath = [self currentPath];
    currentElementIndex = (int)(currentPath.elements.count - 1);
    
    [self updatePointState];
}

-(void)setPathIndex:(int)index
{
    currentPathIndex = index;
    BezierPath* currentPath = [self currentPath];
    currentElementIndex = (int)(currentPath.elements.count - 1);
    [self updatePointState];
}

-(void)setCurrentElementToIndex:(int)index
{
    currentElementIndex = index;
    
    [self updatePointState];
}

-(void)updatePointState
{
    _points = [NSMutableArray array];
    _controlPointIndexes = [NSMutableArray array];
    drawPath = [dataPath toBezierPathWithPoints:_points controlPointIndexes:_controlPointIndexes forPathIndex:self.currentPathIndex];
}

-(BOOL)isSinglePath
{
    return dataPath.paths.count <= 1;
}

-(BezierPath*)currentPath
{
    if (self.currentPathIndex < 0) {
        return nil;
    }
    return [dataPath.paths objectAtIndex:self.currentPathIndex];
}

-(BezierElement*)currentPointElement
{
    if (self.currentPathElementCount <= 0) {
        return nil;
    }
    
    BezierPath* cp = [self currentPath];
    if (currentElementIndex >= 0) {
        BezierElement* be = [cp.elements objectAtIndex:currentElementIndex];
        if (be && be.kind != kCGPathElementCloseSubpath) {
            return be;
        }
    }
    
    return nil;
}

-(int)currentPathElementCount
{
    BezierPath* cp = [self currentPath];
    
    if (cp.elements.count > 0) {
        BezierElement* be = cp.elements.lastObject;
        if (be.kind == kCGPathElementCloseSubpath) {
            if (cp.elements.count >= 1) {
                return (int)(cp.elements.count - 1);
            }
            else {
                return 0;
            }
        }
        else {
            return (int)cp.elements.count;
        }
    }
    else {
        return 0;
    }
}

-(void)addNewPath
{
    currentPathIndex = [dataPath addEmptyPath];
    currentElementIndex = -1;
    currentPointIndex = -1;
}

-(void)moveToFirstPoint
{
    BezierPath* currentPath = [self currentPath];
    [currentPath moveToFirstPoint];
    
    [self updatePointState];
}

-(void)addPoint:(CGPoint)point
{
    BezierPath* currentPath = [self currentPath];
    currentElementIndex = [currentPath addPoint:point belowIndex:currentElementIndex];
    
    [self updatePointState];
}

-(void)refresh
{
    currentPathIndex = (int)(dataPath.paths.count - 1);
    BezierPath* currentPath = [self currentPath];
    currentElementIndex = (int)(currentPath.elements.count - 1);
    
    [self updatePointState];
}

//一个控制点的曲线
-(void)addPointQuadCurve:(CGPoint)point
{
    [self addPoint:point];
    
    [self setToQuadCurve];
}

//两个控制点的曲线
-(void)addPointCurve:(CGPoint)point
{
    [self addPoint:point];
    
    [self setToCurve];
}

-(void)deleteLastPoint
{
    BezierPath* currentPath = [self currentPath];
    if (currentPath.elements.count > 0) {
//        [currentPath removeLastElement];
        currentElementIndex = [currentPath removeElementAtIndex:currentElementIndex];
    }
    
    if (currentPath.elements.count == 0) {
        if (dataPath.paths.count > 1) {
            [dataPath removePathAtIndex:currentPathIndex];
            if (currentPathIndex < dataPath.paths.count) {
                currentPath = [self currentPath];
                currentElementIndex = (int)(currentPath.elements.count - 1);
            }
            else {
                currentPathIndex--;
                currentPath = [self currentPath];
                currentElementIndex = (int)(currentPath.elements.count - 1);
            }
        }
//        else {
//            currentElementIndex = -1;
//        }
    }
    else {
//        if (currentElementIndex > 0) {
//            currentElementIndex--;
//        }
//        else {
//            //下一个点
//        }
    }
    
    
    
    [self updatePointState];
    
//    if (_points.count > 0) {
//        [_points removeLastObject];
//        self.selectedIndex = _points.count-1;
//    }
}

//把当前的element设置成
-(void)setToPoint
{
    if (currentElementIndex < 0) {
        return;
    }
    BezierPath* currentPath = [self currentPath];
    BezierElement* lastElement = [currentPath.elements objectAtIndex:currentElementIndex];
    if (lastElement) {
        switch (lastElement.kind) {
            case kCGPathElementMoveToPoint:
                break;
            case kCGPathElementAddLineToPoint:
                break;
            case kCGPathElementAddCurveToPoint:
                lastElement.kind = kCGPathElementAddLineToPoint;
                lastElement.controlPoint1 = CGPointZero;
                lastElement.controlPoint2 = CGPointZero;
                break;
            case kCGPathElementCloseSubpath:
//                if (currentElementIndex - 1 > 0) {
//                    lastElement = [currentPath.elements objectAtIndex:currentElementIndex - 1];
//                    if (lastElement.kind == kCGPathElementAddCurveToPoint || lastElement.kind == kCGPathElementAddQuadCurveToPoint) {
//                        lastElement.kind = kCGPathElementAddLineToPoint;
//                        lastElement.controlPoint1 = CGPointZero;
//                        lastElement.controlPoint2 = CGPointZero;
//                    }
//                }
                break;
            case kCGPathElementAddQuadCurveToPoint:
                lastElement.kind = kCGPathElementAddLineToPoint;
                lastElement.controlPoint1 = CGPointZero;
                lastElement.controlPoint2 = CGPointZero;
                break;
            default:
                break;
        }
    }
    
    [self updatePointState];
}

-(void)setLastToPoint
{
    BezierPath* currentPath = [self currentPath];
    BezierElement* lastElement = [currentPath.elements lastObject];
    if (lastElement) {
        switch (lastElement.kind) {
            case kCGPathElementMoveToPoint:
                break;
            case kCGPathElementAddLineToPoint:
                break;
            case kCGPathElementAddCurveToPoint:
                lastElement.kind = kCGPathElementAddLineToPoint;
                lastElement.controlPoint1 = CGPointZero;
                lastElement.controlPoint2 = CGPointZero;
                break;
            case kCGPathElementCloseSubpath:
//                if (currentPath.elements.count > 1) {
//                    lastElement = [currentPath.elements objectAtIndex:currentPath.elements.count - 2];
//                    if (lastElement.kind == kCGPathElementAddCurveToPoint || lastElement.kind == kCGPathElementAddQuadCurveToPoint) {
//                        lastElement.kind = kCGPathElementAddLineToPoint;
//                        lastElement.controlPoint1 = CGPointZero;
//                        lastElement.controlPoint2 = CGPointZero;
//                    }
//                }
                break;
            case kCGPathElementAddQuadCurveToPoint:
                lastElement.kind = kCGPathElementAddLineToPoint;
                lastElement.controlPoint1 = CGPointZero;
                lastElement.controlPoint2 = CGPointZero;
                break;
            default:
                break;
        }
    }
}

-(void)updateElementToQuadCurve:(BezierElement*)element withUpElement:(BezierElement*)upElement
{
    element.kind = kCGPathElementAddQuadCurveToPoint;
    element.controlPoint1 = CGPointMake(MIN(element.point.x, upElement.point.x) -10, MIN(element.point.y, upElement.point.y)-10);
    element.controlPoint2 = CGPointZero;
    
}

//一个控制点的曲线
-(void)setToQuadCurve
{
    if (currentElementIndex < 1) {
        return;
    }
    
    BezierPath* currentPath = [self currentPath];
    BezierElement* element = [currentPath.elements objectAtIndex:currentElementIndex];
    BezierElement* upElement = [currentPath.elements objectAtIndex:currentElementIndex-1];
    if (element) {
        switch (element.kind) {
            case kCGPathElementMoveToPoint:
                break;
            case kCGPathElementAddLineToPoint:
                [self updateElementToQuadCurve:element withUpElement:upElement];
                break;
            case kCGPathElementAddCurveToPoint:
                [self updateElementToQuadCurve:element withUpElement:upElement];
                break;
            case kCGPathElementCloseSubpath:
//                if (currentElementIndex - 1 > 0) {
//                    element = [currentPath.elements objectAtIndex:currentElementIndex - 1];
//                    if (element.kind == kCGPathElementAddCurveToPoint || element.kind == kCGPathElementAddQuadCurveToPoint) {
//                        element.kind = kCGPathElementAddLineToPoint;
//                        element.controlPoint1 = CGPointZero;
//                        element.controlPoint2 = CGPointZero;
//                    }
//                }
                break;
            case kCGPathElementAddQuadCurveToPoint:
                break;
            default:
                break;
        }
    }
    
    [self updatePointState];
}

-(CGPoint)replacePoint:(CGPoint)point atIndex:(int)index
{
    if (currentPathIndex >= dataPath.paths.count)
        return CGPointZero;
    
    CGPoint rPoint = point;
    
    BezierPath* thePath = [dataPath.paths objectAtIndex:currentPathIndex];
    
    BOOL canMergePoint = NO;//取消是否允许闭合，最后一个点和第一个点重合
    int replacingElementIndex = -1; //正在被替换的element index
    BOOL movingPointIsControlPoint = NO;
    int lastElementPointIndex = -1;
    if (thePath.elements.count > 1) {
        int tmpIndex = -1;
        int theCount = (int)thePath.elements.count;
        for (int i = 0; i < theCount; i++) {
            BezierElement* element = [thePath.elements objectAtIndex:i];
            switch (element.kind) {
                case kCGPathElementMoveToPoint:
                    tmpIndex++;
                    if (tmpIndex == index) {
                        replacingElementIndex = i;
                    }
                    break;
                case kCGPathElementAddLineToPoint:
                    tmpIndex++;
                    if (!canMergePoint) {
                        if (tmpIndex > 2) {
                            canMergePoint = YES;
                        }
                    }
                    if (tmpIndex == index) {
                        replacingElementIndex = i;
                    }
                    if (i == (theCount-1)) {
                        lastElementPointIndex = tmpIndex;
                    }
                    break;
                case kCGPathElementAddCurveToPoint:
                    // [points addObject:[NSValue valueWithCGPoint:element.controlPoint1]];
                    tmpIndex++;
                    canMergePoint = YES;
                    if (tmpIndex == index) {
                        movingPointIsControlPoint = YES;
                        replacingElementIndex = i;
                    }
                    // [points addObject:[NSValue valueWithCGPoint:element.controlPoint2]];
                    tmpIndex++;
                    if (tmpIndex == index) {
                        movingPointIsControlPoint = YES;
                        replacingElementIndex = i;
                    }
                    // [points addObject:[NSValue valueWithCGPoint:element.point]];
                    tmpIndex++;
                    if (tmpIndex == index) {
                        replacingElementIndex = i;
                    }
                    if (i == (theCount-1)) {
                        lastElementPointIndex = tmpIndex;
                    }
                    break;
                case kCGPathElementCloseSubpath:
                    if (i == (theCount-1)) {
                        lastElementPointIndex = tmpIndex;
                    }
                    break;
                case kCGPathElementAddQuadCurveToPoint:
                    // [points addObject:[NSValue valueWithCGPoint:element.controlPoint1]];
                    tmpIndex++;
                    canMergePoint = YES;
                    if (tmpIndex == index) {
                        movingPointIsControlPoint = YES;
                        replacingElementIndex = i;
                    }
                    // [points addObject:[NSValue valueWithCGPoint:element.point]];
                    tmpIndex++;
                    if (tmpIndex == index) {
                        replacingElementIndex = i;
                    }
                    if (i == (theCount-1)) {
                        lastElementPointIndex = tmpIndex;
                    }
                    break;
                default:
                    break;
            }
        }
    }
    
    //移动的点不是控制点，且现在的曲线允许闭合
    if (!movingPointIsControlPoint && canMergePoint && replacingElementIndex >= 0) {
        BezierElement* firstEle = thePath.elements.firstObject;
        CGPoint p1 = firstEle.point;
        BezierElement* lastEle = thePath.elements.lastObject;
        CGPoint pLast = lastEle.point;
        if (replacingElementIndex==(thePath.elements.count-1))
        {
            //当前移动的是第一个点. 同时移动第一个点和最后一个点
//            if (CGPointEqualToPoint(p1, pLast)) {
////                [dataPath replacePoint:rPoint atPointIndex:0 forPathIndex:currentPathIndex];
//            }
//            else {
                //当前移动的是最后一个点
                float distance = [CoreMath distanceBetween:p1 and:point];
                if (distance <= ClosedDistance) {
                    rPoint = p1; //移动时，自动闭合
                }
//            }
        }
        else if (replacingElementIndex == 0)
        {
            //当前移动的是第一个点. 同时移动第一个点和最后一个点
            if (CGPointEqualToPoint(p1, pLast)) {
                if (lastElementPointIndex >= 0) {
                    [dataPath replacePoint:rPoint atPointIndex:lastElementPointIndex forPathIndex:currentPathIndex];
                }
            }
        }
    }
    
    
    //只有直线，没有曲线时，下面代码是正确的
//    if (thePath.elements.count > 3) {
//        BezierElement* firstEle = thePath.elements.firstObject;
//        CGPoint p1 = firstEle.point;
//        BezierElement* lastEle = thePath.elements.lastObject;
//        CGPoint pLast = lastEle.point;
//        if (index==(thePath.elements.count-1))
//        {
//            //当前移动的是最后一个点
//            float distance = [CoreMath distanceBetween:p1 and:point];
//            if (distance <= ClosedDistance) {
//                point = p1; //移动时，自动闭合
//            }
//        }
//        else if (index == 0)
//        {
//            //当前移动的是第一个点. 同时移动第一个点和最后一个点
//            if (CGPointEqualToPoint(p1, pLast)) {
//                [dataPath replacePoint:point atPointIndex:(thePath.elements.count-1) forPathIndex:currentPathIndex];
//            }
//        }
//    }
    
    [dataPath replacePoint:rPoint atPointIndex:index forPathIndex:currentPathIndex];
    
    [self updatePointState];
//    drawPath = [dataPath toBezierPath];
    
    return rPoint;
}

//
-(void)replacePoint2:(CGPoint)point atIndex:(int)index
{
    [dataPath replacePoint:point atPointIndex:index forPathIndex:currentPathIndex];
    //    if (!self.noneAutoDelete) {
    //        //移动时，自动闭合
    //        if (_points.count > 3 && !hasClosed && index==(_points.count-1)) {
    //            CGPoint p1 = [[_points objectAtIndex:0] CGPointValue];
    //            float distance = [CoreMath distanceBetween:p1 and:point];
    //            if (distance <= ClosedDistance) {
    //                self.hasClosed = YES;
    //                [_points removeObjectAtIndex:index];
    //                return;
    //            }
    //        }
    //
    //        //移动时，自动闭合后的索引越界
    //        if (index >= _points.count) {
    //            return;
    //        }
    //    }
    //
    //    //    self.selectedIndex = index;
    //    [_points replaceObjectAtIndex:index withObject:[NSValue valueWithCGPoint:point]];
    
    [self updatePointState];
    //    drawPath = [dataPath toBezierPath];
}

-(void)updateElementToCurve:(BezierElement*)element withUpElement:(BezierElement*)upElement
{
    element.kind = kCGPathElementAddCurveToPoint;
    element.controlPoint1 = CGPointMake(MIN(element.point.x, upElement.point.x) -10, MIN(element.point.y, upElement.point.y)-10);
    element.controlPoint2 = CGPointMake(MAX(element.point.x, upElement.point.x) +10, MAX(element.point.y, upElement.point.y)+10);
    
}

//两个控制点的曲线
-(void)setToCurve
{
    if (currentElementIndex < 1) {
        return;
    }
    BezierPath* currentPath = [self currentPath];
    BezierElement* element = [currentPath.elements objectAtIndex:currentElementIndex];
    BezierElement* upElement = [currentPath.elements objectAtIndex:currentElementIndex-1];
    if (element) {
        switch (element.kind) {
            case kCGPathElementMoveToPoint:
                break;
            case kCGPathElementAddLineToPoint:
                [self updateElementToCurve:element withUpElement:upElement];
                break;
            case kCGPathElementAddCurveToPoint:
                
                break;
            case kCGPathElementCloseSubpath:
                
                break;
            case kCGPathElementAddQuadCurveToPoint:
                [self updateElementToCurve:element withUpElement:upElement];
                break;
            default:
                break;
        }
    }
    
    [self updatePointState];
}

-(BOOL)isControlPointAtIndex:(int)index
{
    for (NSNumber* num in _controlPointIndexes) {
        if ([num intValue] == index) {
            return YES;
        }
    }
    
    return NO;
}

//获取最近的点
-(int)getClosedPointIndex:(CGPoint)point
{
    int result = -1;
    float minDistance = INTMAX_MAX;
    for (int i = 0; i < _points.count; i++) {
        CGPoint p = [[_points objectAtIndex:i] CGPointValue];
        float distance = [CoreMath distanceBetween:p and:point];
        if (distance < minDistance) {
            minDistance = distance;
            result = i;
        }
    }
    
    return result;
}

-(BOOL)selectionRegionValid
{
    CGSize size = self.toBezierPath.bounds.size;
    
    if (size.width > 0 && size.height > 0) {
        return YES;
    }
    else {
        return NO;
    }
}

//-(void)deleteLastPoint
//{
//    if (_points.count > 0) {
//        [_points removeLastObject];
//        self.selectedIndex = _points.count-1;
//    }
//}

//-(void)addPoint:(CGPoint)point
//{
//    if (_points.count > 2 && !self.noneAutoDelete) {
//        CGPoint p1 = [[_points objectAtIndex:0] CGPointValue];
//        float distance = [CoreMath distanceBetween:p1 and:point];
//        if (distance <= ClosedDistance) {
//            self.hasClosed = YES;
//            return;
//        }
//    }
//    
//    self.selectedIndex = _points.count;
//    [_points addObject:[NSValue valueWithCGPoint:point]];
//}

-(void)addPoint:(CGPoint)point atIndex:(int)index
{
    if (_points.count > 2 && !hasClosed && index==(_points.count-1)&& !self.noneAutoDelete) {
        CGPoint p1 = [[_points objectAtIndex:0] CGPointValue];
        float distance = [CoreMath distanceBetween:p1 and:point];
        if (distance <= ClosedDistance) {
            self.hasClosed = YES;
            return;
        }
    }
    
    self.selectedIndex = index;
    [_points insertObject:[NSValue valueWithCGPoint:point] atIndex:index];
}

//-(void)replacePoint:(CGPoint)point atIndex:(int)index
//{
//    if (!self.noneAutoDelete) {
//        //移动时，自动闭合
//        if (_points.count > 3 && !hasClosed && index==(_points.count-1)) {
//            CGPoint p1 = [[_points objectAtIndex:0] CGPointValue];
//            float distance = [CoreMath distanceBetween:p1 and:point];
//            if (distance <= ClosedDistance) {
//                self.hasClosed = YES;
//                [_points removeObjectAtIndex:index];
//                return;
//            }
//        }
//        
//        //移动时，自动闭合后的索引越界
//        if (index >= _points.count) {
//            return;
//        }
//    }
//    
//    //    self.selectedIndex = index;
//    [_points replaceObjectAtIndex:index withObject:[NSValue valueWithCGPoint:point]];
//}

-(UIBezierPath*)toBezierPath
{
    return drawPath;
//    UIBezierPath *aPath = [UIBezierPath bezierPath];
//    
//    // Set the starting point of the shape.
//    if (_points.count == 0) {
//        return nil;
//    }
//    CGPoint p1 = [[_points objectAtIndex:0] CGPointValue];
//    [aPath moveToPoint:CGPointMake(p1.x, p1.y)];
//    
//    for (uint i=1; i<_points.count; i++)
//    {
//        CGPoint p = [[_points objectAtIndex:i] CGPointValue];
//        [aPath addLineToPoint:CGPointMake(p.x, p.y)];
//    }
//    [aPath closePath];
//    
//    return aPath;
}

//-(UIBezierPath*)drawPath
//{
//    return [dataPath toBezierPath];
//}

@end
