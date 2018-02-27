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

#import <QuartzCore/QuartzCore.h>
#import "AGQuad.h"
#import "CALayer+Extensions.h"

@interface CALayer (AGQuad)

/**
 * @property AGQuad quadrilateral
 * Updating this property will update property 'transform' unless it is set to AGQuadZero
 * @abstract 
 *   If transform is set to CATransform3DIdentity the quad returned will be similar to bounds.
 * @discussion
 *   It is only possible to make convex transforms with quadrilaterals.
 *   So make sure your quadrilateral is convex.
 *   http://upload.wikimedia.org/wikipedia/commons/f/f1/Quadrilateral_hierarchy.png
 */
@property (nonatomic, assign) AGQuad quadrilateral;

- (AGQuad)convertAGQuad:(AGQuad)quad fromLayer:(CALayer *)l;
- (AGQuad)convertAGQuad:(AGQuad)quad toLayer:(CALayer *)l;

- (void)animateFromQuadrilateral:(AGQuad)quad1
                 toQuadrilateral:(AGQuad)quad2
               forNumberOfFrames:(NSUInteger)numberOfFrames
                        duration:(NSTimeInterval)duration
                           delay:(NSTimeInterval)delay
                         animKey:(NSString *)animKey
                    easeFunction:(double(^)(double p))progressFunction
                      onComplete:(void(^)(BOOL finished))onComplete;

- (void)animateFromPresentedStateToQuadrilateral:(AGQuad)quad
                               forNumberOfFrames:(NSUInteger)numberOfFrames
                                        duration:(NSTimeInterval)duration
                                           delay:(NSTimeInterval)delay
                                         animKey:(NSString *)animKey
                                    easeFunction:(double(^)(double p))progressFunction
                                      onComplete:(void(^)(BOOL finished))onComplete;

@end