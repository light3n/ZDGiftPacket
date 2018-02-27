//
//  UIBezierPath+Algorithm.h
//  InJa
//
//  Created by Orville on 15/1/22.
//  Copyright (c) 2015年 Orville. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIBezierPath(Algorithm)

-(UIBezierPath*)unionWithPath:(UIBezierPath*)path;
-(UIBezierPath*)intersectWithPath:(UIBezierPath*)path;
-(UIBezierPath*)differenceWithPath:(UIBezierPath*)path;
-(UIBezierPath*)xorWithPath:(UIBezierPath*)path;

@end
