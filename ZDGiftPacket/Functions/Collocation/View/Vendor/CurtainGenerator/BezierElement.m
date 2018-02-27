//
//  BezierElement.m
//  Ija
//
//  Created by Orville on 15/2/9.
//  Copyright (c) 2015年 Orville. All rights reserved.
//

#import "BezierElement.h"

@implementation BezierElement
@synthesize kind;
@synthesize point;
@synthesize controlPoint1;
@synthesize controlPoint2;

- (instancetype)init
{
    self = [super init];
    if (self) {
        point = CGPointZero;
        controlPoint1 = CGPointZero;
        controlPoint2 = CGPointZero;
    }
    return self;
}

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [self init];
    if (self) {
        kind = [[dict objectForKey:@"kind"] intValue];
        point = CGPointFromString([dict objectForKey:@"point"]);
        controlPoint1 = CGPointFromString([dict objectForKey:@"controlPoint1"]);
        controlPoint2 = CGPointFromString([dict objectForKey:@"controlPoint2"]);
    }
    return self;
}

-(NSDictionary*)toDictionary
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[NSNumber numberWithInt:kind] forKey:@"kind"];
    [dict setObject:NSStringFromCGPoint(point) forKey:@"point"];
    [dict setObject:NSStringFromCGPoint(controlPoint1) forKey:@"controlPoint1"];
    [dict setObject:NSStringFromCGPoint(controlPoint2) forKey:@"controlPoint2"];
    
    return dict;
}

@end
