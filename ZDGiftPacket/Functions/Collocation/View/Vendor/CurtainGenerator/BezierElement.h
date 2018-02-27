//
//  BezierElement.h
//  Ija
//
//  Created by Orville on 15/2/9.
//  Copyright (c) 2015年 Orville. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BezierElement : NSObject

@property(nonatomic, assign) CGPathElementType kind;
@property(nonatomic, assign) CGPoint point;
@property(nonatomic, assign) CGPoint controlPoint1;
@property(nonatomic, assign) CGPoint controlPoint2;

-(NSDictionary*)toDictionary;
-(instancetype)initWithDictionary:(NSDictionary *)dict;


@end
