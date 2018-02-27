//
//  SPImageInpainterController.m
//  InpaintDemo
//
//  Created by Joey on 2018/1/8.
//  Copyright © 2018年 Joey. All rights reserved.
//

#import "SPImageInpainterController.h"
#import "UIImage+OpenCVWapper.h"

@interface SPImageInpainterController ()
@property (nonatomic, strong) UIImageView *srcImageView;
@property (nonatomic, strong) UIImageView *pathImageView;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) UIBezierPath *path;

// UI Elements
@property (nonatomic, strong) UISlider *pathWidthSlider;
@property (nonatomic, strong) UILabel *pathWidthValueLabel;
@property (nonatomic, strong) UIButton *undoButton;
@property (nonatomic, strong) UIButton *redoButton;

@property (nonatomic, readwrite) NSUndoManager *undoManager;

@end

@implementation SPImageInpainterController
@synthesize undoManager;

- (NSUndoManager *)undoManager {
    if (!undoManager) {
        undoManager = [[NSUndoManager alloc] init];
    }
    return undoManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
    // set up
    self.srcImageView = [[UIImageView alloc] init];
    [self.view addSubview:self.srcImageView];
    self.pathImageView = [[UIImageView alloc] init];
    [self.view addSubview:self.pathImageView];
    [self.pathImageView.layer addSublayer:self.shapeLayer];
    
    [self setupUIElements];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)setSourceImage:(UIImage *)sourceImage {
    _sourceImage = sourceImage;
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self setOriginalImage:self.sourceImage];
    
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [[CAShapeLayer alloc] init];
        _shapeLayer.strokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5].CGColor;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.lineCap = kCALineCapRound;
        _shapeLayer.lineJoin = kCALineJoinRound;
        _shapeLayer.lineWidth = 10;
    }
    return _shapeLayer;
}

- (UIBezierPath *)path {
    if (!_path) {
        _path = [[UIBezierPath alloc] init];
    }
    return _path;
}


#pragma mark - Handle Gesture Event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint point = [[touches anyObject] locationInView:self.srcImageView];
    [self.path moveToPoint:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    CGPoint point = [[touches anyObject] locationInView:self.srcImageView];
    [self.path addLineToPoint:point];
    self.shapeLayer.path = self.path.CGPath;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    CGPoint point = [[touches anyObject] locationInView:self.srcImageView];
    [self.path addLineToPoint:point];
    self.shapeLayer.path = self.path.CGPath;
    [self processInpainting];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
}


#pragma mark - Processing Inpainting

- (void)processInpainting {
    UIGraphicsBeginImageContext(self.pathImageView.frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.pathImageView.layer renderInContext:ctx];
    UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.path = nil;
    self.shapeLayer.path = nil;
    
    UIImage *inpaintedImage = [UIImage inpaintImage:self.srcImageView.image
                                          maskImage:maskImage
                                       inpaintRange:3];
    [self setSrcImageViewImage:inpaintedImage];
    [self updateButtonsState];
}


#pragma mark - Undo & Redo

- (void)setSrcImageViewImage:(UIImage *)image {
    [self.undoManager registerUndoWithTarget:self
                                    selector:@selector(setSrcImageViewImage:)
                                      object:self.srcImageView.image];
    [self.undoManager setActionName:@"清除"];
    self.srcImageView.image = image;
}

- (void)handleSaveEvent:(id)sender {
    [SVProgressHUD showWithStatus:@"正在保存..."];
    PMSaveImageToAlbum(self.srcImageView.image, @"一键清除效果图", ^(SPAsset *asset, NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
        [self dismiss];
    });
}

- (void)handleBackEvent:(id)sender {
    [self dismiss];
}

- (void)handleUndoEvent:(id)sender {
    if (self.undoManager.canUndo) {
        [self.undoManager undo];
    }
    [self updateButtonsState];
}

- (void)handleRedoEvent:(id)sender {
    if (self.undoManager.canRedo) {
        [self.undoManager redo];
    }
    [self updateButtonsState];
}

- (void)updateButtonsState {
    self.undoButton.enabled = self.undoManager.canUndo;
    self.redoButton.enabled = self.undoManager.canRedo;
}


#pragma mark - UISlider Value Change Handler

- (void)pathWidthSliderValueChangeHandler:(UISlider *)sender {
    self.shapeLayer.lineWidth = sender.value;
    self.pathWidthValueLabel.text = [NSString stringWithFormat:@"画笔：%.f", sender.value];
}


#pragma mark - Custom Methods

- (CGSize)adjustedSizeWithImage:(UIImage *)srcImage {
    CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds);
    CGFloat width = srcImage.size.width / srcImage.size.height * height;
    return CGSizeMake(width, height);
}

- (void)setOriginalImage:(UIImage *)image {
    CGSize size = [self adjustedSizeWithImage:image];
    self.srcImageView.frame = {{0, 0}, size};
    self.srcImageView.center = self.view.center;
    self.pathImageView.frame = self.srcImageView.frame;
    
    UIGraphicsBeginImageContext(self.srcImageView.bounds.size);
    [image drawInRect:self.srcImageView.bounds];
    UIImage *srcImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.srcImageView.image = srcImage;
    
    [self.view layoutIfNeeded];
}

- (void)setupUIElements {
    CGPoint center = self.view.center;
    center.y = 15;
    
    // title label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 32)];
    titleLabel.center = center;
    titleLabel.text = @"一键清除";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    CGFloat elementY = CGRectGetMidY(titleLabel.frame);
    CGFloat buttonWidth = 40;
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    // back button
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(44, elementY, buttonWidth, buttonWidth)];
    [backButton setImage:[UIImage imageNamed:@"global_backButton"] forState:UIControlStateNormal];
    [backButton.titleLabel setTextColor:[UIColor whiteColor]];
    [backButton addTarget:self
                   action:@selector(handleBackEvent:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // save button
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - buttonWidth*2, elementY, buttonWidth, buttonWidth)];
    [saveButton setImage:[UIImage imageNamed:@"userdata_save"] forState:UIControlStateNormal];
    [saveButton addTarget:self
                   action:@selector(handleSaveEvent:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];

    // redo button
    UIButton *redoButton = [[UIButton alloc] initWithFrame:CGRectOffset(saveButton.frame, -buttonWidth*2, 0)];
    [redoButton setImage:[UIImage imageNamed:@"virtualDesign_redo"] forState:UIControlStateNormal];
    [redoButton addTarget:self
                   action:@selector(handleRedoEvent:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:redoButton];
    self.redoButton = redoButton;
    
    // undo button
    UIButton *undoButton = [[UIButton alloc] initWithFrame:CGRectOffset(redoButton.frame, -buttonWidth*2, 0)];
    [undoButton setImage:[UIImage imageNamed:@"virtualDesign_undo"] forState:UIControlStateNormal];
    [undoButton addTarget:self
                   action:@selector(handleUndoEvent:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:undoButton];
    self.undoButton = undoButton;
    
    // path width value label
    UILabel *pathWidthValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth-100, CGRectGetMaxY(saveButton.frame)+10, 100, 32)];
    pathWidthValueLabel.text = @"画笔：5";
    pathWidthValueLabel.textAlignment = NSTextAlignmentCenter;
    pathWidthValueLabel.font = [UIFont systemFontOfSize:14];
    pathWidthValueLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:pathWidthValueLabel];
    self.pathWidthValueLabel = pathWidthValueLabel;
    
    // slider
    CGAffineTransform rotationTfm = CGAffineTransformMakeRotation(M_PI * 0.5);
    CGPoint sliderCenter = CGPointMake(pathWidthValueLabel.center.x, CGRectGetMaxY(pathWidthValueLabel.frame)+10+100);
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    slider.center = sliderCenter;
    slider.transform = rotationTfm;
    slider.minimumValue = 5;
    slider.maximumValue = 50;
    slider.value = 5;
    [slider addTarget:self
               action:@selector(pathWidthSliderValueChangeHandler:)
     forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    self.pathWidthSlider = slider;
    
    [self updateButtonsState];
    
}
@end

