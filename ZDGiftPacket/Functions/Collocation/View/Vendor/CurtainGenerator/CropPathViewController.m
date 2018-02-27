//
//  CropPathViewController.m
//  Ija
//
//  Created by Orville on 14-2-27.
//  Copyright (c) 2014年 Orville. All rights reserved.
//

#import "CropPathViewController.h"
#import "UIBezierPath+Algorithm.h"
#import "DesignPath.h"
#include "CGPath_Boolean.h"
#import "BezierPaths.h"
//#import "Ija-Swift.h"
#import "SMScrollView.h"
#import "SPImageInpainterController.h"

@interface CropPathViewController ()<UIScrollViewDelegate, SPImageInpainterControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (assign, nonatomic, getter=isZoomed) BOOL zoom;
// 当前缩放大小
@property (assign, nonatomic) CGFloat currentScale1;
@property (nonatomic, strong) NSMutableArray* menuButtons;
@property (nonatomic, assign) BOOL isMenuHide;
@property (nonatomic, strong) IBOutlet UIView *mainView;
@property (nonatomic, strong) SMScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property (weak, nonatomic) IBOutlet UIButton *redoButton;
@property (weak, nonatomic) IBOutlet UIButton *lineButton;
@property (weak, nonatomic) IBOutlet UIButton *curzeButton;
@property (weak, nonatomic) IBOutlet UIButton *lineationButton;
@property (weak, nonatomic) IBOutlet UIView *styleContainerView;


@property (nonatomic, readwrite) NSUndoManager *undoManager;
@end

@implementation CropPathViewController
@synthesize backButton;
@synthesize segLineStyle;
@synthesize segPointDisplayStyle;
@synthesize deletePointButton;
@synthesize createRegionButton;
@synthesize regionRevertButton;
@synthesize regionSelectButton;
@synthesize pointSelectButton;
@synthesize verifyPathButton;
@synthesize previewButton;
@synthesize menuButton;
@synthesize menuButtons;
@synthesize selectedAreaView;
@synthesize isMenuHide;
@synthesize bezierPath;
@synthesize delegate;
@synthesize otherPaths;
@synthesize currentPointRadar;
@synthesize mainView;
@synthesize myScrollView;
@synthesize undoManager;


- (NSUndoManager *)undoManager {
    if (!undoManager) {
        undoManager = [[NSUndoManager alloc] init];
    }
    return undoManager;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [self cleanup];
}

-(void)cleanup
{
    
    self.menuButtons = nil;
    self.mainView = nil;
    self.myScrollView = nil;
    
    self.backButton = nil;
    self.segLineStyle = nil;
    self.segPointDisplayStyle = nil;
    self.deletePointButton = nil;
    self.createRegionButton = nil;
    self.regionRevertButton = nil;
    self.regionSelectButton = nil;
    self.pointSelectButton = nil;
    self.verifyPathButton = nil;
    self.previewButton = nil;
    self.menuButton = nil;
    self.scaleBigButton = nil;
    self.scaleSmallButton = nil;
    self.currentPointRadar = nil;
    
    self.imageView.image = nil;
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    self.selectedAreaView = nil;
    self.delegate = nil;
    self.orgImage = nil;
    
    self.flagString = nil;
    self.bezierPath = nil;
    self.otherPaths = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.imageView.image = self.orgImage;
    
    selectedAreaView.lineStyle = DesignLineStyleLine;
    selectedAreaView.delegate = self;
    segLineStyle.selectedSegmentIndex = 0;
    
    selectedAreaView.pointDisplayStyle = PointDisplayStyleControlPoint;
    segPointDisplayStyle.selectedSegmentIndex = selectedAreaView.pointDisplayStyle;
    
    [selectedAreaView setDesignPath:bezierPath];
    selectedAreaView.currentPointRadar = currentPointRadar;
    
    [self buildMenuButtons];
    
    self.bgPathDisplayView.paths = self.otherPaths;
    
//    MySwiftObject * myOb = [MySwiftObject new];
//    NSLog(@"MyOb.someProperty: %@", myOb.someProperty);
//    myOb.someProperty = @"Hello World";
//    NSLog(@"MyOb.someProperty: %@", myOb.someProperty);
//    NSString * retString = [myOb someFunction:@"Arg"];
//    NSLog(@"RetString: %@", retString);
    
    anchorPoint = CGPointZero;
    
    self.lineButton.selected = YES;
    
    // 放大镜
    ACLoupe *loupe = [[ACLoupe alloc] init];
    loupe.viewToMagnify = self.scrollView;
    loupe.scaleAtTouchPoint = YES;
    self.selectedAreaView.magnifyingGlass = loupe;
    
    self.scrollView.contentSize = self.view.frame.size;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handleTapGes:)];
    tap.numberOfTapsRequired = 2;
    [self.selectedAreaView addGestureRecognizer:tap];
    
    self.scrollView.maximumZoomScale = 0.5;
    self.scrollView.maximumZoomScale = 3.0;
    self.zoom = YES;//控制点击图片放大或缩小
    self.currentScale1 = 1.0f;
    
    if (IS_IPHONE) {
        for (UIView *subview in self.view.subviews) {
            subview.autoresizingMask = UIViewAutoresizingNone;
        }
        self.scrollView.frame = SCREEN_BOUNDS;
        self.imageView.frame = SCREEN_BOUNDS;
        self.bgPathDisplayView.frame = SCREEN_BOUNDS;
        self.selectedAreaView.frame = SCREEN_BOUNDS;
        
        self.backButton.frame = CGRectMake(10, 10, 30, 30);
        self.undoButton.frame = CGRectMake(SCREEN_WIDTH-40, 10, 30, 30);
        self.deletePointButton.frame = CGRectMake(SCREEN_WIDTH-62, 50, 52, 19);
        self.menuButton.frame = CGRectMake(SCREEN_WIDTH-62, 79, 52, 19);
        self.styleContainerView.frame = CGRectMake(SCREEN_WIDTH/2-60, 10, 120, 24);
        self.lineButton.frame = CGRectMake(0, 0, 40, 24);
        self.curzeButton.frame = CGRectMake(40, 0, 40, 24);
        self.lineationButton.frame = CGRectMake(80, 0, 40, 24);
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.currentPointRadar startAnimation];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(IBAction)segPointDisplayStyleValueChange:(id)sender
{
//    if (segPointDisplayStyle.selectedSegmentIndex == 0) {
//        selectedAreaView.pointDisplayStyle = PointDisplayStylePoint;
//    }
//    else {
//        selectedAreaView.pointDisplayStyle = PointDisplayStyleControlPoint;
//    }
    selectedAreaView.pointDisplayStyle = (PointDisplayStyle)segPointDisplayStyle.selectedSegmentIndex;
    [selectedAreaView generatePointViews];
}

-(void)buildMenuButtons
{
    self.menuButtons = [NSMutableArray array];
    
    [menuButtons addObject:backButton];
//    [menuButtons addObject:segLineStyle];
    [menuButtons addObject:deletePointButton];
    [menuButtons addObject:self.undoButton];
    [menuButtons addObject:self.lineButton];
    [menuButtons addObject:self.curzeButton];
    [menuButtons addObject:self.lineationButton];
//    [menuButtons addObject:segPointDisplayStyle];
//    [menuButtons addObject:createRegionButton];
//    [menuButtons addObject:regionRevertButton];
//    [menuButtons addObject:regionSelectButton];
//    [menuButtons addObject:pointSelectButton];
//    [menuButtons addObject:verifyPathButton];
//    [menuButtons addObject:previewButton];
//    [menuButtons addObject:menuButton];
}

-(IBAction)regionSelectClick:(UIButton*)sender
{
    NSArray* tmpPaths = selectedAreaView.pathData.dataPath.paths;
    int count = (int)tmpPaths.count;
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i = 0; i < count; i++) {
        NSString* str = [NSString stringWithFormat:@"区域 %d", i];
        UIAlertAction* action = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"%d", i);
            NSLog(@"%@", str);
            
            [selectedAreaView setPathIndex:i];
            
            //Do some thing here
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:action];
    }
    
    [alertController setModalPresentationStyle:UIModalPresentationPopover];
    UIPopoverPresentationController* popPresenter = alertController.popoverPresentationController;
    popPresenter.sourceView = sender;
    popPresenter.sourceRect = sender.bounds;
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(IBAction)pointSelectClick:(UIButton*)sender
{
    int count = selectedAreaView.pathData.currentPathElementCount;
    if (count == 0) {
        [UICommon showMsg:@"还未添加点，不能选中某个点。"];
        return;
    }
    
    BezierPath* bp =  selectedAreaView.pathData.currentPath;
    __block int orgSelectedIndex = (int)segPointDisplayStyle.selectedSegmentIndex;
    
    //设置显示大点
    segPointDisplayStyle.selectedSegmentIndex = PointDisplayStyleBigPoint;
    selectedAreaView.pointDisplayStyle = (PointDisplayStyle)segPointDisplayStyle.selectedSegmentIndex;
    [selectedAreaView generatePointViews];
    
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    int tmpIndex = 0;
    for (int i = 0; i < count; i++) {
        BezierElement* be = [bp.elements objectAtIndex:i];
        switch (be.kind) {
            case kCGPathElementMoveToPoint:
                tmpIndex++;
                break;
            case kCGPathElementAddLineToPoint:
                tmpIndex++;
                break;
            case kCGPathElementAddCurveToPoint:
                tmpIndex+=3;
                break;
            case kCGPathElementCloseSubpath:
                
                break;
            case kCGPathElementAddQuadCurveToPoint:
                tmpIndex+=2;
                break;
            default:
                break;
        }
        
        NSString* str = [NSString stringWithFormat:@"点 %d", tmpIndex];
        
        UIAlertAction* action = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"%d", i);
            NSLog(@"%@", str);
            
            [selectedAreaView setCurrentElementToIndex:i];
            
            segPointDisplayStyle.selectedSegmentIndex = orgSelectedIndex;
            selectedAreaView.pointDisplayStyle = (PointDisplayStyle)segPointDisplayStyle.selectedSegmentIndex;
            [selectedAreaView generatePointViews];
            
            //Do some thing here
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:action];
    }
    
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        segPointDisplayStyle.selectedSegmentIndex = orgSelectedIndex;
        selectedAreaView.pointDisplayStyle = (PointDisplayStyle)segPointDisplayStyle.selectedSegmentIndex;
        [selectedAreaView generatePointViews];
        
        //Do some thing here
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:action];
    
//    alertController.
    
    [alertController setModalPresentationStyle:UIModalPresentationPopover];
    UIPopoverPresentationController* popPresenter = alertController.popoverPresentationController;
    popPresenter.sourceView = sender;
    popPresenter.sourceRect = sender.bounds;
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(IBAction)createNewRegionClick:(id)sender
{
    [selectedAreaView createNewRegion];
}

-(IBAction)verifySelectRegionClick:(id)sender
{
    CGPathRef orgPath = selectedAreaView.pathData.drawPath.CGPath;
    CGPathRef allIntersectPath = nil;
    for (BezierPaths* bp in self.otherPaths) {
        CGPathRef tmpPath = CGPath_FBCreateIntersect(orgPath, [bp toBezierPath].CGPath);
        if (allIntersectPath == nil) {
            allIntersectPath = tmpPath;
        }
        else {
            CGPathRef tmpAllIntersectPath = allIntersectPath;
            allIntersectPath = CGPath_FBCreateUnion(allIntersectPath, tmpPath);
            CGPathRelease(tmpAllIntersectPath);
            CGPathRelease(tmpPath);
        }
    }
    
    if (allIntersectPath == nil) {
        return;
    }
    
    CGPathRef resultPath = CGPath_FBCreateDifference(orgPath, allIntersectPath);
    UIBezierPath* bzp = [UIBezierPath bezierPathWithCGPath:resultPath];
    BezierPaths* resultBP = [[BezierPaths alloc] initWithBezierPath:bzp];
    
    CGPathRelease(allIntersectPath);
    CGPathRelease(resultPath);
    
    [selectedAreaView setDesignPath:resultBP];
}

-(IBAction)regionRevertClick:(id)sender
{
    
    CGRect rect = CGRectMake(0, 0, 1024, 768);
    CGMutablePathRef rectangle = CGPathCreateMutable();
    CGPathAddRect(rectangle, NULL, rect);
    
//    if (!isFullRegionRevert) {
        CGPathRef result = CGPath_FBCreateDifference(rectangle, selectedAreaView.pathData.drawPath.CGPath);
        
        UIBezierPath* path = [UIBezierPath bezierPathWithCGPath:result];
        BezierPaths* bp = [[BezierPaths alloc] initWithBezierPath:path];
        [selectedAreaView setDesignPath:bp];
//    }
//    else {
//        CGPathRef result = CGPath_FBCreateXOR(selectedAreaView.pathData.drawPath.CGPath, rectangle);
//        
//        UIBezierPath* path = [UIBezierPath bezierPathWithCGPath:result];
//        BezierPaths* bp = [[BezierPaths alloc] initWithBezierPath:path];
//        [selectedAreaView setDesignPath:bp];
//    }
    
    CGPathRelease(rectangle);
    CGPathRelease(result);
    
    isFullRegionRevert = !isFullRegionRevert;
}

-(IBAction)memuClick:(id)sender
{
    self.isMenuHide = !isMenuHide;
    
    for (UIView* item in menuButtons) {
        item.hidden = isMenuHide;
    }
    
    if (isMenuHide) {
        [menuButton setTitle:@"菜单" forState:UIControlStateNormal];
    }
    else {
        [menuButton setTitle:@"全屏" forState:UIControlStateNormal];
    }
}

//放大
-(IBAction)scaleBigClick:(UIButton*)sender
{
    if (CGPointEqualToPoint(anchorPoint, CGPointZero)) {
        BezierElement* be = selectedAreaView.pathData.currentPointElement;
        if (be == nil || CGPointEqualToPoint(be.point, CGPointZero)) {
            return;
        }
        
        anchorPoint = be.point;
    }
    
    [self scaleBig];
}

-(void)scaleBig
{
    if (currentScale == 0) {
        currentScale = 1;
    }
    
    if (currentScale > 5) {
        return;
    }
    
    currentScale += 0.5;
//    selectedAreaView.frame =
}

//缩小
-(IBAction)scaleSmallClick:(UIButton*)sender
{
    if (CGPointEqualToPoint(anchorPoint, CGPointZero)) {
        BezierElement* be = selectedAreaView.pathData.currentPointElement;
        if (be == nil || CGPointEqualToPoint(be.point, CGPointZero)) {
            return;
        }
        
        anchorPoint = be.point;
    }
    
    [self scaleSmall];
}

-(void)scaleSmall
{
    if (currentScale == 0) {
        currentScale = 1;
    }
    
    if (currentScale == 1) {
        return;
    }
    currentScale -= 0.5;
    if (currentScale < 1) {
        currentScale = 1;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)segLineStyleValueChange:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        [self changeSelectedAreaViewLineStyle:DesignLineStyleLine lineation:NO];
    } else if (sender.selectedSegmentIndex == 1) {
        [self changeSelectedAreaViewLineStyle:DesignLineStyleCurve lineation:NO];
    } else if (sender.selectedSegmentIndex == 2) {
        [self changeSelectedAreaViewLineStyle:DesignLineStyleLine lineation:YES];
    }
}

- (IBAction)changeLineStyle:(UIButton *)sender {
    self.lineButton.selected = NO;
    self.curzeButton.selected = NO;
    self.lineationButton.selected = NO;
    sender.selected = YES;
    if (sender == self.lineButton) {
        [self changeSelectedAreaViewLineStyle:DesignLineStyleLine lineation:NO];
    } else if (sender == self.curzeButton) {
        [self changeSelectedAreaViewLineStyle:DesignLineStyleCurve lineation:NO];
    } else if (sender == self.lineationButton) {
        [self changeSelectedAreaViewLineStyle:DesignLineStyleLine lineation:YES];
    }
}


- (void)changeSelectedAreaViewLineStyle:(DesignLineStyle)style lineation:(BOOL)isLineation {
    selectedAreaView.lineStyle = style;
    selectedAreaView.lineation = isLineation;
}

- (void)selectedAreaViewDidUndo:(NSNotification *)notification {
    ZDLog(@"notification: %@", notification);
//    self.selectedAreaView.pathData.currentPath.elements.lastObject.
}

-(IBAction)goBack:(id)sender
{
    if (selectedAreaView.pathData.selectionRegionValid) {
//        UIBezierPath* path = [selectedAreaView.pathData toBezierPath];
//        
//        //裁切图片
//        UIImage *image = self.orgImage;
//        CGSize imageSize = image.size;
//        CGRect imageRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
//        
//        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
//        // Create the clipping path and add it
//        [path addClip];
//        [image drawAtPoint:CGPointZero];
//        UIImage *cropImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
        
        UIImage* cropImage = [self deleteBackgroundOfImage:self.imageView];
        
        if ([delegate respondsToSelector:@selector(finishedSelectionCropImage:withController:)]) {
            [delegate finishedSelectionCropImage:cropImage withController:self];
        }
    }
    
    [self cleanup];
    [self.navigationController popViewControllerAnimated:YES];
}

//删除点
-(IBAction)deleteSelectionLastPointClick:(id)sender
{
    [selectedAreaView deleteLastPoint];
}

////为图像创建透明区域

-(CGImageRef)newImageAndAddAlphaChannel:(CGImageRef)sourceImage

{
    
    CGImageRef retVal = NULL;
    
    
    
    size_t width = CGImageGetWidth(sourceImage);
    
    size_t height = CGImageGetHeight(sourceImage);
    
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    
    
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL, width, height,
                                                          
                                                          8, 0, colorSpace,
                                                          
                                                          kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    
    
    
    if (offscreenContext != NULL)
        
    {
        
        CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), sourceImage);
        
        retVal = CGBitmapContextCreateImage(offscreenContext);
        
        CGContextRelease(offscreenContext);
        
    }
    
    
    
    CGColorSpaceRelease(colorSpace);
    
    
    
    return retVal;
    
}



/////利用图像遮盖

-(UIImage*)maskImage:(UIImage *)image withMask:(UIImage *)maskImage

{
    
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        
                                        CGImageGetHeight(maskRef),
                                        
                                        CGImageGetBitsPerComponent(maskRef),
                                        
                                        CGImageGetBitsPerPixel(maskRef),
                                        
                                        CGImageGetBytesPerRow(maskRef),
                                        
                                        CGImageGetDataProvider(maskRef), NULL, true);
    
    
    
    CGImageRef sourceImage = [image CGImage];
    
    CGImageRef imageWithAlpha = sourceImage;
    
    
    
    //add alpha channel for images that don't have one (ie GIF, JPEG, etc...)
    
    //this however has a computational cost
    
    CGImageRef masked = NULL;
    if (CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNone) {
        
        imageWithAlpha = [self newImageAndAddAlphaChannel:sourceImage];
        masked = CGImageCreateWithMask(imageWithAlpha, mask);
        
        CGImageRelease(mask);
        CGImageRelease(imageWithAlpha);
        
    }
    else {
        
        masked = CGImageCreateWithMask(imageWithAlpha, mask);
        
        CGImageRelease(mask);
    }
    
    
    
    UIImage* retImage = [UIImage imageWithCGImage:masked];
    
    CGImageRelease(masked);
    
    
    
    return retImage;
    
    
    
}

-(IBAction)testClick:(id)sender
{
    [selectedAreaView.pathData moveToFirstPoint];
    
    DesignPath* pathData1 = [[DesignPath alloc] init];
    
    CGRect r = selectedAreaView.bounds;
    
    r.origin.x = 200;
    r.origin.y = 100;
    r.size.width = r.size.width/2;
    r.size.height = r.size.height/2;
    
    UIBezierPath* tmpPath = [UIBezierPath bezierPathWithOvalInRect:r];
    BezierPaths* bp = [[BezierPaths alloc] initWithBezierPath:tmpPath];
    BezierPaths* rp = [bp intersectWithPath:selectedAreaView.pathData.dataPath];
    pathData1.dataPath = rp;
//    pathData1.dataPath = bp;
    [pathData1 refresh];
    selectedAreaView.pathData = pathData1;
    
    
    [selectedAreaView setNeedsDisplay];
    [selectedAreaView generatePointViews];
}

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

- (UIImage *)deleteBackgroundOfImage:(UIImageView*)image
{
//    NSArray *points = selectedAreaView.pathData.points;
    
    CGRect rect = CGRectZero;
    rect.size = image.image.size;
  
    CGRect r = selectedAreaView.bounds;
    
    r.origin.x = 200;
    r.origin.y = 100;
    r.size.width = r.size.width/2;
    r.size.height = r.size.height/2;
    
//    UIBezierPath* tmpPath = [UIBezierPath bezierPathWithOvalInRect:r];
//    BezierPaths* bp = [[BezierPaths alloc] initWithBezierPath:tmpPath];
    
//    UIBezierPath* tmpPath = [UIBezierPath bezierPathWithRect:image.bounds];
//    BezierPaths* bp = [[BezierPaths alloc] initWithBezierPath:tmpPath];
//    BezierPaths* rp = [bp differenceWithPath:selectedAreaView.pathData.dataPath];
//    UIBezierPath *aPath = [rp toBezierPathFromSize:image.frame.size toSize:image.image.size];
    
//    aPath = [self test];
    UIBezierPath *aPath = [selectedAreaView.pathData.dataPath toBezierPathFromSize:image.frame.size toSize:image.image.size];
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 1.0);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextClearRect(context, rect);
        
        [[UIColor blackColor] setFill];
        UIRectFill(rect);
        [[UIColor whiteColor] setFill];
        
//        aPath = [UIBezierPath bezierPath];
//        
//        CGSize ss1 = image.frame.size;
//        CGSize ssbb = image.bounds.size;
//        CGSize ss2 = image.image.size;
//        CGFloat sss = image.image.scale;
//        
//        // Set the starting point of the shape.
//        CGPoint p1 = [self convertCGPoint:[[points objectAtIndex:0] CGPointValue] fromRect1:image.frame.size toRect2:image.image.size];
//        [aPath moveToPoint:CGPointMake(p1.x, p1.y)];
//        
//        for (uint i=1; i<points.count; i++)
//        {
//            CGPoint p = [self convertCGPoint:[[points objectAtIndex:i] CGPointValue] fromRect1:image.frame.size toRect2:image.image.size];
//            [aPath addLineToPoint:CGPointMake(p.x, p.y)];
//        }
//        [aPath closePath];
//        [aPath fill];
        
//        [aPath fill];
        
        //    CGContextSetRGBFillColor(context, 1.0, 0, 0, alpha);
        //    CGContextAddPath(context, tt.CGPath);
        //    CGContextEOFillPath(context);
        
        CGContextAddPath(context, aPath.CGPath);
        CGContextEOFillPath(context);
//        CGContextEOClip(context);
        
    }
    
    UIImage *mask = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1.0);
    {
        CGContextClipToMask(UIGraphicsGetCurrentContext(), rect, mask.CGImage);
        [image.image drawAtPoint:CGPointZero];
    }
    
    UIImage *maskedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect croppedRect = aPath.bounds;
    croppedRect.origin.y = rect.size.height - CGRectGetMaxY(aPath.bounds);//This because mask become inverse of the actual image;
    
    //    croppedRect.origin.x = croppedRect.origin.x*2;
    //    croppedRect.origin.y = croppedRect.origin.y*2;
    //    croppedRect.size.width = croppedRect.size.width*2;
    //    croppedRect.size.height = croppedRect.size.height*2;
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(maskedImage.CGImage, croppedRect);
    
    maskedImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    return maskedImage;
}

- (UIImage *)deleteBackgroundOfImage2:(UIImageView*)image
{
    NSArray *points = selectedAreaView.pathData.points;
    
    CGRect rect = CGRectZero;
    rect.size = image.image.size;
    
    
    UIBezierPath *aPath;
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 1.0);
    {
        [[UIColor blackColor] setFill];
        UIRectFill(rect);
        [[UIColor whiteColor] setFill];
        
        aPath = [UIBezierPath bezierPath];
        
//        CGSize ss1 = image.frame.size;
//        CGSize ssbb = image.bounds.size;
//        CGSize ss2 = image.image.size;
//        CGFloat sss = image.image.scale;
        
        // Set the starting point of the shape.
        CGPoint p1 = [self convertCGPoint:[[points objectAtIndex:0] CGPointValue] fromRect1:image.frame.size toRect2:image.image.size];
        [aPath moveToPoint:CGPointMake(p1.x, p1.y)];
        
        for (uint i=1; i<points.count; i++)
        {
            CGPoint p = [self convertCGPoint:[[points objectAtIndex:i] CGPointValue] fromRect1:image.frame.size toRect2:image.image.size];
            [aPath addLineToPoint:CGPointMake(p.x, p.y)];
        }
        [aPath closePath];
        [aPath fill];
    }
    
    UIImage *mask = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1.0);
    {
        CGContextClipToMask(UIGraphicsGetCurrentContext(), rect, mask.CGImage);
        [image.image drawAtPoint:CGPointZero];
    }
    
    UIImage *maskedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect croppedRect = aPath.bounds;
    croppedRect.origin.y = rect.size.height - CGRectGetMaxY(aPath.bounds);//This because mask become inverse of the actual image;
    
//    croppedRect.origin.x = croppedRect.origin.x*2;
//    croppedRect.origin.y = croppedRect.origin.y*2;
//    croppedRect.size.width = croppedRect.size.width*2;
//    croppedRect.size.height = croppedRect.size.height*2;
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(maskedImage.CGImage, croppedRect);
    
    maskedImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    return maskedImage;
}

- (CGPoint)convertCGPoint:(CGPoint)point1 fromRect1:(CGSize)rect1 toRect2:(CGSize)rect2
{
    point1.y = rect1.height - point1.y;
    CGPoint result = CGPointMake((point1.x*rect2.width)/rect1.width, (point1.y*rect2.height)/rect1.height);
    return result;
}
- (IBAction)undoPathDataOperation:(id)sender {
    if ([self.selectedAreaView.undoManager canUndo]) {
        [self.selectedAreaView.undoManager undo];
    }
//    [self.selectedAreaView sp_backToLastestEditionUsingCurrentScale:self.currentScale1];
}

- (IBAction)redoPathDataOperation:(id)sender {
//    [self.selectedAreaView.undoManager redo];
}

- (void)updateUndoAndRedoButtons {
    self.undoButton.enabled = self.selectedAreaView.undoManager.canUndo == YES;
    self.redoButton.enabled = self.selectedAreaView.undoManager.canRedo == YES;
}

-(void)selectionRegionValidChanged:(BOOL)isValid {
}
-(void)selectionGeometryChanged {
}
- (void)designView:(GeometryPathDesignView *)view didUndoWithLastType:(CGPathElementType)type {
}
- (void)designView:(GeometryPathDesignView *)view didRedoWithLastType:(CGPathElementType)type {
}


#pragma mark - Zoom Custom Method

- (void)handleTapGes:(UIGestureRecognizer*)tapGes//手势执行事件
{
    CGFloat newScale = 0.0;
    
    if (self.isZoomed) {
        newScale = 2*1.5;
        self.zoom = NO;
    } else {
        newScale = 1.0;
        self.zoom = YES;
    }
    
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[tapGes locationInView:tapGes.view]];
    NSLog(@"zoomRect:%@",NSStringFromCGRect(zoomRect));
    [self.scrollView zoomToRect:zoomRect animated:YES];
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGSize size = self.view.frame.size;
    size.height *= scrollView.zoomScale;
    size.width *= scrollView.zoomScale;
    self.selectedAreaView.frame = CGRectMake(0, 0, size.width, size.height);
    self.selectedAreaView.hidden = YES;
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    // 同步划线的缩放大小数值
    self.currentScale1 = scale;
    self.selectedAreaView.currentScale = scale;
    [self.selectedAreaView.pathData.currentPath updatePointsWithScale:scale];
    [self.selectedAreaView.pathData updatePointState];
    
    self.selectedAreaView.hidden = NO;
    [self.selectedAreaView sp_updateDisplay];
    
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    zoomRect.size.height = self.scrollView.frame.size.height / scale;
    zoomRect.size.width  = self.scrollView.frame.size.width  / scale;
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}


#pragma mark - SPImageInpainterController 一键清除
- (IBAction)handleInpaintButtonClickEvent:(UIButton *)sender {
    SPImageInpainterController *controller = [[SPImageInpainterController alloc] init];
    controller.delegate = self;
    controller.sourceImage = self.imageView.image;
    controller.type = SPImageSourceTypeCurtainImage;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)imageInpainterController:(SPImageInpainterController *)controller
        didFinishInpaintingImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void)imageInpainterControllerDidCancel:(SPImageInpainterController *)controller {
    
}


@end
