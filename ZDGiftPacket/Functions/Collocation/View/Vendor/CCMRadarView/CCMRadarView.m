//
//  CCMRadarView.m
//  Ija
//
//  Created by Orville on 15/5/26.
//  Copyright (c) 2015年 Orville. All rights reserved.
//

#import "CCMRadarView.h"

@implementation CCMRadarView
@synthesize color;
@synthesize animating;
@synthesize circleArray;
@synthesize reversedRadar;
@synthesize numberOfWaves;
@synthesize radarColor;
@synthesize innerRadius;
@synthesize iconImage;
@synthesize iconSize;
@synthesize waveWidth;
@synthesize maxWaveAlpha;

-(void)setReversedRadar:(BOOL)theReversedRadar
{
    reversedRadar = theReversedRadar;
    [self initialSetup];
}

-(void)setNumberOfWaves:(int)theNumberOfWaves
{
    numberOfWaves = theNumberOfWaves;
    [self initialSetup];
}

-(void)setRadarColor:(UIColor *)theRadarColor
{
    radarColor = theRadarColor;
    [self initialSetup];
}

-(void)setInnerRadius:(double)theInnerRadius
{
    innerRadius = theInnerRadius;
    [self initialSetup];
}

-(void)setIconImage:(UIImage *)theIconImage
{
    iconImage = theIconImage;
    [self initialSetup];
}

-(void)setIconSize:(CGSize)theIconSize
{
    iconSize = theIconSize;
    [self initialSetup];
}

-(void)setWaveWidth:(CGFloat)theWaveWidth
{
    waveWidth = theWaveWidth;
    [self initialSetup];
}

-(void)setMaxWaveAlpha:(CGFloat)theMaxWaveAlpha
{
    maxWaveAlpha = theMaxWaveAlpha;
    [self initialSetup];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setInitialValues];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setInitialValues];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setInitialValues];
    }
    return self;
}

-(void)setInitialValues
{
    self.color = [UIColor blueColor];
    self.animating = FALSE;
    self.circleArray = [NSMutableArray array];
    reversedRadar = FALSE;
    numberOfWaves = 4;
    radarColor = [UIColor blueColor];
    innerRadius = 5.0;
    iconImage = nil;
    iconSize = CGSizeMake(20, 20);
    waveWidth = 2;
    maxWaveAlpha = 1;
    
    [self initialSetup];
}

-(void)initialSetup
{
    self.layer.sublayers = [NSMutableArray array];
    double insetOffsetDelta = ((CGRectGetHeight(self.layer.bounds)/2) - innerRadius) / (numberOfWaves);
    CGFloat currentInsetOffset = 0;
    
    CGFloat currentAlpha = maxWaveAlpha;
    if (reversedRadar) {
        for (int i = 1; i < numberOfWaves; i++) {
            currentAlpha /= 2.5;
        }
    }
    
    for (int index = 0; index < numberOfWaves; index++) {
        CAShapeLayer* sublayer = [[CAShapeLayer alloc] init];
        sublayer.frame = CGRectInset(self.layer.bounds, currentInsetOffset, currentInsetOffset);
        UIBezierPath* circle = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(sublayer.bounds, waveWidth, waveWidth)];
        sublayer.path = circle.CGPath;
        sublayer.strokeColor = radarColor.CGColor;
        sublayer.lineWidth = waveWidth;
        sublayer.fillColor = [UIColor clearColor].CGColor;
        sublayer.opacity = currentAlpha;
        [self.layer addSublayer:sublayer];
        currentInsetOffset += (CGFloat)insetOffsetDelta;
        if(reversedRadar){
            currentAlpha *= 2.5;
        } else {
            currentAlpha /= 2.5;
        }
    }
    
    if (iconImage) {
        CGRect rect = CGRectMake((self.bounds.size.width - iconSize.width) / 2.0, (self.bounds.size.height - iconSize.height) / 2.0, iconSize.width, iconSize.height);
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:rect];
        
        imageView.image = iconImage;
        [self addSubview:imageView];
    }
    
}

-(void)startAnimation
{
    animating = TRUE;
    
    if (self.layer.sublayers != nil) {
        for (int index = 0; index < self.layer.sublayers.count; index++)
        {
            CALayer* sublayer = [self.layer.sublayers objectAtIndex:index];
            if ([sublayer isKindOfClass:[CAShapeLayer class]])
            {
                CAKeyframeAnimation* animation = [[CAKeyframeAnimation alloc] init];
                animation.keyPath = @"opacity";
                animation.values = [NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0], [NSNumber numberWithInt:1], [NSNumber numberWithInt:0], nil];
                animation.duration = 1.5;
                double beginTime = 0;
                if (!reversedRadar){
                    beginTime = ((animation.duration)/(numberOfWaves + 1)) * ((self.layer.sublayers.count) - 1.0 - (index));
                } else {
                    beginTime = ((animation.duration)/(numberOfWaves + 1)) * (index);
                }
                animation.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithDouble:0], [NSNumber numberWithDouble:beginTime/animation.duration], [NSNumber numberWithDouble:beginTime/animation.duration], [NSNumber numberWithInt:(beginTime + (animation.duration)/((numberOfWaves) - 2.5))/animation.duration], nil];
//                [0, beginTime/animation.duration, beginTime/animation.duration, (beginTime + (animation.duration)/((numberOfWaves) - 2.5))/animation.duration];
                animation.delegate = self;
                [sublayer addAnimation:animation forKey:@"animForLayer\(index)"];
//                sublayer.addAnimation(animation, forKey: "animForLayer\(index)");
                sublayer.opacity = 0;
            }
        }
    }
}

-(void)animationDidStart:(CAAnimation*)anim
{
//    for (int index = 0; index < self.layer.sublayers.count; index++)
//    {
//        CALayer* sublayer = [self.layer.sublayers objectAtIndex:index];
//        
//        if ([sublayer animationForKey:@"animForLayer\(index)"] == anim) {
//            XCPCaptureValue("animForLayer\(index)", 1);
//        }
//    }
}


-(void)animationDidStop:(CAAnimation*)anim finished:(BOOL)flag
{
    if (flag){
        for (int index = 0; index < self.layer.sublayers.count; index++)
        {
//            CALayer* sublayer = [self.layer.sublayers objectAtIndex:index];
            
            if(index == self.layer.sublayers.count - 1 && animating){
                [self startAnimation];
            } else {
                [self restoreInitialAlphas];
            }
        }
    }
}

-(void)restoreInitialAlphas
{
    __block CGFloat currentAlpha = maxWaveAlpha;
    if (reversedRadar)
    {
        for (int i = 1; i < numberOfWaves; i++) {
            currentAlpha /= 2.5;
        }
    }

    [UIView animateWithDuration:0.6 animations:^{
        for (int index = 0; index < self.layer.sublayers.count; index++) {
            CALayer* sublayer = [self.layer.sublayers objectAtIndex:index];
            if ([sublayer isKindOfClass:[CAShapeLayer class]]) {
                sublayer.opacity = currentAlpha;
                if(self.reversedRadar){
                    currentAlpha *= 2.5;
                } else {
                    currentAlpha /= 2.5;
                }
            }
        }
    }];
}

-(void)stopAnimation
{
    animating = FALSE;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    [self initialSetup];
}

//override func layoutSubviews() {
//    initialSetup()
//}

// Draw Rect implementation not usefull when animating its contents
/*
 override func drawRect(rect: CGRect) {
 var context = UIGraphicsGetCurrentContext();
 let insetOffsetDelta = (Double(CGRectGetHeight(rect)/2) - innerRadius) / Double(numberOfWaves)
 let alphaVariance = (maxWaveAlpha - minWaveAlpha) / CGFloat(numberOfWaves)
 var currentInsetOffset:CGFloat = waveWidth/2;
 var currentAlpha = maxWaveAlpha;
 
 for index in 0..<numberOfWaves {
 var circle = UIBezierPath(ovalInRect: CGRectInset(rect, currentInsetOffset, currentInsetOffset))
 radarColor.setStroke()
 circle.lineWidth = waveWidth;
 circle.strokeWithBlendMode(kCGBlendModeNormal, alpha: currentAlpha)
 circleArray.append(circle)
 currentInsetOffset += CGFloat(insetOffsetDelta)
 currentAlpha /= 2.5
 }
 
 
 }
 */

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
