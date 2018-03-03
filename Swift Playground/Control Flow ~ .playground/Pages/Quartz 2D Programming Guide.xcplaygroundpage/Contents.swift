//: [Previous](@previous)

import Foundation
import UIKit
//import QuartzCore
//import CoreGraphics
extension CGContext {
    func configureGState(lineWidth: CGFloat, strokeColor: UIColor) -> Void {
        self.setLineWidth(lineWidth)
        self.setStrokeColor(strokeColor.cgColor)
    }
}

let superview = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 320, height: 640))
superview.backgroundColor = .white

let size = superview.bounds.size
UIGraphicsBeginImageContextWithOptions(size, true, 1.0)
let myContext = UIGraphicsGetCurrentContext()

myContext?.move(to: CGPoint.init(x: 0, y: 0))
myContext?.addLine(to: CGPoint.init(x: 200, y: 80))
myContext?.addLine(to: CGPoint.init(x: 200, y: 180))
myContext?.addLine(to: CGPoint.init(x: 100, y: 180))
myContext?.closePath()

// 1. 第一个state
myContext?.configureGState(lineWidth: 3, strokeColor: .red)
myContext?.saveGState()
//myContext?.setContextParameters(lineWidth: 13, strokeColor: .white) // 操作3 restore不会恢复这条state
//myContext?.strokePath()

myContext?.setFillColor(UIColor.gray.cgColor)
myContext?.drawPath(using: .fillStroke)


myContext?.move(to: CGPoint.init(x: 50, y: 250))
myContext?.addLine(to: CGPoint.init(x: 200, y: 500))
// 2. 修改了state
myContext?.configureGState(lineWidth: 10, strokeColor: .blue)
myContext?.strokePath()


myContext?.move(to: CGPoint.init(x: 0, y: 250))
myContext?.addArc(tangent1End: CGPoint.init(x: 210, y: 250), tangent2End: CGPoint.init(x: 150, y: 360), radius: 70) // 圆弧
myContext?.configureGState(lineWidth: 5, strokeColor: .orange)
//myContext?.saveGState() // 如果调用这里，就会将这个state推到栈顶 操作3 restore后将是获取到这个state
// 3. 回到1保存的state 如果不调用 会继续沿用操作2的state
//myContext?.restoreGState() 
//myContext?.strokePath()

// Fill & Stroke
myContext?.setFillColor(UIColor.gray.cgColor)
myContext?.drawPath(using: .fillStroke)

/**
 MARK:- 总结
    - strokePath/fillPath 要想画出多个配置的path，就在每段效果path的结尾进行stroke/fill操作
    - saveGState          保存当前配置，保存至栈顶
    - restoreGState       恢复上一个配置，即当前栈顶的配置
 
*/

let image = UIGraphicsGetImageFromCurrentImageContext()

let imageView = UIImageView.init(frame: superview.bounds)
imageView.image = image
superview.addSubview(imageView)




//: [Next](@next)
