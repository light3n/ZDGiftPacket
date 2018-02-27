//
//  PathDisplayView.m
//  Ija
//
//  Created by Orville on 15/7/9.
//  Copyright (c) 2015年 Orville. All rights reserved.
//

#import "PathDisplayView.h"
#import "BezierPaths.h"

@interface PathDisplayView()

@property (nonatomic, strong) UIBezierPath* drawPath;

@end

@implementation PathDisplayView
@synthesize paths;
@synthesize drawPath;


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    if (drawPath) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextClearRect(context, self.frame);
        
        CGContextSetRGBStrokeColor(context, 100/255.0, 100/255.0, 100/255.0, 0.7);
        CGContextSetLineWidth(context, 0.5);
        [drawPath stroke];
        
        // tell the context to draw the stroked line
        CGContextStrokePath(context);
    }
    else {
        [super drawRect:rect];
    }

}

-(void)setPaths:(NSArray *)thePaths
{
    paths = thePaths;
    
    UIBezierPath* bzPath = [UIBezierPath bezierPath];
    for (BezierPaths* bp in paths) {
        UIBezierPath* pathItem = [bp toBezierPath];
        [bzPath appendPath:pathItem];
    }
    
    self.drawPath = bzPath;
    [self setNeedsDisplay];
}

@end
