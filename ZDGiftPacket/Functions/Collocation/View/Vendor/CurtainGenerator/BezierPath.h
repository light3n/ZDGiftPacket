//
//  BezierPath.h
//  Ija
//
//  Created by Orville on 15/2/9.
//  Copyright (c) 2015年 Orville. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BezierPath : NSObject
{
    NSMutableArray* _elements;
}

@property (nonatomic, assign, readonly) CGRect bounds;
@property (nonatomic, strong, readonly) NSArray* elements;

-(void)appendToBezierPath:(UIBezierPath*)bzp;
-(void)appendToBezierPath:(UIBezierPath*)bzp withPoints:(NSMutableArray*)points;
-(void)appendToBezierPath:(UIBezierPath*)bzp withPoints:(NSMutableArray*)points controlPointIndexes:(NSMutableArray*)controlPointIndexes;
-(int)addPoint:(CGPoint)point belowIndex:(int)index;
-(void)replacePoint:(CGPoint)point atPointIndex:(int)index;
-(void)appendToBezierPath:(UIBezierPath*)bzp fromSize:(CGSize)fromSize toSize:(CGSize)toSize;

-(void)moveToFirstPoint;

-(void)moveToPoint:(CGPoint)point;
-(void)addLineToPoint:(CGPoint)point;
-(void)addQuadCurveToPoint:(CGPoint)point controlPoint:(CGPoint)controlPoint1;
-(void)addCurveToPoint:(CGPoint)point controlPoint1:(CGPoint)controlPoint1 controlPoint2:(CGPoint)controlPoint2;
-(void)closeSubpath;


-(void)removeLastElement;
-(int)removeElementAtIndex:(int)index;

-(NSDictionary*)toDictionary;
-(instancetype)initWithDictionary:(NSDictionary *)dict;


- (void)updatePointsWithScale:(CGFloat)scale;
// 撤销操作后更新缩放大小
- (void)updatePointsWithScaleAfterRepeal:(CGFloat)scale;

@end
