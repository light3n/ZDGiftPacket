//
//  BezierPath.m
//  Ija
//
//  Created by Orville on 15/2/9.
//  Copyright (c) 2015年 Orville. All rights reserved.
//

#import "BezierPath.h"
#import "BezierElement.h"

@implementation BezierPath
@synthesize bounds;
@synthesize elements = _elements;

- (instancetype)init
{
    self = [super init];
    if (self) {
        bounds = CGRectZero;
        _elements = [NSMutableArray array];
    }
    return self;
}

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [self init];
    if (self) {
        NSString* bStr = [dict objectForKey:@"bounds"];
        if (bStr.length != 0) {
            bounds = CGRectFromString(bStr);
        }
        
        NSMutableArray* arrElements = [dict objectForKey:@"elements"];
        for (NSDictionary* dicE in arrElements) {
            BezierElement* e = [[BezierElement alloc] initWithDictionary:dicE];
            [_elements addObject:e];
        }
    }
    return self;
}

-(NSDictionary*)toDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    [dict setObject:NSStringFromCGRect(bounds) forKey:@"bounds"];
    
    NSMutableArray* arrElements = [NSMutableArray array];
    for (BezierElement* e in _elements) {
        NSDictionary* dicE = [e toDictionary];
        [arrElements addObject:dicE];
    }
    [dict setObject:arrElements forKey:@"elements"];
    
    return dict;
}

-(void)moveToFirstPoint
{
    BezierElement* firstItem = _elements.firstObject;
    if (firstItem) {
        BezierElement* element = [[BezierElement alloc] init];
        element.kind = kCGPathElementMoveToPoint;
        element.point = firstItem.point;
        [_elements addObject:element];
    }
}

-(int)addPoint:(CGPoint)point belowIndex:(int)index
{
    if (index < 0) {
        if (_elements.count == 0) {
            BezierElement* element = [[BezierElement alloc] init];
            element.kind = kCGPathElementMoveToPoint;
            element.point = point;
            [_elements addObject:element];
        }
        else {
            BezierElement* tmpE = [_elements lastObject];
            if (tmpE.kind == kCGPathElementCloseSubpath) {
                tmpE.kind = kCGPathElementMoveToPoint;
                tmpE.point = point;
                tmpE.controlPoint1 = CGPointZero;
                tmpE.controlPoint2 = CGPointZero;
            }
        }
        
        return (int)_elements.count - 1;
    }
    else {
        if (index >= _elements.count) {
            return -1;
        }
        
        BezierElement* tmpE = [_elements objectAtIndex:index];
        if (tmpE.kind == kCGPathElementCloseSubpath) {
            tmpE.kind = kCGPathElementMoveToPoint;
            tmpE.point = point;
            tmpE.controlPoint1 = CGPointZero;
            tmpE.controlPoint2 = CGPointZero;
            return index;
        }
        else {
            BezierElement* element = [[BezierElement alloc] init];
            element.kind = kCGPathElementAddLineToPoint;
            element.point = point;
            
            if (index == (_elements.count - 1)) {
                [_elements addObject:element];
            }
            else {
                [_elements insertObject:element atIndex:index+1];
            }
            return index+1;
        }
    }
}

-(void)appendToBezierPath:(UIBezierPath*)bzp
{
    for (BezierElement* element in _elements) {
        switch (element.kind) {
            case kCGPathElementMoveToPoint:
                [bzp moveToPoint:element.point];
                break;
            case kCGPathElementAddLineToPoint:
                [bzp addLineToPoint:element.point];
                break;
            case kCGPathElementAddCurveToPoint:
                [bzp addCurveToPoint:element.point controlPoint1:element.controlPoint1 controlPoint2:element.controlPoint2];
                break;
            case kCGPathElementCloseSubpath:
                [bzp closePath];
                break;
            case kCGPathElementAddQuadCurveToPoint:
                [bzp addQuadCurveToPoint:element.point controlPoint:element.controlPoint1];
                break;
            default:
                break;
        }
    }
}

-(void)appendToBezierPath:(UIBezierPath*)bzp withPoints:(NSMutableArray*)points
{
    for (BezierElement* element in _elements) {
        switch (element.kind) {
            case kCGPathElementMoveToPoint:
                [bzp moveToPoint:element.point];
                [points addObject:[NSValue valueWithCGPoint:element.point]];
                break;
            case kCGPathElementAddLineToPoint:
                [bzp addLineToPoint:element.point];
                [points addObject:[NSValue valueWithCGPoint:element.point]];
                break;
            case kCGPathElementAddCurveToPoint:
                [bzp addCurveToPoint:element.point controlPoint1:element.controlPoint1 controlPoint2:element.controlPoint2];
                [points addObject:[NSValue valueWithCGPoint:element.controlPoint1]];
                [points addObject:[NSValue valueWithCGPoint:element.controlPoint2]];
                [points addObject:[NSValue valueWithCGPoint:element.point]];
                break;
            case kCGPathElementCloseSubpath:
                [bzp closePath];
                break;
            case kCGPathElementAddQuadCurveToPoint:
                [bzp addQuadCurveToPoint:element.point controlPoint:element.controlPoint1];
                [points addObject:[NSValue valueWithCGPoint:element.controlPoint1]];
                [points addObject:[NSValue valueWithCGPoint:element.point]];
                break;
            default:
                break;
        }
    }
}

-(void)appendToBezierPath:(UIBezierPath*)bzp withPoints:(NSMutableArray*)points controlPointIndexes:(NSMutableArray*)controlPointIndexes
{
    for (BezierElement* element in _elements) {
        switch (element.kind) {
            case kCGPathElementMoveToPoint:
                [bzp moveToPoint:element.point];
                [points addObject:[NSValue valueWithCGPoint:element.point]];
                break;
            case kCGPathElementAddLineToPoint:
                [bzp addLineToPoint:element.point];
                [points addObject:[NSValue valueWithCGPoint:element.point]];
                break;
            case kCGPathElementAddCurveToPoint:
                [bzp addCurveToPoint:element.point controlPoint1:element.controlPoint1 controlPoint2:element.controlPoint2];
                [points addObject:[NSValue valueWithCGPoint:element.controlPoint1]];
                [controlPointIndexes addObject:[NSNumber numberWithInt:(int)points.count-1]];
                [points addObject:[NSValue valueWithCGPoint:element.controlPoint2]];
                [controlPointIndexes addObject:[NSNumber numberWithInt:(int)points.count-1]];
                [points addObject:[NSValue valueWithCGPoint:element.point]];
                break;
            case kCGPathElementCloseSubpath:
                [bzp closePath];
                break;
            case kCGPathElementAddQuadCurveToPoint:
                [bzp addQuadCurveToPoint:element.point controlPoint:element.controlPoint1];
                [points addObject:[NSValue valueWithCGPoint:element.controlPoint1]];
                [controlPointIndexes addObject:[NSNumber numberWithInt:(int)points.count-1]];
                [points addObject:[NSValue valueWithCGPoint:element.point]];
                break;
            default:
                break;
        }
    }
}

-(void)replacePoint:(CGPoint)point atPointIndex:(int)index
{
    int tmpIndex = -1;
    for (BezierElement* element in _elements) {
        switch (element.kind) {
            case kCGPathElementMoveToPoint:
                tmpIndex++;
                if (tmpIndex == index) {
                    element.point = point;
                    return;
                }
                break;
            case kCGPathElementAddLineToPoint:
                tmpIndex++;
                if (tmpIndex == index) {
                    element.point = point;
                    return;
                }
                break;
            case kCGPathElementAddCurveToPoint:
                // [points addObject:[NSValue valueWithCGPoint:element.controlPoint1]];
                tmpIndex++;
                if (tmpIndex == index) {
                    element.controlPoint1 = point;
                    return;
                }
                // [points addObject:[NSValue valueWithCGPoint:element.controlPoint2]];
                tmpIndex++;
                if (tmpIndex == index) {
                    element.controlPoint2 = point;
                    return;
                }
                // [points addObject:[NSValue valueWithCGPoint:element.point]];
                tmpIndex++;
                if (tmpIndex == index) {
                    element.point = point;
                    return;
                }
                break;
            case kCGPathElementCloseSubpath:
                break;
            case kCGPathElementAddQuadCurveToPoint:
                // [points addObject:[NSValue valueWithCGPoint:element.controlPoint1]];
                tmpIndex++;
                if (tmpIndex == index) {
                    element.controlPoint1 = point;
                    return;
                }
                // [points addObject:[NSValue valueWithCGPoint:element.point]];
                tmpIndex++;
                if (tmpIndex == index) {
                    element.point = point;
                    return;
                }
                break;
            default:
                break;
        }
    }
}

-(void)removeLastElement
{
    if (_elements.count > 0) {
        [_elements removeObjectAtIndex:_elements.count-1];
    }
}

-(int)removeElementAtIndex:(int)index
{
    
    [_elements removeObjectAtIndex:index];
    
    int theCurrentIndex = -1;
    if (index == 0) {
        //设置第一个点的样式和状态
        BezierElement* be = _elements.firstObject;
        be.kind = kCGPathElementMoveToPoint;
        be.controlPoint1 = CGPointZero;
        be.controlPoint2 = CGPointZero;
        
        if (_elements.count > 0) {
            theCurrentIndex = 0;
        }
        else {
            theCurrentIndex = -1;
        }
    }
    else {
        theCurrentIndex = index - 1;
    }
    
    return theCurrentIndex;
}

-(void)appendToBezierPath:(UIBezierPath*)bzp fromSize:(CGSize)fromSize toSize:(CGSize)toSize
{
    for (BezierElement* element in _elements) {
        switch (element.kind) {
            case kCGPathElementMoveToPoint:
                [bzp moveToPoint:[self convertCGPoint:element.point fromSize:fromSize toSize:toSize]];
                break;
            case kCGPathElementAddLineToPoint:
                [bzp addLineToPoint:[self convertCGPoint:element.point fromSize:fromSize toSize:toSize]];
                break;
            case kCGPathElementAddCurveToPoint:
                [bzp addCurveToPoint:[self convertCGPoint:element.point fromSize:fromSize toSize:toSize]
                       controlPoint1:[self convertCGPoint:element.controlPoint1 fromSize:fromSize toSize:toSize]
                       controlPoint2:[self convertCGPoint:element.controlPoint2 fromSize:fromSize toSize:toSize]];
                break;
            case kCGPathElementCloseSubpath:
                [bzp closePath];
                break;
            case kCGPathElementAddQuadCurveToPoint:
                [bzp addQuadCurveToPoint:[self convertCGPoint:element.point fromSize:fromSize toSize:toSize]
                            controlPoint:[self convertCGPoint:element.controlPoint1 fromSize:fromSize toSize:toSize]];
                break;
            default:
                break;
        }
    }
}

- (CGPoint)convertCGPoint:(CGPoint)point1 fromSize:(CGSize)rect1 toSize:(CGSize)rect2
{
    point1.y = rect1.height - point1.y;
    CGPoint result = CGPointMake((point1.x*rect2.width)/rect1.width, (point1.y*rect2.height)/rect1.height);
    return result;
}
//- (CGPoint)convertCGPoint:(CGPoint)point fromSize:(CGSize)fromSize toSize:(CGSize)toSize
//{
//    point.y = fromSize.height - point.y;
//    CGPoint result = CGPointMake((point.x*toSize.width)/fromSize.width, (point.y*toSize.height)/fromSize.height);
//    return result;
//}

-(void)moveToPoint:(CGPoint)point
{
    BezierElement* element = [[BezierElement alloc] init];
    element.kind = kCGPathElementMoveToPoint;
    element.point = point;
    [_elements addObject:element];
}

-(void)addLineToPoint:(CGPoint)point
{
    BezierElement* element = [[BezierElement alloc] init];
    element.kind = kCGPathElementAddLineToPoint;
    element.point = point;
    [_elements addObject:element];
}

-(void)addQuadCurveToPoint:(CGPoint)point controlPoint:(CGPoint)controlPoint1
{
    BezierElement* element = [[BezierElement alloc] init];
    element.kind = kCGPathElementAddQuadCurveToPoint;
    element.point = point;
    element.controlPoint1 = controlPoint1;
    [_elements addObject:element];
}

-(void)addCurveToPoint:(CGPoint)point controlPoint1:(CGPoint)controlPoint1 controlPoint2:(CGPoint)controlPoint2
{
    BezierElement* element = [[BezierElement alloc] init];
    element.kind = kCGPathElementAddCurveToPoint;
    element.point = point;
    element.controlPoint1 = controlPoint1;
    element.controlPoint2 = controlPoint2;
    [_elements addObject:element];
}

-(void)closeSubpath
{
    BezierElement* element = [[BezierElement alloc] init];
    element.kind = kCGPathElementCloseSubpath;
    element.point = CGPointZero;
    [_elements addObject:element];
}

#pragma mark -

static CGFloat previousScale = 1;
- (void)updatePointsWithScale:(CGFloat)scale {
    // 不管有没有point 都需要记录上一个缩放数值previousScale
    CGFloat actualScale = scale / previousScale;
    previousScale = scale;
    if (_elements.count == 0) {
        return;
    }
    for (int i=0; i<_elements.count; i++) {
        BezierElement *element = [_elements objectAtIndex:i];
        element.point = CGPointScale(element.point, actualScale);
        if (element.kind == kCGPathElementAddCurveToPoint) {
            element.controlPoint1 = CGPointScale(element.controlPoint1, actualScale);
            element.controlPoint2 = CGPointScale(element.controlPoint2, actualScale);
        }
        [_elements replaceObjectAtIndex:i withObject:element];
    }
}


- (void)updatePointsWithScaleAfterRepeal:(CGFloat)scale {
    if (_elements.count == 0) {
        return;
    }
    for (int i=0; i<_elements.count; i++) {
        BezierElement *element = [_elements objectAtIndex:i];
        element.point = CGPointScale(element.point, scale);
        if (element.kind == kCGPathElementAddCurveToPoint) {
            element.controlPoint1 = CGPointScale(element.controlPoint1, scale);
            element.controlPoint2 = CGPointScale(element.controlPoint2, scale);
        }
        [_elements replaceObjectAtIndex:i withObject:element];
    }
}

static CGPoint CGPointScale(CGPoint point, CGFloat scale) {
    point.x *= scale;
    point.y *= scale;
    return point;
}

@end
