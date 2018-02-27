//
//  GeometryDesignView.m
//  ija
//
//  Created by Orville on 13-12-22.
//  Copyright (c) 2013年 Orville. All rights reserved.
//

#import "QuadrilateralDesignView.h"
#import <QuartzCore/QuartzCore.h>

#define k_POINT_WIDTH 30

@interface QuadrilateralDesignView ()
@property (nonatomic, strong) UIButton *moveCrossBtn;
@property (nonatomic, copy) NSArray *originPathDataPoints;
@end

@implementation QuadrilateralDesignView
@synthesize pathData;
@synthesize designMode;
@synthesize pointViews;
@synthesize quadrilateral;
@synthesize delegate;
@synthesize isNotShowPoint;

- (id)init
{
    self = [super init];
    if (self) {
        [self buildInitData];
    }
    return self;
}

-(void)buildInitData
{
    //显示点
    self.designMode = DesignModeSelection;
    
    
    //    self.pathData = [[PathData alloc] init];
    //
    //    [pathData addPoint:CGPointMake(s.width/4, s.height/4)];
    //    [pathData addPoint:CGPointMake(s.width*3/4, s.height/4)];
    //    [pathData addPoint:CGPointMake(s.width*3/4, s.height*3/4)];
    //    [pathData addPoint:CGPointMake(s.width/4, s.height*3/4)];
    //    pathData.hasClosed = YES;
    
    
    
    self.lineColor       = [UIColor yellowColor];
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds   = YES;
    self.pointColor      = [UIColor blueColor];
    self.pointViews = [NSMutableArray array];
    
    // ”可移动提示“按钮
    _moveCrossBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moveCrossBtn setImage:[UIImage imageNamed:@"move_cross"] forState:UIControlStateNormal];
    _moveCrossBtn.frame = CGRectMake(0, 0, 40, 40);
    _moveCrossBtn.center = self.center;
    [self addSubview:_moveCrossBtn];
    // <1>. 拖拽手势 -> 移动贴图
    UIPanGestureRecognizer *buttonPanGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveCrossBtnPanGestureHandle:)];
    [_moveCrossBtn addGestureRecognizer:buttonPanGes];
//    // <2>. 双击手势 -> Duplicate 贴图
//    UITapGestureRecognizer *buttonTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moveCrossBtnTapGestureHandle:)];
//    buttonTapGes.numberOfTapsRequired = 2; // 双击
//    [_moveCrossBtn addGestureRecognizer:buttonTapGes];
    
    //设置默认四边形
    CGSize s = self.frame.size;
    self.quadrilateral = [Quadrilateral quadWithTopLeft:CGPointMake(0, 0)
                                               topRight:CGPointMake(0, s.width)
                                            bottomRight:CGPointMake(s.width, s.height)
                                             bottomLeft:CGPointMake(0, s.height)];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGesture];
    
    //创建鼠标平移手势
    //创建一个平移手势对象，该对象可以调用handelPan：方法
    UIPanGestureRecognizer* panGesture =[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:panGesture];
}

-(void)setIsNotShowPoint:(BOOL)value
{
    isNotShowPoint = value;
    [self setNeedsDisplay];
}

-(void)setQuadrilateral:(Quadrilateral*)quad
{
    quadrilateral = quad;
    
    
    self.pathData = [[PathData alloc] init];
    pathData.noneAutoDelete = YES;
    
    [pathData addPoint:quad.topLeft];
    [pathData addPoint:quad.topRight];
    [pathData addPoint:quad.bottomRight];
    [pathData addPoint:quad.bottomLeft];
    pathData.hasClosed = YES;
    
    [self setNeedsDisplay];
}

#pragma mark -  moveCrossBtn Event Handle
// 拖拽
- (void)moveCrossBtnPanGestureHandle:(UIPanGestureRecognizer *)panGesture {
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        self.originPathDataPoints = [NSArray arrayWithArray:pathData.points];
        
    } else if (panGesture.state == UIGestureRecognizerStateChanged) {
        if (pathData.points.count == 0) { return; }
        CGPoint transPoint = [panGesture translationInView:self];
        for (uint i = 0; i < pathData.points.count; i++) {
            CGFloat tmpPointX = [[self.originPathDataPoints objectAtIndex:i] CGPointValue].x + transPoint.x;
            CGFloat tmpPointY = [[self.originPathDataPoints objectAtIndex:i] CGPointValue].y + transPoint.y;
            CGPoint tmpPoint = CGPointMake(tmpPointX, tmpPointY);
            [pathData replacePoint:tmpPoint atIndex:i];
        }
        [self setNeedsDisplay];
        [self refreshQuad];
        
    } else if (panGesture.state == UIGestureRecognizerStateEnded) {
        if (pathData.points.count == 0) { return; }
        CGPoint transPoint = [panGesture translationInView:self];
        for (uint i = 0; i < pathData.points.count; i++) {
            CGFloat tmpPointX = [[self.originPathDataPoints objectAtIndex:i] CGPointValue].x + transPoint.x;
            CGFloat tmpPointY = [[self.originPathDataPoints objectAtIndex:i] CGPointValue].y + transPoint.y;
            CGPoint tmpPoint = CGPointMake(tmpPointX, tmpPointY);
            [pathData replacePoint:tmpPoint atIndex:i];
        }
        [self setNeedsDisplay];
        [self refreshQuad];
        self.originPathDataPoints = nil;
        
    } else if (panGesture.state == UIGestureRecognizerStateCancelled
               || panGesture.state == UIGestureRecognizerStateFailed) {
        self.originPathDataPoints = nil;
    }
}

//// 双击
//- (void)moveCrossBtnTapGestureHandle:(UITapGestureRecognizer *)tapGesture {
//    
//}

- (void)handlePan:(UIPanGestureRecognizer*)panGesture{
    
    if (panGesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [panGesture locationInView:self];
        
        NSLog(@"Pan Point: (%f, %f)", point.x, point.y);
        
        // 根据点击区域判断属于哪个范围（左上/右上/左下/右下）
        int index = [pathData getClosedPointIndex:point];
        panIndex = index;
        NSLog(@"Pan Index: %d", panIndex);
        if (panIndex >= 0)
            orgPoint = [[pathData.points objectAtIndex:panIndex] CGPointValue];
    }
    else if (panGesture.state == UIGestureRecognizerStateChanged)
    {
        if (pathData.points.count == 0)
            return;
        
        CGPoint point = [panGesture translationInView:self];
        CGPoint activePoint = CGPointMake(orgPoint.x+point.x, orgPoint.y+point.y);
        [pathData replacePoint:activePoint atIndex:panIndex];
        [self setNeedsDisplay];
        
        [self refreshQuad];
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded)
    {
        if (pathData.points.count == 0)
            return;
        
        CGPoint point = [panGesture translationInView:self];
        CGPoint activePoint = CGPointMake(orgPoint.x+point.x, orgPoint.y+point.y);
        [pathData replacePoint:activePoint atIndex:panIndex];
        [self setNeedsDisplay];
        
        orgPoint = CGPointZero;
        
        [self refreshQuad];
    }
    else if (panGesture.state == UIGestureRecognizerStateCancelled || panGesture.state == UIGestureRecognizerStateFailed)
    {
        // 拖拽手势被中断时 恢复初始point -> oripoint
        CGPoint activePoint = orgPoint;
        [pathData replacePoint:activePoint atIndex:panIndex];
        panIndex = 0;
        [self setNeedsDisplay];
        
        [self refreshQuad];
    }
}

-(void)refreshQuad
{
    CGPoint topLeft =     [[pathData.points objectAtIndex:0] CGPointValue];
    CGPoint topRight =    [[pathData.points objectAtIndex:1] CGPointValue];
    CGPoint bottomRight = [[pathData.points objectAtIndex:2] CGPointValue];
    CGPoint bottomLeft =  [[pathData.points objectAtIndex:3] CGPointValue];
    quadrilateral = [Quadrilateral quadWithTopLeft:topLeft
                                          topRight:topRight
                                       bottomRight:bottomRight
                                        bottomLeft:bottomLeft];
    if (delegate && [delegate respondsToSelector:@selector(quadChanged:)]) {
        [delegate quadChanged:quadrilateral];
    }
    
    // 实时回调中点值
    CGPoint topCenter =            [self sp_getCenterPointWithPoint1:topLeft    point2:topRight];
    CGPoint bottomCenter =         [self sp_getCenterPointWithPoint1:bottomLeft point2:bottomRight];
    CGPoint moveCrossFinalCenter = [self sp_getCenterPointWithPoint1:topCenter  point2:bottomCenter];
    self.moveCrossBtn.center = moveCrossFinalCenter;
    
}

/**
 *  取出两个点之间的中点
 */
- (CGPoint)sp_getCenterPointWithPoint1:(CGPoint)point1 point2:(CGPoint)point2 {
    return CGPointMake( ABS((point1.x - point2.x) / 2 - point1.x),
                       ABS((point1.y - point2.y) / 2 - point1.y) );
}

//- (void)panInDeviceListScrollView:(UIPanGestureRecognizer *)panGesture
//{
//	if (panGesture.state == UIGestureRecognizerStateChanged)
//    {
//        topLineImageView.hidden = YES;
//        CGFloat totalHeight = self.view.superview.frame.size.height;
//        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, totalHeight);
//
//        CGFloat translation = [panGesture translationInView:arrowButton].y;
//        self.view.transform = CGAffineTransformMakeTranslation(0, translation+currentTranslate);
//	}
//    else if (panGestureReconginzer.state == UIGestureRecognizerStateEnded)
//    {
//        [self moveAnimationWithDirection];
//	}
//}

- (IBAction)handleTap:(UITapGestureRecognizer*)recognizer
{
    //    CGPoint point = [recognizer locationInView:self];
    //
    //    [pathData addPoint:point];
    //    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildInitData];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self buildInitData];
    }
    return self;
}

-(BOOL)isSelectionMode
{
    return designMode == DesignModeSelection;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    if (pathData.points.count <= 0) return;
    
    // get the current context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(context, self.frame);
    
    const CGFloat *components = CGColorGetComponents(self.lineColor.CGColor);
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    
    if(CGColorGetNumberOfComponents(self.lineColor.CGColor) == 2)
    {
        red   = 1;
        green = 1;
        blue  = 1;
        alpha = 1;
    }
    else
    {
        red   = components[0];
        green = components[1];
        blue  = components[2];
        alpha = components[3];
        if (alpha <= 0) alpha = 1;
    }
    
    float lineWidth = 2.0;
    
    if (!isNotShowPoint) {
        // set the stroke color and width
        CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
        CGContextSetLineWidth(context, lineWidth);
        
        CGPoint point1 = [[pathData.points objectAtIndex:0] CGPointValue];
        CGContextMoveToPoint(context, point1.x, point1.y);
        
        for (uint i=1; i<pathData.points.count; i++)
        {
            CGPoint point = [[pathData.points objectAtIndex:i] CGPointValue];
            CGContextAddLineToPoint(context, point.x, point.y);
        }
        
        if (pathData.hasClosed) {
            CGContextAddLineToPoint(context, point1.x, point1.y);
        }
        
        // tell the context to draw the stroked line
        CGContextStrokePath(context);
    }
    
    
    if (!isNotShowPoint&&!self.isSelectionMode && pathData.selectedIndex >= 0) {
        CGPoint selPoint = [[pathData.points objectAtIndex:pathData.selectedIndex] CGPointValue];
        [[UIColor redColor] setFill];
        CGContextFillRect(context, CGRectMake(selPoint.x-1,selPoint.y-1,lineWidth+1,lineWidth+1));
    }
    
    if (!isNotShowPoint && self.isSelectionMode) {
        [self generatePointViews];
    }
    else {
        [self clearPointViews];
    }
    
    if (!isNotShowPoint && self.designMode == DesignModeCurtain) {
        [self generatePointViews];
    }
}

-(void)generatePointViews
{
    [self clearPointViews];
    
    int count = (int)pathData.points.count;
    for (int i = 0; i < count; i++) {
        CGPoint p = [[pathData.points objectAtIndex:i] CGPointValue];
        UIView* pv = [self getPointView:i+1 at:p];
        [pointViews addObject:pv];
        [self addSubview:pv];
    }
    self.moveCrossBtn.hidden = NO;
}

-(void)clearPointViews
{
    for (UIView* pv in pointViews) {
        [pv removeFromSuperview];
    }
    [pointViews removeAllObjects];
    self.moveCrossBtn.hidden = YES;
}

- (UIView *)getPointView:(int)num at:(CGPoint)point
{
    UIView *point1 = [[UIView alloc] initWithFrame:CGRectMake(point.x -k_POINT_WIDTH/2, point.y-k_POINT_WIDTH/2, k_POINT_WIDTH, k_POINT_WIDTH)];
    point1.alpha = 0.8;
    point1.backgroundColor    = self.pointColor;
    point1.layer.borderColor  = self.lineColor.CGColor;
    point1.layer.borderWidth  = 4;
    point1.layer.cornerRadius = k_POINT_WIDTH/2;
    
    UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, k_POINT_WIDTH, k_POINT_WIDTH)];
    number.text = [NSString stringWithFormat:@"%d",num];
    number.textColor = [UIColor whiteColor];
    number.backgroundColor = [UIColor clearColor];
    number.font = [UIFont systemFontOfSize:14];
    number.textAlignment = NSTextAlignmentCenter;
    
    [point1 addSubview:number];
    
    return point1;
}

@end
