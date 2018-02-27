//
//  CoreMath.m
//  ija
//
//  Created by Orville on 13-12-23.
//  Copyright (c) 2013年 Orville. All rights reserved.
//

#import "CoreMath.h"

@implementation CoreMath

+(float)distanceBetween:(CGPoint)p1 and:(CGPoint)p2
{
    return sqrt(pow(p2.x-p1.x,2)+pow(p2.y-p1.y,2));
    
//    return sqrt((p2.x-p1.x)*(p2.x-p1.x)+(p2.y-p1.y)*(p2.y-p1.y));
}

@end
