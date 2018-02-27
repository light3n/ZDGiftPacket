//
// Author: Håvard Fossli <hfossli@agens.no>
//
// Copyright (c) 2013 Agens AS (http://agens.no/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AGQuadControlsSample.h"
#import "AGQuad.h"
//#import "easing.h"
#import "CALayer+AGQuad.h"
#import "UIView+FrameExtra.h"
#import "UIBezierPath+AGQuad.h"

@interface AGControlPointView : UIView

@end

@interface AGQuadControlsSample ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) IBOutlet UIView *topLeftControl;
@property (nonatomic, strong) IBOutlet UIView *topRightControl;
@property (nonatomic, strong) IBOutlet UIView *bottomLeftControl;
@property (nonatomic, strong) IBOutlet UIView *bottomRightControl;
@property (nonatomic, strong) IBOutlet UIView *maskView;
@property (nonatomic, strong) IBOutlet UISwitch *switchControl;
@property (nonatomic, strong) UIPopoverController* popoverController;


@end


@implementation AGQuadControlsSample
@synthesize popoverController;
@synthesize curtainImage;
@synthesize quadView;
@synthesize delegate;

- (void)dealloc
{
    [self cleanup];
}

-(void)cleanup
{
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    self.topLeftControl = nil;
    self.topRightControl = nil;
    self.bottomLeftControl = nil;
    self.bottomRightControl = nil;
    self.maskView = nil;
    self.switchControl = nil;
    self.popoverController = nil;
    
    [qbImageView removeFromSuperview];
    qbImageView = nil;
    
    self.delegate = nil;
    self.curtainImage = nil;
    
    [quadView removeFromSuperview];
    self.quadView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //todo: Orville
//    [self createAndApplyQuad];
    
//    [self createOverlay];
    
    quadView.delegate = self;
    quadView.designMode = DesignModeCurtain;
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [quadView addGestureRecognizer:tapGesture];
    
//    if (self.type == iJADesignViewControllerSourceTypeSaleSample) {
//        quadView.isNotShowPoint = YES;
//        qbImageView.image = nil;
//        self.imageView.image = nil;
//        self.view.backgroundColor = [UIColor clearColor];
//    }
    self.isFirstCurtainImage = YES;
    
}

- (IBAction)handleTap:(UITapGestureRecognizer*)recognizer
{
    CGPoint point = [recognizer locationInView:quadView];
    BOOL pointInside = [quadView.pathData.toBezierPath containsPoint:point];
    
    if (pointInside) {
        noShowPoints = !noShowPoints;
        quadView.isNotShowPoint = noShowPoints;
        
        UIView* parentView = self.view.superview;
        //置顶
        [self.view removeFromSuperview];
        [parentView addSubview:self.view];
        
//        [quadView setNeedsDisplay];
        // 发送通知
        if (self.imageView) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ZDDesignViewControllChangedCurrentEditImageViewNotification
                                               object:self
                                             userInfo:@{@"imageValue" : self}];
        }
    }
    else {
        noShowPoints = YES;
        quadView.isNotShowPoint = noShowPoints;
        
        point = [recognizer locationInView:self.view];
        [delegate tapOtherLayer:point fromCurtainLayer:self];
    }
}

-(void)setBackground
{
    if (!noShowPoints) {
        noShowPoints = !noShowPoints;
        quadView.isNotShowPoint = noShowPoints;
    }
}

-(BOOL)containsPoint:(CGPoint)point
{
    CGPoint p = [self.view convertPoint:point toView:quadView];
    BOOL pointInside = [quadView.pathData.toBezierPath containsPoint:p];
    if (pointInside) {
        return YES;
    }
    else {
        return NO;
    }
}

-(IBAction)backClick:(id)sender
{
    [self cleanup];
    [self.navigationController popViewControllerAnimated:YES];
}

// TODO: 切换窗帘两种模式：快速设计 叠加设计
/**
 *  快速设计：只有一个窗帘贴图时（一个贴图为整体窗帘），点击素材切换窗帘，直接在设置好的坐标点上呈现
 *          当有两个窗帘贴图时（一个贴图为一个帘），点击素材切换窗帘，直接在设置好的坐标点上呈现
 *  叠加设计：点击素材切换窗帘，叠加创建视图
 */
-(void)setCurtainImage:(UIImage *)aCurtainImage
{
    curtainImage = aCurtainImage;
    qbImageView.image = nil;
    
    // 设置图片大小为原始大小的1/2
    CGFloat w = curtainImage.size.width;
    CGFloat h = curtainImage.size.height;
    if (curtainImage.scale == 1) {
        w = w/2.0;
        h = h/2.0;
    }
    // TODO: 手机版本尺寸适配
    if (IS_IPHONE) {
        if (h>SCREEN_HEIGHT) {
            w = w * (300/h);
            h = 300;
        }
    }
    
    self.imageView.image = curtainImage;
    // 快速设计
    if (self.designType == ZDDesignViewControllerDesignTypeQuick) {
        // 如果是第一次设置窗帘贴图（即：第一次添加贴图时，才会进入此代码块）
        if (self.isFirstCurtainImage) {
            // 设置四个控制区域view的中点
            CGSize vs = self.view.frame.size;
            self.topLeftControl.center = CGPointMake((vs.width - w)/2.0, (vs.height - h)/2.0);
            self.topRightControl.center = CGPointMake((vs.width - w)/2.0+w, (vs.height - h)/2.0);
            self.bottomRightControl.center= CGPointMake((vs.width - w)/2.0+w, (vs.height - h)/2.0+h);
            self.bottomLeftControl.center = CGPointMake((vs.width - w)/2.0, (vs.height - h)/2.0+h);
            
            [quadView.pathData.points removeAllObjects];
            quadView.pathData.noneAutoDelete = YES;
            [quadView.pathData addPoint:CGPointMake((vs.width - w)/2.0, (vs.height - h)/2.0)];
            [quadView.pathData addPoint:CGPointMake((vs.width - w)/2.0+w, (vs.height - h)/2.0)];
            [quadView.pathData addPoint:CGPointMake((vs.width - w)/2.0+w, (vs.height - h)/2.0+h)];
            [quadView.pathData addPoint:CGPointMake((vs.width - w)/2.0, (vs.height - h)/2.0+h)];
            // 更新数值
            self.isFirstCurtainImage = NO;
        }
    }
    // 叠加设计
    else if (self.designType == ZDDesignViewControllerDesignTypeOrigin) {
        // 设置四个控制区域view的中点
        CGSize vs = self.view.frame.size;
        self.topLeftControl.center = CGPointMake((vs.width - w)/2.0, (vs.height - h)/2.0);
        self.topRightControl.center = CGPointMake((vs.width - w)/2.0+w, (vs.height - h)/2.0);
        self.bottomRightControl.center= CGPointMake((vs.width - w)/2.0+w, (vs.height - h)/2.0+h);
        self.bottomLeftControl.center = CGPointMake((vs.width - w)/2.0, (vs.height - h)/2.0+h);
        
        [quadView.pathData.points removeAllObjects];
        quadView.pathData.noneAutoDelete = YES;
        [quadView.pathData addPoint:CGPointMake((vs.width - w)/2.0, (vs.height - h)/2.0)];
        [quadView.pathData addPoint:CGPointMake((vs.width - w)/2.0+w, (vs.height - h)/2.0)];
        [quadView.pathData addPoint:CGPointMake((vs.width - w)/2.0+w, (vs.height - h)/2.0+h)];
        [quadView.pathData addPoint:CGPointMake((vs.width - w)/2.0, (vs.height - h)/2.0+h)];
    }
#pragma mark - 销售实例窗帘坐标配置
    // 销售实例进入
//    else if (self.type == iJADesignViewControllerSourceTypeSaleSample) {
//        [quadView.pathData.points removeAllObjects];
//        quadView.pathData.noneAutoDelete = YES;
//        // 根据实例确定坐标
//        if (self.sampleIndex == 1) {
//            [quadView.pathData addPoint:CGPointMake(625, 262)];
//            [quadView.pathData addPoint:CGPointMake(925, 210)];
//            // 小
//            [quadView.pathData addPoint:CGPointMake(920, 488)];
//            [quadView.pathData addPoint:CGPointMake(625, 460)];
//            // 大
////            [quadView.pathData addPoint:CGPointMake(920, 546)];
////            [quadView.pathData addPoint:CGPointMake(625, 510)];
//        }
//        else if (self.sampleIndex == 2) {
//            [quadView.pathData addPoint:CGPointMake(700, 238)];
//            [quadView.pathData addPoint:CGPointMake(880, 213)];
//            [quadView.pathData addPoint:CGPointMake(880, 495)];
//            [quadView.pathData addPoint:CGPointMake(700, 480)];
//        }
//        else if (self.sampleIndex == 3) {
//            [quadView.pathData addPoint:CGPointMake(143, 190)];
//            [quadView.pathData addPoint:CGPointMake(366, 237)];
//            // 小
//            [quadView.pathData addPoint:CGPointMake(366, 410)];
//            [quadView.pathData addPoint:CGPointMake(143, 423)];
//            // 大
////            [quadView.pathData addPoint:CGPointMake(366, 450)];
////            [quadView.pathData addPoint:CGPointMake(143, 470)];
//        }
//    }
    
    [quadView refreshQuad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self createAndApplyQuad];
    [self createOverlay];
}

#pragma mark - QuadrilateralDesignViewDelegata
// 拖拽时同步调用（经常）
-(void)quadChanged:(Quadrilateral*)quad;
{
    [self createAndApplyQuad];
}

-(IBAction)selectExitingPicture
{
    //Specially for fing iPAD
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    
    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
    [self.popoverController presentPopoverFromRect:CGRectMake(0.0, 0.0, 500.0, 600.0)
                                       inView:self.view
                     permittedArrowDirections:UIPopoverArrowDirectionAny
                                     animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __strong UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // do something with pickedImage
    if (selectedState == 1)
    {
        CGSize size = pickedImage.size;
        qbImageView.image = pickedImage;
        if (size.width > 1024 || size.height >768) {
            qbImageView.frame = CGRectMake(qbImageView.frame.origin.x, qbImageView.frame.origin.y, size.width/2.0, size.height/2.0);
        }
        else {
            qbImageView.frame = CGRectMake(qbImageView.frame.origin.x, qbImageView.frame.origin.y, size.width, size.height);
        }
    }
        
    else if (selectedState == 2)
    {
        self.imageView.image = pickedImage;
    }
//    else
//        self.selectedHuaSe = pickedImage;
//    
//    resultImage.image=pickedImage;
//    [pickedImage release];
}

-(IBAction)selectPictureQB:(id)sender
{
    //self.pic1
    selectedState = 1;
    [self selectExitingPicture];
}

-(IBAction)selectPictureCL:(id)sender
{
    selectedState = 2;
    [self selectExitingPicture];
}

/**
 *  根据pathData的points时刻变更显示效果
 *  1. setter方法设置curtainImage -> 根据curtainImage大小配置pathData
 *  2. 根据quadView（QuadrilateralDesignView）的pan手势配置pathData 同步更改效果
 */
- (void)createAndApplyQuad
{
//    AGQuad quad = AGQuadMakeWithCGPoints(self.topLeftControl.center,
//                                         self.topRightControl.center,
//                                         self.bottomRightControl.center,
//                                         self.bottomLeftControl.center);
    
    // 根据pan手势同步改变AG多边形的形状
    AGQuad quad = quadView.quadrilateral.toAGQuad;
    
    if(AGQuadIsValid(quad))
    {
        // 将形状同步到imageView.layer的多边形属性
        self.imageView.layer.quadrilateral = quad;
    }
    self.maskView.layer.shadowPath = [UIBezierPath bezierPathWithAGQuad:quad].CGPath;
}

- (IBAction)panGestureChanged:(UIPanGestureRecognizer *)recognizer
{
    UIImageView *view = (UIImageView *)[recognizer view];
    
    CGPoint translation = [recognizer translationInView:self.view];
    view.centerX += translation.x;
    view.centerY += translation.y;
    [recognizer setTranslation:CGPointZero inView:self.view];
    
    view.highlighted = recognizer.state == UIGestureRecognizerStateChanged;
    
    [self createAndApplyQuad];
}

- (void)createOverlay
{
    self.maskView = [[UIView alloc] init];
    self.maskView.center = self.imageView.center;
    self.maskView.layer.shadowColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5].CGColor;
    self.maskView.layer.shadowOpacity = 1.0;
    self.maskView.layer.shadowRadius = 0.0;
    self.maskView.layer.shadowOffset = CGSizeZero;
    self.maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    self.maskView.userInteractionEnabled = NO;
    self.maskView.hidden = !self.switchControl.on;
    [self.view addSubview:self.maskView];
}
	
- (IBAction)toggleDisplayOverlay:(UISwitch *)switchControl
{
    self.maskView.hidden = !self.switchControl.on;
}

@end
