//
//  BezierPaths.h
//  Ija
//
//  Created by Orville on 15/2/9.
//  Copyright (c) 2015年 Orville. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BezierPaths : NSObject
{
    NSMutableArray* _paths;
}

//BezierPath list
@property (nonatomic, strong, readonly) NSArray* paths;

// return current empty Path index
-(int)addEmptyPath;
-(void)removeLastPath;
-(void)removePathAtIndex:(int)index;

-(UIBezierPath*)toBezierPath;
-(UIBezierPath*)toBezierPathWithPoints:(NSMutableArray*)points forPathIndex:(int)pathIndex;
-(UIBezierPath*)toBezierPathWithPoints:(NSMutableArray*)points controlPointIndexes:(NSMutableArray*)controlPointIndexes forPathIndex:(int)pathIndex;
-(void)replacePoint:(CGPoint)point atPointIndex:(int)index forPathIndex:(int)pathIndex;

-(UIBezierPath*)toBezierPathFromSize:(CGSize)fromSize toSize:(CGSize)toSize;

-(instancetype)initWithBezierPath:(UIBezierPath*)bzp;

-(BezierPaths*)unionWithPath:(BezierPaths*)thePath;
-(BezierPaths*)intersectWithPath:(BezierPaths*)thePath;
-(BezierPaths*)differenceWithPath:(BezierPaths*)thePath;
-(BezierPaths*)xorWithPath:(BezierPaths*)thePath;

-(void)closeLastPath;
-(void)closePath;

-(NSDictionary*)toDictionary;
-(NSString*)toString;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
-(instancetype)initWithJson:(NSString *)str;

@end
