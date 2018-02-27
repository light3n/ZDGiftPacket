//
//  UIBezierPath+Algorithm.m
//  InJa
//
//  Created by Orville on 15/1/22.
//  Copyright (c) 2015年 Orville. All rights reserved.
//

#import "UIBezierPath+Algorithm.h"
#import "CGPath_Boolean.h"

@implementation UIBezierPath(Algorithm)

-(UIBezierPath*)unionWithPath:(UIBezierPath*)path
{
    CGPathRef tmpPath = CGPath_FBCreateUnion(self.CGPath, path.CGPath);
    UIBezierPath* resultPath = [UIBezierPath bezierPathWithCGPath:tmpPath];
    CGPathRelease(tmpPath);
    
    return resultPath;
}

-(UIBezierPath*)intersectWithPath:(UIBezierPath*)path
{
    CGPathRef tmpPath = CGPath_FBCreateIntersect(self.CGPath, path.CGPath);
    UIBezierPath* resultPath = [UIBezierPath bezierPathWithCGPath:tmpPath];
    CGPathRelease(tmpPath);
    
    return resultPath;
}

-(UIBezierPath*)differenceWithPath:(UIBezierPath*)path
{
    CGPathRef tmpPath = CGPath_FBCreateDifference(self.CGPath, path.CGPath);
    UIBezierPath* resultPath = [UIBezierPath bezierPathWithCGPath:tmpPath];
    CGPathRelease(tmpPath);
    
    return resultPath;
}

-(UIBezierPath*)xorWithPath:(UIBezierPath*)path
{
    CGPathRef tmpPath = CGPath_FBCreateXOR(self.CGPath, path.CGPath);
    UIBezierPath* resultPath = [UIBezierPath bezierPathWithCGPath:tmpPath];
    CGPathRelease(tmpPath);
    
    return resultPath;
}

@end
