//
//  GeometryPathDesignView.m
//  ija
//
//  Created by Orville on 13-12-22.
//  Copyright (c) 2013年 Orville. All rights reserved.
//

#import "GeometryPathDesignView.h"
#import <QuartzCore/QuartzCore.h>
#include "CGPath_Boolean.h"
//#import "Ija-Swift.h"

#define k_POINT_WIDTH 20
// 放大镜显示延迟
static CGFloat const kACMagnifyingViewDefaultShowDelay = 0.2;

@interface GeometryPathDesignView ()
@property (nonatomic, strong) UIPanGestureRecognizer *panGes;
// 缩放大小备份：在每一次pathData备份时，都记录当前缩放大小
@property (nonatomic, strong) NSMutableArray *scaleArray;

@property (nonatomic, strong) CALayer *pointLayer;
@property (nonatomic, strong) CAShapeLayer *guideLineLayer;

// 放大镜定时器
@property (nonatomic, retain) NSTimer *touchTimer;

@property (nonatomic, strong) NSUndoManager *undoManager;

@end

@implementation GeometryPathDesignView
@synthesize undoManager;
@synthesize pathData;
@synthesize designMode;
@synthesize pointViews;
@synthesize delegate;
@synthesize lineStyle;
@synthesize pointDisplayStyle;
@synthesize currentPointRadar;
@synthesize panStatus;
@synthesize movingPoint;

- (NSUndoManager *)undoManager {
    if (!undoManager) {
        undoManager = [[NSUndoManager alloc] init];
    }
    return undoManager;
}


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
    self.pathData = [[DesignPath alloc] init];
    self.lineColor       = [UIColor yellowColor];
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds   = YES;
    self.pointColor      = [UIColor blueColor];
    self.pointViews = [NSMutableArray array];
    self.lineation = NO;
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
    
    // TODO: 同步编辑模式（直线/曲线/画线），暂时未找到解决办法，先注释掉
//    __weak typeof(self) weakSelf = self;
//    [NOTIFICATION_CENTER addObserverForName:NSUndoManagerDidUndoChangeNotification
//                                     object:self.undoManager
//                                      queue:[NSOperationQueue mainQueue]
//                                 usingBlock:^(NSNotification * _Nonnull note) {
//                                     BezierElement *element = [weakSelf.pathData.currentPath.elements objectAtIndex:weakSelf.pathData.currentElementIndex];
//                                     [weakSelf.delegate designView:self didUndoWithLastType:element.kind];
//    }];
//    [NOTIFICATION_CENTER addObserverForName:NSUndoManagerDidRedoChangeNotification
//                                     object:self.undoManager
//                                      queue:[NSOperationQueue mainQueue]
//                                 usingBlock:^(NSNotification * _Nonnull note) {
//                                     BezierElement *element = [weakSelf.pathData.currentPath.elements objectAtIndex:weakSelf.pathData.currentElementIndex];
//                                     [weakSelf.delegate designView:self didRedoWithLastType:element.kind];
//                                     }];
}

- (void)dealloc {
//    [NOTIFICATION_CENTER removeObserver:self];
}

- (void)setLineation:(BOOL)lineation {
    _lineation = lineation;
    // 划线取点 删除手势
    if (lineation) {
        [self removeGestureRecognizer:self.panGes];
        
    } else {
        // 点线取点 添加手势
        UIPanGestureRecognizer* panGesture =[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        
        panGesture.cancelsTouchesInView = NO;
        [self addGestureRecognizer:panGesture];
        self.panGes = panGesture;
    }
}

-(void)setDesignPath:(BezierPaths*)thePath
{
    if (thePath == nil) {
        return;
    }
    
    [pathData setDesignPath:thePath];
    
    [self generatePointViews];
    
// [self setNeedsDisplay];
    [self sp_updateDisplay];
}

-(void)setPathIndex:(int)index
{
    [pathData setPathIndex:index];
    
    [self generatePointViews];
    
//     [self setNeedsDisplay];
    [self sp_updateDisplay];
}

-(void)setCurrentElementToIndex:(int)index
{
    [pathData setCurrentElementToIndex:index];
    
    [self generatePointViews];
    
//     [self setNeedsDisplay];
    [self sp_updateDisplay];
}

- (void)handlePan:(UIPanGestureRecognizer*)panGesture{
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
        
        self.panStatus = DesignPanStatusBegin;
        self.movingPoint = orgPoint;
        //    [self setNeedsDisplay];
        [self sp_updateDisplay];
    }
    else if (panGesture.state == UIGestureRecognizerStateChanged)
    {
        if (pathData.points.count == 0)
        {
            self.panStatus = DesignPanStatusNone;
            self.movingPoint = CGPointZero;
            //    [self setNeedsDisplay];
            [self sp_updateDisplay];
            return;
        }
        
        self.panStatus = DesignPanStatusMove;
        CGPoint point = [panGesture translationInView:self];
        CGPoint activePoint = CGPointMake(orgPoint.x+point.x, orgPoint.y+point.y);
        self.movingPoint = [pathData replacePoint:activePoint atIndex:panIndex];
        //    [self setNeedsDisplay];
        [self sp_updateDisplay];
        
        if (delegate) {
            [delegate selectionGeometryChanged];
        }
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded)
    {
        if (pathData.points.count == 0)
        {
            self.panStatus = DesignPanStatusNone;
            self.movingPoint = CGPointZero;
            //    [self setNeedsDisplay];
            [self sp_updateDisplay];
            return;
        }
        self.panStatus = DesignPanStatusEnd;
        
        CGPoint point = [panGesture translationInView:self];
        CGPoint activePoint = CGPointMake(orgPoint.x+point.x, orgPoint.y+point.y);
        [pathData replacePoint:activePoint atIndex:panIndex];
        //    [self setNeedsDisplay];
        [self sp_updateDisplay];
        [self.scaleArray addObject:[NSNumber numberWithFloat:self.currentScale]];
        
        orgPoint = CGPointZero;
        
        if (delegate) {
            [delegate selectionRegionValidChanged:pathData.selectionRegionValid];
            [delegate selectionGeometryChanged];
        }
    }
    else if (panGesture.state == UIGestureRecognizerStateCancelled || panGesture.state == UIGestureRecognizerStateFailed)
    {
        if (panGesture.state == UIGestureRecognizerStateCancelled) {
            self.panStatus = DesignPanStatusCancelled;
        }
        else if (panGesture.state == UIGestureRecognizerStateFailed)
        {
            self.panStatus = DesignPanStatusCancelled;
        }
        self.movingPoint = CGPointZero;
        
        CGPoint activePoint = orgPoint;
        [pathData replacePoint:activePoint atIndex:panIndex];
        panIndex = 0;
        //    [self setNeedsDisplay];
        [self sp_updateDisplay];
        
        if (delegate) {
            [delegate selectionGeometryChanged];
        }
        
    }
    else {
        self.panStatus = DesignPanStatusNone;
        //    [self setNeedsDisplay];
        [self sp_updateDisplay];
    }
    
    [self generatePointViews];
}


- (IBAction)handleTap:(UITapGestureRecognizer*)recognizer
{
    CGPoint point = [recognizer locationInView:self];
    [self addPoint:point];
//     [self setNeedsDisplay];
    [self sp_updateDisplay];
    
    [self.scaleArray addObject:[NSNumber numberWithFloat:self.currentScale]];
    
    if (delegate) {
        [delegate selectionRegionValidChanged:pathData.selectionRegionValid];
    }
}


#pragma mark - Touch Methods -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.isLineation) { return; }
    
    
    UITouch *mytouch = [touches anyObject];
    [self addPoint:[mytouch locationInView:self]];
    [undoManager beginUndoGrouping];
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
    [self addPoint:[mytouch locationInView:self]];
//     [self setNeedsDisplay];
    [self sp_updateDisplay];
    
    // 更新放大镜视图
    [self updateMagnifyingGlassAtPoint:[mytouch locationInView:self]];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.isLineation) { return; }
    UITouch *mytouch = [touches anyObject];
    [self addPoint:[mytouch locationInView:self]];
//     [self setNeedsDisplay];
    [self sp_updateDisplay];
    [undoManager endUndoGrouping];
    
    [self.scaleArray addObject:[NSNumber numberWithFloat:self.currentScale]];
    // 放大镜
    [self.touchTimer invalidate];
    self.touchTimer = nil;
    [self removeMagnifyingGlass];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.isLineation) { return; }
    ZDLog(@"touchesCancelled-----------");
//     [self setNeedsDisplay];
    [self sp_updateDisplay];
    // 放大镜
    [self.touchTimer invalidate];
    self.touchTimer = nil;
    [self removeMagnifyingGlass];
}

- (void)updateUndoAndRedoButtons {
    [self.delegate updateUndoAndRedoButtons];
}

- (void)addPoint:(CGPoint)point {
    [[self.undoManager prepareWithInvocationTarget:self] deleteLastPoint];
    [self.undoManager setActionName:@"添加点"];
    if (self.isLineation) {
        [pathData addPoint:point];
    } else {
        switch (lineStyle) {
            case DesignLineStyleLine:
                [pathData addPoint:point];
                break;
            case DesignLineStyleQuadCurve:
                [pathData addPointQuadCurve:point];
                break;
            case DesignLineStyleCurve:
                [pathData addPointCurve:point];
                break;
                
            default:
                break;
        }
    }
//     [self setNeedsDisplay];
    [self sp_updateDisplay];
}

-(void)deleteLastPoint
{
    BezierElement *element = pathData.currentPath.elements.lastObject;
    [[self.undoManager prepareWithInvocationTarget:self] addPoint:element.point];
    
    [self.undoManager setActionName:@"删除点"];
    [pathData deleteLastPoint];
    [self clearPointViews];
//     [self setNeedsDisplay];
    [self sp_updateDisplay];
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
    return designMode == PathDesignModeSelection;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(UIBezierPath*)test
{
    CGRect rect = CGRectMake(15, 15, 370, 370);
    CGMutablePathRef rectangle = CGPathCreateMutable();
    CGPathAddRect(rectangle, NULL, rect);
    
    CGMutablePathRef circle = CGPathCreateMutable();
    CGPoint center = CGPointMake(200, 200);
    CGFloat radius = 185;
    
    CGRect rect2 = CGRectMake(center.x - radius, center.y - radius, 2.0 * radius, 2.0 * radius);
    CGPathAddEllipseInRect(circle, NULL, rect2);
    
    CGPathRef result = CGPath_FBCreateDifference(rectangle, circle);
    CGPathRelease(rectangle);
    CGPathRelease(circle);
    
    UIBezierPath* path = [UIBezierPath bezierPathWithCGPath:result];
    CGPathRelease(result);
    return path;
}
- (void)rename_here_drawRect:(CGRect)rect
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
    // set the stroke color and width
    CGContextSetRGBStrokeColor(context, red, green, blue, alpha);
    CGContextSetLineWidth(context, lineWidth);
    
    pathData.drawPath.lineWidth = 2.0;
    [pathData.drawPath stroke];
    
    // tell the context to draw the stroked line
    CGContextStrokePath(context);
    
    //参考线
    if (self.panStatus == DesignPanStatusMove && !CGPointEqualToPoint(self.movingPoint, CGPointZero)) {
        CGContextSetRGBStrokeColor(context, 33/255.0, 178/255.0, 254/255.0, 1);
        CGContextSetLineWidth(context, 0.5);
        
        UIBezierPath* xyPath = [UIBezierPath bezierPath];
        [xyPath moveToPoint:CGPointMake(self.movingPoint.x, 0)];
        [xyPath addLineToPoint:CGPointMake(self.movingPoint.x, rect.size.height)];
        [xyPath moveToPoint:CGPointMake(0, self.movingPoint.y)];
        [xyPath addLineToPoint:CGPointMake(rect.size.width, self.movingPoint.y)];
        [xyPath stroke];
        
        // tell the context to draw the stroked line
        CGContextStrokePath(context);
    }
    
    [self generatePointViews];
}


#pragma mark - 更新显示(时刻调用)
- (void)sp_updateDisplay {
    if (pathData.points.count <= 0) return;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    shapeLayer.path = pathData.drawPath.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor yellowColor].CGColor;
    shapeLayer.lineWidth = 2.0f;
    if (!self.layer.sublayers.count) {
        [self.layer addSublayer:shapeLayer];
    } else {
        [self.layer replaceSublayer:self.layer.sublayers[0] with:shapeLayer];
    }
    
    if (self.designMode == DesignLineStyleLine && pathData.currentElementIndex >= 0 && pathData.currentElementIndex < pathData.currentPath.elements.count) {
        BezierElement *element = pathData.currentPath.elements.lastObject;
        CGPoint selPoint = element.point;
        
        CALayer *pointLayer = [CALayer layer];
        pointLayer.backgroundColor = [UIColor redColor].CGColor;
        pointLayer.frame = CGRectMake(selPoint.x-1,selPoint.y-1,3,3);
        BOOL hasPointLayer = NO;
        for (CALayer *sublayer in self.layer.sublayers) {
            if (sublayer.backgroundColor == UIColorRed.CGColor) {
                hasPointLayer = YES;
                break;
            }
        }
        if (!hasPointLayer) {
            [self.layer addSublayer:pointLayer];
        } else {
            [self.layer replaceSublayer:self.layer.sublayers[1] with:pointLayer];
        }
        self.pointLayer = pointLayer;
    }
    //参考线
    if (self.panStatus == DesignPanStatusMove
        && !CGPointEqualToPoint(self.movingPoint, CGPointZero)) {
        UIBezierPath* xyPath = [UIBezierPath bezierPath];
        [xyPath moveToPoint:CGPointMake(self.movingPoint.x, 0)];
        [xyPath addLineToPoint:CGPointMake(self.movingPoint.x, self.frame.size.height)];
        [xyPath moveToPoint:CGPointMake(0, self.movingPoint.y)];
        [xyPath addLineToPoint:CGPointMake(self.frame.size.width, self.movingPoint.y)];
        
        if (!self.guideLineLayer) {
            self.guideLineLayer = [CAShapeLayer layer];
            self.guideLineLayer.fillColor = [UIColor clearColor].CGColor;
            self.guideLineLayer.strokeColor = RGB(33, 178, 254).CGColor;
            self.guideLineLayer.lineWidth = .5f;
        }
        self.guideLineLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.guideLineLayer.path = xyPath.CGPath;
        if (![self.layer.sublayers containsObject:self.guideLineLayer]) {
            [self.layer addSublayer:self.guideLineLayer];
        } else {
            [self.layer replaceSublayer:self.layer.sublayers[2] with:self.guideLineLayer];
        }
    } else {
        if (self.guideLineLayer) {
            [self.guideLineLayer removeFromSuperlayer];
            self.guideLineLayer = nil;
        }
    }
    [self generatePointViews];
}


-(void)generatePointViews
{
    [self clearPointViews];
    
    int count = (int)pathData.points.count;
    
    if (count > 0) {
        BezierElement* be = pathData.currentPointElement;
        if (be != nil) {
//            currentPointRadar.center = be.point;
//            currentPointRadar.hidden = NO;
        }
    }
    
    if (pointDisplayStyle == PointDisplayStylePoint) {
        return;
    }
    
    for (int i = 0; i < count; i++) {
        if (pointDisplayStyle == PointDisplayStyleBigPoint) {
//            if (i != (count-1) || currentPointRadar == nil) {
                CGPoint p = [[pathData.points objectAtIndex:i] CGPointValue];
                UIView* pv = [self getPointView:i+1 at:p];
                [pointViews addObject:pv];
                [self addSubview:pv];
//            }
        }
        else if (pointDisplayStyle == PointDisplayStyleControlPoint) {
            if ([pathData isControlPointAtIndex:i]) {
                CGPoint p = [[pathData.points objectAtIndex:i] CGPointValue];
                UIView* pv = [self getPointView:i+1 at:p];
                [pointViews addObject:pv];
                [self addSubview:pv];
            }
        }
    }
    
//    if (count > 0) {
//        CGPoint p = [[pathData.points lastObject] CGPointValue];
//        currentPointRadar.center = p;
//        currentPointRadar.hidden = NO;
//    }
}

-(void)clearPointViews
{
    for (UIView* pv in pointViews) {
        [pv removeFromSuperview];
    }
    [pointViews removeAllObjects];
    currentPointRadar.hidden = YES;
}

- (UIView *)getPointView:(int)num at:(CGPoint)point
{
    UIView *point1 = [[UIView alloc] initWithFrame:CGRectMake(point.x -k_POINT_WIDTH/2, point.y-k_POINT_WIDTH/2, k_POINT_WIDTH, k_POINT_WIDTH)];
    point1.alpha = 0.8;
    point1.backgroundColor    = self.pointColor;
    point1.layer.borderColor  = self.lineColor.CGColor;
    point1.layer.borderWidth  = 2;
    point1.layer.cornerRadius = k_POINT_WIDTH/2;
    
    UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, k_POINT_WIDTH, k_POINT_WIDTH)];
    number.text = [NSString stringWithFormat:@"%d",num];
    number.textColor = [UIColor whiteColor];
    number.backgroundColor = [UIColor clearColor];
    number.font = [UIFont systemFontOfSize:(num>99 ? 10 : 12)];
    number.minimumScaleFactor = 0.5;
    number.textAlignment = NSTextAlignmentCenter;
    
    [point1 addSubview:number];
    
    return point1;
}

-(void)createNewRegion
{
    [pathData addNewPath];
}

-(void)closedPath
{
    pathData.hasClosed = YES;
//     [self setNeedsDisplay];
    [self sp_updateDisplay];
}


- (void)sp_backToLastestEditionUsingCurrentScale:(CGFloat)scale {
    [self.scaleArray removeLastObject];
    CGFloat lastScale = [[self.scaleArray lastObject] floatValue];
    [pathData.currentPath updatePointsWithScaleAfterRepeal:scale/lastScale];
//    [pathData updatePointState];
    
    // 第一个条件：解决“如果第一个操作就是划线的话 撤销后points为空 就不会更新视图删除已经划的线” 的bug
    // 第二个条件：当撤销操作到最后只剩一个点时，不保留点，直接删除
//    if (!pathData.points.count || (self.pathDataArray.count == 1 && pathData.points.count == 1)) {
//        [[self.layer.sublayers objectAtIndex:0] removeFromSuperlayer];
//        [self.pathDataArray removeAllObjects];
//        [self.scaleArray removeAllObjects];
//        [pathData.points removeAllObjects];
//    }
//
    if (self.pointLayer) {
        [self.pointLayer removeFromSuperlayer];
        self.pointLayer = nil;
    }
//    [self setNeedsDisplay];
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
