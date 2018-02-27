//
// Author: Håvard Fossli <hfossli@agens.no>
// Author: https://github.com/kennytm
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

#import <Foundation/Foundation.h>
#import "AGPoint.h"

/*
 tl = top left
 tr = top right
 br = bottom right
 bl = bottom left
 */

typedef union AGQuad {
    struct { AGPoint tl, tr, br, bl; };
    AGPoint v[4];
} AGQuad;

extern const AGQuad AGQuadZero;
extern BOOL AGQuadEqual(AGQuad q1, AGQuad q2);
extern BOOL AGQuadIsConvex(AGQuad q);
extern BOOL AGQuadIsValid(AGQuad q);
extern AGQuad AGQuadMove(AGQuad q, double x, double y);
extern AGQuad AGQuadInsetLeft(AGQuad q, double inset);
extern AGQuad AGQuadInsetRight(AGQuad q, double inset);
extern AGQuad AGQuadInsetTop(AGQuad q, double inset);
extern AGQuad AGQuadInsetBottom(AGQuad q, double inset);
extern AGQuad AGQuadMirror(AGQuad q, BOOL x, BOOL y);
extern AGQuad AGQuadMake(AGPoint tl, AGPoint tr, AGPoint br, AGPoint bl);
extern AGQuad AGQuadMakeWithCGPoints(CGPoint tl, CGPoint tr, CGPoint br, CGPoint bl);
extern AGQuad AGQuadMakeWithCGRect(CGRect rect);
extern AGQuad AGQuadMakeWithCGSize(CGSize size);
extern double AGQuadGetSmallestX(AGQuad q);
extern double AGQuadGetBiggestX(AGQuad q);
extern double AGQuadGetSmallestY(AGQuad q);
extern double AGQuadGetBiggestY(AGQuad q);
extern CGRect AGQuadGetBoundingRect(AGQuad q);
extern AGPoint AGQuadGetCenter(AGQuad q);
extern CGSize AGQuadGetSize(AGQuad q);
void AGQuadGetXValues(AGQuad q, double *out_values);
void AGQuadGetYValues(AGQuad q, double *out_values);
extern AGQuad AGQuadInterpolation(AGQuad q1, AGQuad q2, double progress);
extern AGQuad AGQuadApplyCGAffineTransform(AGQuad q, CGAffineTransform t);
extern AGQuad AGQuadApplyCATransform3D(AGQuad q, CATransform3D t);
extern NSString * NSStringFromAGQuad(AGQuad q);

/**
 * @discussion
 *   It is only possible to make 'convex quadrilateral' with transforms.
 *   So make sure your quadrilateral is convex.
 *   http://upload.wikimedia.org/wikipedia/commons/f/f1/Quadrilateral_hierarchy.png
 */
CATransform3D CATransform3DWithQuadFromBounds(AGQuad q, CGRect rect);
CATransform3D CATransform3DWithQuadFromRect(AGQuad q, CGRect rect);

