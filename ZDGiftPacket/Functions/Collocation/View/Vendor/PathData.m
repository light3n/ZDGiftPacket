//
//  PathData.m
//  ija
//
//  Created by Orville on 13-12-22.
//  Copyright (c) 2013年 Orville. All rights reserved.
//

#import "PathData.h"
#import "CoreMath.h"

@implementation PathData
@synthesize points;
@synthesize hasClosed;
@synthesize selectedIndex;

- (id)init
{
    self = [super init];
    if (self) {
        self.points = [NSMutableArray array];
        self.selectedIndex = -1;
    }
    return self;
}

-(NSString*)pathToString
{
    if (points.count == 0) {
        return @"";
    }
    NSMutableString* str = [NSMutableString string];
    for (uint i=0; i<points.count; i++)
    {
        CGPoint p = [[points objectAtIndex:i] CGPointValue];
        if (str.length == 0) {
            [str appendFormat:@"%.1lf,%.1lf", p.x, p.y];
        }
        else {
            [str appendFormat:@";%.1lf,%.1lf", p.x, p.y];
        }
    }
    
    return str;
}

+(NSMutableArray*)pointsFromString:(NSString*)str
{
    NSMutableArray* arr = [NSMutableArray array];
    NSArray* comps = [str componentsSeparatedByString:@";"];
    for (NSString* strP in comps) {
        NSArray* pComps = [strP componentsSeparatedByString:@","];
        CGFloat x = [[pComps objectAtIndex:0] floatValue];
        CGFloat y = [[pComps objectAtIndex:1] floatValue];
        CGPoint p = CGPointMake(x, y);
        NSValue* vp = [NSValue valueWithCGPoint:p];
        [arr addObject:vp];
    }
    
    return arr;
}

+(PathData*)pathFromString:(NSString*)str
{
    PathData* pd = [[PathData alloc] init];
    pd.points = [self pointsFromString:str];
    pd.selectedIndex = (int)pd.points.count - 1;
    pd.hasClosed = YES;
    
    return pd;
}

//获取最近的点
-(int)getClosedPointIndex:(CGPoint)point
{
    int result = -1;
    float minDistance = INTMAX_MAX;
    for (int i = 0; i < points.count; i++) {
        CGPoint p = [[points objectAtIndex:i] CGPointValue];
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

-(void)deleteLastPoint
{
    if (points.count > 0) {
        [points removeLastObject];
        self.selectedIndex = (int)(points.count-1);
    }
}

-(void)addPoint:(CGPoint)point
{
    if (points.count > 2 && !self.noneAutoDelete) {
        CGPoint p1 = [[points objectAtIndex:0] CGPointValue];
        float distance = [CoreMath distanceBetween:p1 and:point];
        if (distance <= ClosedDistance) {
            self.hasClosed = YES;
            return;
        }
    }
    
    self.selectedIndex = (int)points.count;
    [points addObject:[NSValue valueWithCGPoint:point]];
}

-(void)addPoint:(CGPoint)point atIndex:(int)index
{
    if (points.count > 2 && !hasClosed && index==(points.count-1)&& !self.noneAutoDelete) {
        CGPoint p1 = [[points objectAtIndex:0] CGPointValue];
        float distance = [CoreMath distanceBetween:p1 and:point];
        if (distance <= ClosedDistance) {
            self.hasClosed = YES;
            return;
        }
    }
    
    self.selectedIndex = index;
    [points insertObject:[NSValue valueWithCGPoint:point] atIndex:index];
}

-(void)replacePoint:(CGPoint)point atIndex:(int)index
{
    if (!self.noneAutoDelete) {
        //移动时，自动闭合
        if (points.count > 3 && !hasClosed && index==(points.count-1)) {
            CGPoint p1 = [[points objectAtIndex:0] CGPointValue];
            float distance = [CoreMath distanceBetween:p1 and:point];
            if (distance <= ClosedDistance) {
                self.hasClosed = YES;
                [points removeObjectAtIndex:index];
                return;
            }
        }
        
        //移动时，自动闭合后的索引越界
        if (index >= points.count) {
            return;
        }
    }
    
//    self.selectedIndex = index;
    [points replaceObjectAtIndex:index withObject:[NSValue valueWithCGPoint:point]];
}

// 返回 根据已有point画出的多边形
-(UIBezierPath*)toBezierPath
{
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    
    // Set the starting point of the shape.
    if (points.count == 0) {
        return nil;
    }
    CGPoint p1 = [[points objectAtIndex:0] CGPointValue];
    [aPath moveToPoint:CGPointMake(p1.x, p1.y)];
    
    for (uint i=1; i<points.count; i++)
    {
        CGPoint p = [[points objectAtIndex:i] CGPointValue];
        [aPath addLineToPoint:CGPointMake(p.x, p.y)];
    }
    [aPath closePath];
    
    return aPath;
}

static CGFloat previousScale = 1;
- (void)updatePointsWithScale:(CGFloat)scale {
    // 不管有没有point 都需要记录上一个缩放数值previousScale
    CGFloat actualScale = scale / previousScale;
    previousScale = scale;
    if (points.count == 0) {
        return;
    }
    for (int i=0; i<points.count; i++) {
        CGPoint p = [[points objectAtIndex:i] CGPointValue];
        p.x = p.x * actualScale;
        p.y = p.y * actualScale;
        [points replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:p]];
    }
}


- (void)updatePointsWithScaleAfterRepeal:(CGFloat)scale {
    if (points.count == 0) {
        return;
    }
    for (int i=0; i<points.count; i++) {
        CGPoint p = [[points objectAtIndex:i] CGPointValue];
        p.x = p.x * scale;
        p.y = p.y * scale;
        [points replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:p]];
    }
}

@end
