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

// Using AGPoint for
// - better precision with double when calculating transform for quadrilaterals
// - being able to access values with index

typedef union AGPoint {
    struct { double x, y; };
    double v[2];
} AGPoint;

extern const AGPoint AGPointZero;
extern BOOL AGPointEqual(AGPoint p1, AGPoint p2);
extern BOOL AGPointEqualToCGPoint(AGPoint p1, CGPoint p2);
extern AGPoint AGPointMakeWithCGPoint(CGPoint cg);
extern AGPoint AGPointMakeWithCGPointZeroFill(CGPoint cg);
extern AGPoint AGPointMake(double x, double y);
extern AGPoint AGPointInterpolate(AGPoint p1, AGPoint p2, double progress);
extern AGPoint AGPointSubtract(AGPoint p1, AGPoint p2);
extern AGPoint AGPointAdd(AGPoint p1, AGPoint p2);
extern AGPoint AGPointMultiply(AGPoint p1, double factor);
extern double AGPointDotProduct(AGPoint p1, AGPoint p2);
extern double AGPointCrossProduct(AGPoint p1, AGPoint p2);
extern CGPoint AGPointAsCGPoint(AGPoint p);
extern NSString * NSStringFromAGPoint(AGPoint p);
