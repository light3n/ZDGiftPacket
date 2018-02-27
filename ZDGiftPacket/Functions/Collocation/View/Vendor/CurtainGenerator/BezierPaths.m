//
//  BezierPaths.m
//  Ija
//
//  Created by Orville on 15/2/9.
//  Copyright (c) 2015年 Orville. All rights reserved.
//

#import "BezierPaths.h"
#import "BezierPath.h"
#import "UIBezierPath+Algorithm.h"
#include "CGPath_Utilities.h"
#import "BezierElement.h"
#import "SBJson.h"

@implementation BezierPaths
@synthesize paths = _paths;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _paths = [NSMutableArray array];
    }
    return self;
}

-(instancetype)initWithJson:(NSString *)str
{
    NSDictionary* dict = [str JSONValue];
    self = [self initWithDictionary:dict];
    return self;
}

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [self init];
    if (self) {
        NSMutableArray* arrPaths = [dict objectForKey:@"paths"];
        for (NSDictionary* d in arrPaths) {
            BezierPath* p = [[BezierPath alloc] initWithDictionary:d];
            [_paths addObject:p];
        }
    }
    return self;
}

-(NSDictionary*)toDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    NSMutableArray* arrPaths = [NSMutableArray array];
    for (BezierPath* p in _paths) {
        NSDictionary* dicP = [p toDictionary];
        [arrPaths addObject:dicP];
    }
    [dict setObject:arrPaths forKey:@"paths"];
    
    return dict;
}

-(NSString*)toString
{
    NSString* jsonStr = [[self toDictionary] JSONRepresentation];
    return jsonStr;
}

-(void)closeLastPath
{
    BezierPath* p = [_paths lastObject];
    BezierElement* firstEle = [p.elements firstObject];
    BezierElement* lastEle = [p.elements lastObject];
    if (firstEle && lastEle && firstEle != lastEle) {
        if (lastEle.kind != kCGPathElementCloseSubpath) {
            if (!CGPointEqualToPoint(firstEle.point, lastEle.point)) {
                [p moveToPoint:firstEle.point];
            }
        }
    }
}

-(void)closePath
{
    
}

-(int)addEmptyPath
{
    BezierPath* p = [_paths lastObject];
    if (p && p.elements.count == 0) {
        return (int)(_paths.count - 1);
    }
    
    p = [[BezierPath alloc] init];
    [_paths addObject:p];
    
    return (int)(_paths.count - 1);
}

-(void)removePathAtIndex:(int)index
{
    if (_paths.count > 0 && index < _paths.count && index >= 0) {
        [_paths removeObjectAtIndex:index];
    }
}

-(void)removeLastPath
{
    if (_paths.count > 0) {
        [_paths removeObjectAtIndex:_paths.count-1];
    }
}

-(UIBezierPath*)toBezierPath
{
//    - (void)moveToPoint:(CGPoint)point;
//    - (void)addLineToPoint:(CGPoint)point;
//    - (void)addCurveToPoint:(CGPoint)endPoint controlPoint1:(CGPoint)controlPoint1 controlPoint2:(CGPoint)controlPoint2;
//    - (void)addQuadCurveToPoint:(CGPoint)endPoint controlPoint:(CGPoint)controlPoint;
//    - (void)addArcWithCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise NS_AVAILABLE_IOS(4_0);
//    - (void)closePath;
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    
    for (BezierPath* path in _paths) {
        [path appendToBezierPath:bezierPath];
    }
    
    return bezierPath;
}

-(UIBezierPath*)toBezierPathWithPoints:(NSMutableArray*)points forPathIndex:(int)pathIndex
{
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    
    for (int i = 0; i < _paths.count; i++) {
        BezierPath* path = [_paths objectAtIndex:i];
        if (i == pathIndex) {
            [path appendToBezierPath:bezierPath withPoints:points];
        }
        else {
            [path appendToBezierPath:bezierPath];
        }
    }
    
    return bezierPath;
}

-(UIBezierPath*)toBezierPathWithPoints:(NSMutableArray*)points controlPointIndexes:(NSMutableArray*)controlPointIndexes forPathIndex:(int)pathIndex
{
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    
    for (int i = 0; i < _paths.count; i++) {
        BezierPath* path = [_paths objectAtIndex:i];
        if (i == pathIndex) {
            [path appendToBezierPath:bezierPath withPoints:points controlPointIndexes:controlPointIndexes];
        }
        else {
            [path appendToBezierPath:bezierPath];
        }
    }
    
    return bezierPath;
}

-(void)replacePoint:(CGPoint)point atPointIndex:(int)index forPathIndex:(int)pathIndex
{
    if (pathIndex < _paths.count) {
        BezierPath* path = [_paths objectAtIndex:pathIndex];
        [path replacePoint:point atPointIndex:index];
    }
}

-(UIBezierPath*)toBezierPathFromSize:(CGSize)fromSize toSize:(CGSize)toSize
{
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    
    for (BezierPath* path in _paths) {
        [path appendToBezierPath:bezierPath fromSize:fromSize toSize:toSize];
    }
    
    return bezierPath;
}

-(instancetype)initWithBezierPath:(UIBezierPath*)bzp
{
    self = [self init];
    if (self) {
        CGPathRef path = bzp.CGPath;
        // A bezier graph is made up of contours, which are closed paths of curves. Anytime we
        //  see a move to in the NSBezierPath, that's a new contour.
//        MWPoint lastPoint = MWPointZeroMake();
//        _contours = [[NSMutableArray alloc] initWithCapacity:2];
        
        BezierPath *bezierPath = nil;
        NSUInteger elementCount = CGPath_MWElementCount(path);
        for (NSUInteger i = 0; i < elementCount; i++) {
            FBBezierElement element = CGPath_FBElementAtIndex(path, i);
            
            switch (element.kind) {
                case kCGPathElementMoveToPoint:
                {
                    // Start a new contour
                    bezierPath = [[BezierPath alloc] init];
                    [_paths addObject:bezierPath];
                    [bezierPath moveToPoint:element.point];
                    break;
                }
                case kCGPathElementAddLineToPoint: {
                    [bezierPath addLineToPoint:element.point];
                    break;
                }
                    
                case kCGPathElementAddCurveToPoint:
                {
                    [bezierPath addCurveToPoint:element.point controlPoint1:element.controlPoints[0] controlPoint2:element.controlPoints[1]];
                    break;
                }
                    
                case kCGPathElementCloseSubpath:
                {
                    [bezierPath closeSubpath];
                    break;
                }
                case kCGPathElementAddQuadCurveToPoint:
                {
                    [bezierPath addQuadCurveToPoint:element.point controlPoint:element.controlPoints[0]];
                    break;
                }
                default:
                    NSLog(@"%s  Encountered unhandled element type (quad curve)", __PRETTY_FUNCTION__);
                    break;
            }
        }
    }
    
    return self;
}

//- (id) initWithBezierPath:(CGPathRef)path
//{
//    self = [super init];
//    
//    if ( self != nil ) {
//        // A bezier graph is made up of contours, which are closed paths of curves. Anytime we
//        //  see a move to in the NSBezierPath, that's a new contour.
//        MWPoint lastPoint = MWPointZeroMake();
//        _contours = [[NSMutableArray alloc] initWithCapacity:2];
//        
//        FBBezierContour *contour = nil;
//        NSUInteger elementCount = CGPath_MWElementCount(path);
//        for (NSUInteger i = 0; i < elementCount; i++) {
//            FBBezierElement element = CGPath_FBElementAtIndex(path, i);
//            
//            switch (element.kind) {
//                case kCGPathElementMoveToPoint:
//                    // Start a new contour
//                    contour = [[FBBezierContour alloc] init];
//                    [self addContour:contour];
//                    lastPoint = MWPointFromCGPoint(element.point);
//                    break;
//                    
//                case kCGPathElementAddLineToPoint: {
//                    // [MO] skip degenerate line segments
//                    if (!MWPointEqualToPoint(MWPointFromCGPoint(element.point), lastPoint)) {
//                        // Convert lines to bezier curves as well. Just set control point to be in the line formed
//                        //  by the end points
//                        FBBezierCurve *curve = [FBBezierCurve bezierCurveWithLineStartPoint:lastPoint endPoint:MWPointFromCGPoint(element.point)];
//                        [contour addCurve:curve];
//                        lastPoint = MWPointFromCGPoint(element.point);
//                    }
//                    break;
//                }
//                    
//                case kCGPathElementAddCurveToPoint:
//                {
//                    FBBezierCurve *curve = [FBBezierCurve bezierCurveWithEndPoint1:lastPoint
//                                                                     controlPoint1:MWPointFromCGPoint(element.controlPoints[0])
//                                                                     controlPoint2:MWPointFromCGPoint(element.controlPoints[1])
//                                                                         endPoint2:MWPointFromCGPoint(element.point)];
//                    [contour addCurve:curve];
//                    lastPoint = MWPointFromCGPoint(element.point);
//                    break;
//                }
//                    
//                case kCGPathElementCloseSubpath:
//                    // [MO] attempt to close the bezier contour by
//                    // mapping closepaths to equivalent lineto operations,
//                    // though as with our kCGPathElementAddLineToPoint processing,
//                    // we check so as not to add degenerate line segments which
//                    // blow up the clipping code.
//                    
//                    if ([[contour edges] count]) {
//                        FBContourEdge *firstEdge = [[contour edges] objectAtIndex:0];
//                        MWPoint        firstPoint = [[firstEdge curve] endPoint1];
//                        
//                        // Skip degenerate line segments
//                        if (!MWPointEqualToPoint(lastPoint, firstPoint)) {
//                            FBBezierCurve *curve = [FBBezierCurve bezierCurveWithLineStartPoint:lastPoint endPoint:firstPoint];
//                            [contour addCurve:curve];
//                        }
//                    }
//                    lastPoint = MWPointZeroMake();
//                    break;
//                    
//                case kCGPathElementAddQuadCurveToPoint:
//                default:
//                    NSLog(@"%s  Encountered unhandled element type (quad curve)", __PRETTY_FUNCTION__);
//                    break;
//            }
//        }
//        
//        // Go through and mark each contour if its a hole or filled region
//        for (contour in _contours)
//            contour.inside = [self contourInsides:contour];
//    }
//    
//    return self;
//}

-(BezierPaths*)unionWithPath:(BezierPaths*)thePath
{
    UIBezierPath* bzp1 = [self toBezierPath];
    UIBezierPath* bzp2 = [thePath toBezierPath];
    
    UIBezierPath* bzp = [bzp1 unionWithPath:bzp2];
    
    BezierPaths* path = [[BezierPaths alloc] initWithBezierPath:bzp];
    
    return path;
}

-(BezierPaths*)intersectWithPath:(BezierPaths*)thePath
{
    UIBezierPath* bzp1 = [self toBezierPath];
    UIBezierPath* bzp2 = [thePath toBezierPath];
    
    UIBezierPath* bzp = [bzp1 intersectWithPath:bzp2];
    
    BezierPaths* path = [[BezierPaths alloc] initWithBezierPath:bzp];
    
    return path;
}

-(BezierPaths*)differenceWithPath:(BezierPaths*)thePath
{
    UIBezierPath* bzp1 = [self toBezierPath];
    UIBezierPath* bzp2 = [thePath toBezierPath];
    
    UIBezierPath* bzp = [bzp1 differenceWithPath:bzp2];
    
    BezierPaths* path = [[BezierPaths alloc] initWithBezierPath:bzp];
    
    return path;
}

-(BezierPaths*)xorWithPath:(BezierPaths*)thePath
{
    UIBezierPath* bzp1 = [self toBezierPath];
    UIBezierPath* bzp2 = [thePath toBezierPath];
    
    UIBezierPath* bzp = [bzp1 xorWithPath:bzp2];
    
    BezierPaths* path = [[BezierPaths alloc] initWithBezierPath:bzp];
    
    return path;
}

@end
