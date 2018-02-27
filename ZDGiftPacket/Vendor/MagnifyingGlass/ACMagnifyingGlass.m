//
//  ACMagnifyingGlass.m
//  MagnifyingGlass
//

#import "ACMagnifyingGlass.h"
#import <QuartzCore/QuartzCore.h>


static CGFloat const kACMagnifyingGlassDefaultRadius = 64;
static CGFloat const kACMagnifyingGlassDefaultOffset = -64;
static CGFloat const kACMagnifyingGlassDefaultScale = 1.5;

@interface ACMagnifyingGlass ()
@end

@implementation ACMagnifyingGlass

@synthesize viewToMagnify, touchPoint, touchPointOffset, scale, scaleAtTouchPoint;

- (id)init {
    self = [self initWithFrame:CGRectMake(100, 100, kACMagnifyingGlassDefaultRadius*2, kACMagnifyingGlassDefaultRadius*2)];
    return self;
}

- (id)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
		
		self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
		self.layer.borderWidth = 3;
		self.layer.cornerRadius = frame.size.width / 2;
		self.layer.masksToBounds = YES;
		self.touchPointOffset = CGPointMake(0, kACMagnifyingGlassDefaultOffset);
		self.scale = kACMagnifyingGlassDefaultScale;
		self.viewToMagnify = nil;
		self.scaleAtTouchPoint = YES;
	}
	return self;
}

- (void)setFrame:(CGRect)f {
	super.frame = f;
	self.layer.cornerRadius = f.size.width / 2;
}

- (void)setTouchPoint:(CGPoint)point {
	touchPoint = point;
//	self.center = CGPointMake(point.x + touchPointOffset.x, point.y + touchPointOffset.y);
//    ZDLog(@"current point.x = %.2f, current point.y = %.2f", point.x, point.y );
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, self.frame.size.width/2, self.frame.size.height/2 );
	CGContextScaleCTM(context, scale, scale);
	CGContextTranslateCTM(context, -touchPoint.x, -touchPoint.y + (self.scaleAtTouchPoint? 0 : self.bounds.size.height/2));
	[self.viewToMagnify.layer renderInContext:context];
}

- (void)sp_updatePositionWithCurrentScaleOriginPoint:(CGPoint)point {
    CGRect leftRect = CGRectMake(100,
                                 100,
                                 kACMagnifyingGlassDefaultRadius*2,
                                 kACMagnifyingGlassDefaultRadius*2);
    CGRect rightRect = CGRectMake([UIScreen mainScreen].bounds.size.width - 100 - kACMagnifyingGlassDefaultRadius*2,
                                  100,
                                  kACMagnifyingGlassDefaultRadius*2,
                                  kACMagnifyingGlassDefaultRadius*2);

    // 当前放大的点（原始坐标）在放大镜左边frame内 且 放大镜当前frame在左，放大镜就移到右边
    if (CGRectContainsPoint(leftRect, point)) {
        self.frame = rightRect;
    } else {
        // 其余情况一律放在左边
        self.frame = leftRect;
    }
}

@end
