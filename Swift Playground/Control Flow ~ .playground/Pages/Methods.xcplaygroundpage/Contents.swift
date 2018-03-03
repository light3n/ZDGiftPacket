//: [Previous](@previous)

import Foundation


// MARK: - self 属性
// @note 当实例方法的参数名称跟实例属性的名称相同时，参数名称享有优先权，可以使用self属性来区分参数名称和属性名称
struct Point {
    var x = 0.0, y = 0.0
    func isToTheRightOfX(_ x: Double) -> Bool {
        return self.x > x
    }
}
let somePoint = Point(x: 4.0, y: 5.0)
if somePoint.isToTheRightOfX(1.0) {
    print("This point is to the right of the line where x == 1.0")
}
// 打印 "This point is to the right of the line where x == 1.0"


// MARK: - 在实例方法中修改值类型
// 结构体和枚举是值类型。默认情况下，值类型不能在实例方法中被修改
// @note 为方法选择可变行为 mutating
// 这个方法做的任何改变都会在方法结束时写回到原始结构中，从方法内部改变它的属性
// 也可以给它银行的 self 属性赋予一个全新的实例，这个新实例会在方法结束时替换现存实例
struct Point2 {
    var x = 0.0, y = 0.0
    mutating func moveByX(_ deltaX: Double, y deltaY: Double) {
        x += deltaX
        y += deltaY
    }
}

var point = Point2()
point.moveByX(2.0, y: 3.0)
print("point is now at position (\(point.x), \(point.y))")

// MARK: - 在可变方法中给 self 赋值
struct Point3 {
    var x = 0.0, y = 0.0
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        self = Point3(x: x + deltaX, y: y + deltaY)
    }
}
var point3 = Point3(x: 1.0, y: 1.0)
point3.moveBy(x: 2.0, y: 3.0)
print("point3 is now at position (\(point3.x), \(point3.y))")

// 枚举
enum TriStateSwitch {
    case Off, Low, High
    mutating func next() {
        switch self {
        case .Off:
            self = .Low
        case .Low:
            self = .High
        case .High:
            self = .Off
        }
    }
}
var ovenLight = TriStateSwitch.Low
ovenLight.next() // 现在为 .High
ovenLight.next() // 现在为 .Off

// MARK: - 类型方法
// func 关键字前加上 static 关键字来定义类型方法，也可以改用 class 关键字来允许子类重写父类的方法实现
// 跟类型属性一致
class SomeClass {
    static var someTypeProperty = 0
    static func someTypeMethod() {
        someTypeProperty // 类型方法可直接访问类型属性
        someTypeMethod2() // 类型方法可直接访问其他类型方法
    }
    class func someTypeMethod2() {
    
    }
}
SomeClass.someTypeMethod()




//: [Next](@next)
