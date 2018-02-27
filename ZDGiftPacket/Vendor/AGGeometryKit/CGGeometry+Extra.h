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

#import <Foundation/Foundation.h>

// http://processingjs.nihongoresources.com/bezierinfo/

CGPoint CGPointGetPointForAnchorPointInRect(CGPoint anchor, CGRect rect);
CGPoint CGPointGetAnchorPointForPointInRect(CGPoint point, CGRect rect);
CGPoint CGPointForCenterInRect(CGRect rect);
extern CGFloat CGPointDistanceBetweenPoints(CGPoint p1, CGPoint p2);
extern CGPoint CGPointNormalizedDistance(CGPoint p1, CGPoint p2);
extern double CGSizeGetAspectRatio(CGSize size);
extern BOOL CGSizeAspectIsWiderThanCGSize(CGSize size1, CGSize size2);
CGSize CGSizeAdjustOuterSizeToFitInnerSize(CGSize outer, CGSize inner);
extern BOOL CGRectGotAnyNanValues(CGRect rect);
extern BOOL CGSizeGotAnyNanValues(CGSize size);
extern BOOL CGPointGotAnyNanValues(CGPoint origin);
extern CGPoint CGPointAddSize(CGPoint p, CGSize s);
extern CGRect CGRectMakeWithSize(CGSize size);
extern CGPoint CGRectGetMidPoint(CGRect rect);
extern CGSize CGSizeGetHalf(CGSize size);
extern CGSize CGSizeSwitchAxis(CGSize size);
extern CGRect CGRectWithSize(CGRect rect, CGSize newSize);
extern CGRect CGRectWithWidth(CGRect rect, CGFloat newWidth);
extern CGRect CGRectWithHeight(CGRect rect, CGFloat newHeight);
extern CGRect CGRectWithOrigin(CGRect rect, CGPoint origin);
extern CGRect CGRectWithOriginMinX(CGRect rect, CGFloat value);
extern CGRect CGRectWithOriginMinY(CGRect rect, CGFloat value);
extern CGRect CGRectWithOriginMaxY(CGRect rect, CGFloat value);
extern CGRect CGRectWithOriginMaxX(CGRect rect, CGFloat value);
extern CGRect CGRectWithOriginMidX(CGRect rect, CGFloat value);
extern CGRect CGRectWithOriginMidY(CGRect rect, CGFloat value);
extern CGRect CGRectApply(CGRect rect, CGRect (^block)(CGRect rect));
extern CGSize CGSizeApply(CGSize size, CGSize (^block)(CGSize size));
extern CGPoint CGPointApply(CGPoint point, CGPoint (^block)(CGPoint point));
CGRect CGRectSmallestWithCGPoints(CGPoint pointsArray[], int numberOfPoints);
CGSize CGSizeInterpolate(CGSize size1, CGSize size2, double progress);
CGPoint CGPointInterpolate(CGPoint point1, CGPoint point2, double progress);
CGRect CGRectInterpolate(CGRect rect1, CGRect rect2, double progress);
CGPoint CGPointApplyCATransform3D(CGPoint point, CATransform3D transform, CGPoint anchorPoint, CATransform3D parentSublayerTransform);
extern CGPoint CGPointVectorNormalize(CGPoint v);
extern CGFloat CGPointVectorGetLength(CGPoint v);
extern CGFloat CGPointVectorDotProduct(CGPoint v1, CGPoint v2);
extern CGFloat CGPointVectorCrossProductZComponent(CGPoint v1, CGPoint v2);

