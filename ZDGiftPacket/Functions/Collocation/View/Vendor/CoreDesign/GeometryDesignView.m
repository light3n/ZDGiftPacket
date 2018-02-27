//
//  GeometryDesignView.m
//  ija
//
//  Created by Orville on 13-12-22.
//  Copyright (c) 2013年 Orville. All rights reserved.
//

#import "GeometryDesignView.h"
#import <QuartzCore/QuartzCore.h>

#define k_POINT_WIDTH 30
// 放大镜显示延迟
static CGFloat const kACMagnifyingViewDefaultShowDelay = 0.2;

@interface GeometryDesignView ()
@property (nonatomic, strong) UIPanGestureRecognizer *panGes;
// pathData备份（用户撤销操作用）
@property (nonatomic, strong) NSMutableArray *pathDataArray;
// 缩放大小备份：在每一次pathData备份时，都记录当前缩放大小
@property (nonatomic, strong) NSMutableArray *scaleArray;

@property (nonatomic, strong) CALayer *pointLayer;

// 放大镜定时器
@property (nonatomic, retain) NSTimer *touchTimer;

@end

@implementation GeometryDesignView
@synthesize pathData;
@synthesize designMode;
@synthesize pointViews;
@synthesize delegate;

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
    self.pathData = [[PathData alloc] init];
    self.lineColor       = [UIColor yellowColor];
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds   = YES;
    self.pointColor      = [UIColor blueColor];
    self.pointViews = [NSMutableArray array];
    self.lineation = NO;
    self.pathDataArray = [NSMutableArray array];
    self.scaleArray = [NSMutableArray array];
    self.currentScale = 1.0f;
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGesture];
    
    //创建鼠标平移手势
    //创建一个平移手势对象，该对象可以调用handelPan：方法
    UIPanGestureRecognizer* panGesture =[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    /*** 设置为NO不会导致touchesCancelled:自动调用 ***/
    panGesture.cancelsTouchesInView = NO;
    [self addGestureRecognizer:panGesture];
    self.panGes = panGesture;
}

- (void)setLineation:(BOOL)lineation {
    _lineation = lineation;
    
    // 划线取点 删除手势
    if (lineation) {
        [self removeGestureRecognizer:self.panGes];
    // 点线取点 添加手势
    } else {
        
        UIPanGestureRecognizer* panGesture =[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        
        panGesture.cancelsTouchesInView = NO;
        [self addGestureRecognizer:panGesture];
        self.panGes = panGesture;
    }
}

- (void)handlePan:(UIPanGestureRecognizer*)panGesture {
    if (self.isLineation) { return; }
    
    if (panGesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [panGesture locationInView:self];
        
        NSLog(@"Pan Point: (%f, %f)", point.x, point.y);
        
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
        
        [self sp_updateDisplay];
//        [self setNeedsDisplay];
        
        if (delegate) {
            [delegate selectionGeometryChanged] ;
        }
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded)
    {
        if (pathData.points.count == 0)
            return;
        
        CGPoint point = [panGesture translationInView:self];
        CGPoint activePoint = CGPointMake(orgPoint.x+point.x, orgPoint.y+point.y);
        [pathData replacePoint:activePoint atIndex:panIndex];
        
        [self sp_updateDisplay];
//        [self setNeedsDisplay];
        [self.pathDataArray addObject:[pathData.points mutableCopy]];
        [self.scaleArray addObject:[NSNumber numberWithFloat:self.currentScale]];
        
        orgPoint = CGPointZero;
        
        if (delegate) {
            [delegate selectionRegionValidChanged:pathData.selectionRegionValid];
            [delegate selectionGeometryChanged];
        }
    }
    else if (panGesture.state == UIGestureRecognizerStateCancelled || panGesture.state == UIGestureRecognizerStateFailed)
    {
        CGPoint activePoint = orgPoint;
        [pathData replacePoint:activePoint atIndex:panIndex];
        panIndex = 0;
        
        [self sp_updateDisplay];
//        [self setNeedsDisplay];
        
        
        
        if (delegate) {
            [delegate selectionGeometryChanged];
        }
    }
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
    CGPoint point = [recognizer locationInView:self];
    
    if (!pathData) {
        pathData = [[PathData alloc] init];
    }
    
    [pathData addPoint:point];
    [self sp_updateDisplay];
//    [self setNeedsDisplay];
    
    [self.pathDataArray addObject:[pathData.points mutableCopy]];
    [self.scaleArray addObject:[NSNumber numberWithFloat:self.currentScale]];
    
    if (delegate) {
        [delegate selectionRegionValidChanged:pathData.selectionRegionValid];
    }
}

#pragma mark - Touch Methods -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.isLineation) { return; }
    UITouch *mytouch = [touches anyObject];
    [pathData addPoint:[mytouch locationInView:self]];
    
    // 放大镜定时器
    self.touchTimer = [NSTimer scheduledTimerWithTimeInterval:kACMagnifyingViewDefaultShowDelay
                                                       target:self
                                                     selector:@selector(addMagnifyingGlassTimer:)
                                                     userInfo:[NSValue valueWithCGPoint:[mytouch locationInView:self]]
                                                      repeats:NO];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.isLineation) { return; }
    UITouch *mytouch = [touches anyObject];
    [pathData addPoint:[mytouch locationInView:self]];
    [self sp_updateDisplay];
    
    // 更新放大镜视图
    [self updateMagnifyingGlassAtPoint:[mytouch locationInView:self]];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.isLineation) { return; }
    UITouch *mytouch = [touches anyObject];
    [pathData addPoint:[mytouch locationInView:self]];
    [self sp_updateDisplay];
    
    [self.pathDataArray addObject:[pathData.points mutableCopy]];
    [self.scaleArray addObject:[NSNumber numberWithFloat:self.currentScale]];
    
    // 放大镜
    [self.touchTimer invalidate];
    self.touchTimer = nil;
    [self removeMagnifyingGlass];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}


-(void)deleteLastPoint
{
    [pathData deleteLastPoint];
    [self sp_updateDisplay];
//    [self setNeedsDisplay];
    
    if (delegate) {
        [delegate selectionRegionValidChanged:pathData.selectionRegionValid];
    }
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

// MARK: - 旧项目方案：drawRect 会消耗大量内存
// 新方法为下面的sp_updateDisplay
- (void)rename_here_drawRect:(CGRect)rect
{
    if (pathData.points.count <= 0) return;
    
    // get the current context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(context, CGRectMake(0, 0, 1024, 768));
    
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
    
    if (!self.isSelectionMode && pathData.selectedIndex >= 0 && pathData.selectedIndex < pathData.points.count) {
        CGPoint selPoint = [[pathData.points objectAtIndex:pathData.selectedIndex] CGPointValue];
        [[UIColor redColor] setFill];
        CGContextFillRect(context, CGRectMake(selPoint.x-1,selPoint.y-1,lineWidth+1,lineWidth+1));
    }
    
    if (self.isSelectionMode) {
        [self generatePointViews];
    }
    else {
        [self clearPointViews];
    }
}

#pragma mark - 更新显示(时刻调用)
- (void)sp_updateDisplay {
    
    if (pathData.points.count <= 0) return;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint point1 = [[pathData.points objectAtIndex:0] CGPointValue];
    [path moveToPoint:point1];
    
    for (uint i=1; i<pathData.points.count; i++)
    {
        CGPoint point = [[pathData.points objectAtIndex:i] CGPointValue];
        [path addLineToPoint:point];
    }
    
    if (pathData.hasClosed) {
        [path addLineToPoint:point1];
        NSUInteger count = self.layer.sublayers.count;
        [[self.layer.sublayers objectAtIndex:count - 1] removeFromSuperlayer];
    }
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor yellowColor].CGColor;
    shapeLayer.lineWidth = 2.0f;
    if (!self.layer.sublayers.count) {
        [self.layer addSublayer:shapeLayer];
    } else {
        [self.layer replaceSublayer:self.layer.sublayers[0] with:shapeLayer];
    }
    
    if (!self.isSelectionMode && pathData.selectedIndex >= 0 && pathData.selectedIndex < pathData.points.count) {
        CGPoint selPoint = [[pathData.points objectAtIndex:pathData.selectedIndex] CGPointValue];
        CALayer *pointLayer = [CALayer layer];
        pointLayer.frame = CGRectMake(selPoint.x-1,selPoint.y-1,3,3);
        pointLayer.backgroundColor = [UIColor redColor].CGColor;
        
        if (self.layer.sublayers.count != 2) {
            [self.layer addSublayer:pointLayer];
        } else {
            [self.layer replaceSublayer:self.layer.sublayers[1] with:pointLayer];
        }
        self.pointLayer = pointLayer;
    }
    if (self.isSelectionMode) {
        [self generatePointViews];
    }
    else {
        [self clearPointViews];
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
}

-(void)clearPointViews
{
    for (UIView* pv in pointViews) {
        [pv removeFromSuperview];
    }
    [pointViews removeAllObjects];
    
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

-(void)closedPath
{
    pathData.hasClosed = YES;
    [self sp_updateDisplay];
//    [self setNeedsDisplay];
}


- (void)sp_backToLastestEditionUsingCurrentScale:(CGFloat)scale {
    if (!self.pathDataArray.count) { return; }
    
    [self.pathDataArray removeLastObject];
    [self.scaleArray removeLastObject];
    pathData.points = [NSMutableArray arrayWithArray:[self.pathDataArray lastObject]];
    CGFloat lastScale = [[self.scaleArray lastObject] floatValue];
    [pathData updatePointsWithScaleAfterRepeal:scale/lastScale];
    
    // 第一个条件：解决“如果第一个操作就是划线的话 撤销后points为空 就不会更新视图删除已经划的线” 的bug
    // 第二个条件：当撤销操作到最后只剩一个点时，不保留点，直接删除
    if (!pathData.points.count || (self.pathDataArray.count == 1 && pathData.points.count == 1)) {
        [[self.layer.sublayers objectAtIndex:0] removeFromSuperlayer];
        [self.pathDataArray removeAllObjects];
        [self.scaleArray removeAllObjects];
        [pathData.points removeAllObjects];
    }
    
    if (self.pointLayer) {
        [self.pointLayer removeFromSuperlayer];
        self.pointLayer = nil;
    }
    
    [self sp_updateDisplay];
}


/** 放大镜 **/
#pragma mark - private functions

- (void)addMagnifyingGlassTimer:(NSTimer*)timer {
    NSValue *v = timer.userInfo;
    CGPoint point = [v CGPointValue];
    [self addMagnifyingGlassAtPoint:point];
}

#pragma mark - magnifier functions

- (void)addMagnifyingGlassAtPoint:(CGPoint)point {
    if (!self.magnifyingGlass) {
        self.magnifyingGlass = [[ACMagnifyingGlass alloc] init];
    }
    
    if (!self.magnifyingGlass.viewToMagnify) {
        self.magnifyingGlass.viewToMagnify = self;
        
    }
    
    self.magnifyingGlass.touchPoint = point;
    self.magnifyingGlass.frame = CGRectMake(100, 100, 64*2, 64*2);
    [self.magnifyingGlass setNeedsDisplay];
    [self sp_updateMagnifyingGlassPositionWithPoint:point];
    [self.superview.superview addSubview:self.magnifyingGlass];
    
}

- (void)removeMagnifyingGlass {
    [self.magnifyingGlass removeFromSuperview];
}

- (void)updateMagnifyingGlassAtPoint:(CGPoint)point {
    self.magnifyingGlass.touchPoint = point;
    [self.magnifyingGlass setNeedsDisplay];
    [self sp_updateMagnifyingGlassPositionWithPoint:point];
}

- (void)sp_updateMagnifyingGlassPositionWithPoint:(CGPoint)point {
    CGPoint originPoint = [self convertPoint:point toView:self.superview.superview];
    [self.magnifyingGlass sp_updatePositionWithCurrentScaleOriginPoint:originPoint];
}

@end
