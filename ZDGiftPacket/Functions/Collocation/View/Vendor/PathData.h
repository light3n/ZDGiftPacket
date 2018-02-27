//
//  PathData.h
//  ija
//
//  Created by Orville on 13-12-22.
//  Copyright (c) 2013年 Orville. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ClosedDistance 15

@interface PathData : NSObject
{
    NSMutableArray* points;
}
//点集
@property (nonatomic, strong) NSMutableArray* points;
//是否闭合
@property (nonatomic, assign) BOOL hasClosed;
//当前选中的点
@property (nonatomic, assign) int selectedIndex;

@property (nonatomic, assign) BOOL noneAutoDelete;
@property (nonatomic, readonly) BOOL selectionRegionValid;

//获取最近的点
-(int)getClosedPointIndex:(CGPoint)point;

-(void)addPoint:(CGPoint)point;
-(void)addPoint:(CGPoint)point atIndex:(int)index;
-(void)replacePoint:(CGPoint)point atIndex:(int)index;

-(UIBezierPath*)toBezierPath;

//Path 转换为string
-(NSString*)pathToString;
//String转Path
+(NSMutableArray*)pointsFromString:(NSString*)str;
//String转Path对象
+(PathData*)pathFromString:(NSString*)str;

-(void)deleteLastPoint;

- (void)updatePointsWithScale:(CGFloat)scale;
// 撤销操作后更新缩放大小
- (void)updatePointsWithScaleAfterRepeal:(CGFloat)scale;

@end
