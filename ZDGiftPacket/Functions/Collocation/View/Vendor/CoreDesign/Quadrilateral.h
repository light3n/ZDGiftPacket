//
//  Quadrilateral.h
//  InJa
//
//  Created by Orville on 14-2-23.
//  Copyright (c) 2014年 Orville. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGQuad.h"


typedef enum _DesignActionMode {
    DesignActionModeWaiting = 0,
    DesignActionModeSelection = 1,
    DesignActionModePerspective = 2,
    DesignActionModeScale = 3,
} DesignActionMode;

@interface Quadrilateral : NSObject

@property (nonatomic, assign) CGPoint topLeft;
@property (nonatomic, assign) CGPoint topRight;
@property (nonatomic, assign) CGPoint bottomRight;
@property (nonatomic, assign) CGPoint bottomLeft;

+(Quadrilateral*)quadWithRect:(CGRect)rect;
+(Quadrilateral*)quadWithTopLeft:(CGPoint)tl topRight:(CGPoint)tr bottomRight:(CGPoint)br bottomLeft:(CGPoint)bl;

-(AGQuad)toAGQuad;

-(AGQuad)toAGQuadWithPoints:(NSArray*)points;

//透视字符串数据
-(NSString*)AGQuadToString;
//字符串 to 透视数据
+(AGQuad)toAGQuadFromString:(NSString*)str;
+(NSMutableArray*)pointsFromString:(NSString*)str;
+(Quadrilateral*)toQuadrilateralFromString:(NSString*)str;

@end
