//
//  Quadrilateral.m
//  InJa
//
//  Created by Orville on 14-2-23.
//  Copyright (c) 2014年 Orville. All rights reserved.
//

#import "Quadrilateral.h"

@implementation Quadrilateral

+(Quadrilateral*)quadWithRect:(CGRect)rect
{
    Quadrilateral* quad = [[Quadrilateral alloc] init];
    quad.topLeft = rect.origin;
    quad.topRight = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y);
    quad.bottomRight = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
    quad.bottomLeft = CGPointMake(rect.origin.x, rect.origin.y+rect.size.height);
    
    return quad;
}

+(Quadrilateral*)quadWithTopLeft:(CGPoint)tl topRight:(CGPoint)tr bottomRight:(CGPoint)br bottomLeft:(CGPoint)bl
{
    Quadrilateral* quad = [[Quadrilateral alloc] init];
    quad.topLeft = tl;
    quad.topRight = tr;
    quad.bottomRight = br;
    quad.bottomLeft = bl;
    
    return quad;
}

-(AGQuad)toAGQuad
{
    AGQuad quad = AGQuadMakeWithCGPoints(self.topLeft,
                                         self.topRight,
                                         self.bottomRight,
                                         self.bottomLeft);
    return quad;
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

-(NSString*)AGQuadToString
{
    NSMutableString* str = [NSMutableString string];
    CGPoint p = self.topLeft;
    [str appendFormat:@"%.1lf,%.1lf", p.x, p.y];
    p = self.topRight;
    [str appendFormat:@";%.1lf,%.1lf", p.x, p.y];
    p = self.bottomRight;
    [str appendFormat:@";%.1lf,%.1lf", p.x, p.y];
    p = self.bottomLeft;
    [str appendFormat:@";%.1lf,%.1lf", p.x, p.y];
    
    return str;
}

+(AGQuad)toAGQuadFromString:(NSString*)str
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
    AGQuad quad;
    if (arr.count >= 4) {
        quad = AGQuadMakeWithCGPoints([[arr objectAtIndex:0] CGPointValue],
                                      [[arr objectAtIndex:1] CGPointValue],
                                      [[arr objectAtIndex:2] CGPointValue],
                                      [[arr objectAtIndex:3] CGPointValue]);
    }
    
    return quad;
}

+(Quadrilateral*)toQuadrilateralFromString:(NSString*)str
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
    
    Quadrilateral* quad = [[Quadrilateral alloc] init];
    quad.topLeft = [[arr objectAtIndex:0] CGPointValue];
    quad.topRight = [[arr objectAtIndex:1] CGPointValue];
    quad.bottomRight = [[arr objectAtIndex:2] CGPointValue];
    quad.bottomLeft = [[arr objectAtIndex:3] CGPointValue];
    
    return quad;
}

-(AGQuad)toAGQuadWithPoints:(NSArray*)points
{//    if (points.count < 3) {
    AGQuad quad = AGQuadMakeWithCGPoints(self.topLeft,
                                             self.topRight,
                                             self.bottomRight,
                                             self.bottomLeft);
        return quad;
//    }
//    
//    //斜率
//    NSMutableArray* kArr = [NSMutableArray array];
//    CGPoint p0;
//    CGPoint p1;
//    CGFloat k;
//    for (int i=0; i<points.count-1; i++) {
//        p0 = [[points objectAtIndex:i] CGPointValue];
//        p1 = [[points objectAtIndex:i+1] CGPointValue];
//        k = (p1.y - p0.y)/(p1.x - p0.x);
//        [kArr addObject:[NSNumber numberWithFloat:k]];
//    }
//    
//    //最后一个节点连接第一条线
//    p0 = [[points objectAtIndex:0] CGPointValue];
//    k = (p1.y - p0.y)/(p1.x - p0.x);
//    [kArr addObject:[NSNumber numberWithFloat:k]];
//    
//    
//    
//    for (NSValue* value in points) {
//        CGPoint* point1 = [value CGPointValue];
//        CGPoint* point0 = [value CGPointValue];
//    }
//    AGQuad quad = AGQuadMakeWithCGPoints(self.topLeft,
//                                         self.topRight,
//                                         self.bottomRight,
//                                         self.bottomLeft);
//    return quad;
}

//计算包裹points的放大的四边形

@end
