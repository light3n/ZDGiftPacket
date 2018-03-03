//: [Previous](@previous)

import Foundation
import UIKit

/*:
 [CGGeometry](http://nshipster.cn/cggeometry/)
 */
// MARK:- CGGeometry
let superView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 320, height: 640))
superView.backgroundColor = .white

let rect = CGRect.init(x: 0, y: 0, width: 100, height: 100)
let normalView = UIView.init(frame: rect)
normalView.backgroundColor = .red
superView.addSubview(normalView)
superView

// CGRectOffset 返回rect位移后的rect
let offsetRect = rect.offsetBy(dx: 100, dy: 30)
let offsetView = UIView.init(frame: offsetRect)
offsetView.backgroundColor = .blue
superView.addSubview(offsetView)
superView

// CGRectInset 返回rect放大/缩小后的rect（以rect中心为准）
let insetRect = rect.insetBy(dx: 20, dy: 20)
let insetView = UIView.init(frame: insetRect)
insetView.backgroundColor = .black
superView.addSubview(insetView)
superView

// CGRectInset + CGRectOffset
let combindRect = rect.insetBy(dx: 10, dy: 10).offsetBy(dx: 200, dy: 200)
insetView.frame = combindRect
superView

// CGRectUnion 返回包含两个子rect的最小rect
let unionRect = offsetRect.union(combindRect)
let unionView = UIView.init(frame: unionRect)
unionView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
superView.addSubview(unionView)


// CGRectDivide - Rect分割 slice为被切除的那部分 remainder为余下部分
let totalRect = CGRect.init(x: 0, y: 300, width: 200, height: 300)
let (slice, remainder) = totalRect.divided(atDistance: 50, from: .maxXEdge)
print(slice)
let totalView = UIView.init(frame: totalRect)
totalView.backgroundColor = .darkGray
superView.addSubview(totalView)

let sliceView = UIView.init(frame: slice)
sliceView.backgroundColor = .black
superView.addSubview(sliceView)


// MARK:- CGPointApplyAffineTransform
let originPoint = CGPoint.init(x: 100, y: 100)
let transformPoint = __CGPointApplyAffineTransform(originPoint, CGAffineTransform.init(translationX: 50, y: 10))

// MARK:- CGRectApplyAffineTransform
let originRect = CGRect.init(x: 100, y: 100, width: 100, height: 100)
let scaledRect = originRect.applying(CGAffineTransform.init(scaleX: 1.5, y: 1.5))
let rotatedRect = originRect.applying(CGAffineTransform.init(rotationAngle: .pi*2)) //???
print(rotatedRect)

let tfmView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 375, height: 500))
tfmView.backgroundColor = .white
let aatView = UIView.init(frame: originRect)
aatView.backgroundColor = .red
tfmView.addSubview(aatView)
tfmView
// Scale
aatView.frame = scaledRect
tfmView
// Rotate
aatView.frame = rotatedRect
tfmView

// rect -> dictionary representation
let dictRepresentationFromRect = rotatedRect.dictionaryRepresentation
print(dictRepresentationFromRect)
// dictionary representation -> rect
let rectFromDictRepresentation = CGRect.init(dictionaryRepresentation: dictRepresentationFromRect)





//: [Next](@next)
