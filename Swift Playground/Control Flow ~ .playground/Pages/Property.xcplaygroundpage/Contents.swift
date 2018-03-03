//: [Previous](@previous)

import Foundation

struct Point {
    var x = 0.0, y = 0.0
}

struct Size {
    var width = 0.0, height = 0.0
}

struct Rect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
//        set(newCenter) {
//            origin.x = newCenter.x - (size.width / 2)
//            origin.y = newCenter.y - (size.height / 2)
//        }
        // 简化声明：默认提供一个 newValue 参数作为新值
        set {
            origin.x = newValue.x - (size.width / 2)
            origin.y = newValue.y - (size.height / 2)
        }
    }
}

var square = Rect(origin: Point(x: 0.0, y: 0.0),
                  size: Size(width: 10.0, height: 10.0))
let initialSquareCenter = square.center
square.center = Point(x: 15.0, y: 15.0)
print("square.center is now at (\(square.origin.x), \(square.origin.y))")

// MARK: - 只读计算属性
// @note 必须使用 var 声明计算属性，因为计算属性的值是不确定的，如果声明成 let，之后就不能修改
struct Cuboid {
    var width = 0.0, height = 0.0, depth = 0.0
    var volume: Double { // 省略 get 关键字和花括号{}
        return width * height * depth
    }
}
let fourByFiveByTwo = Cuboid(width: 4.0, height: 5.0, depth: 2.0)
print("the volume of fourByFiveByTwo is \(fourByFiveByTwo.volume)")
//fourByFiveByTwo.width = 6.0 //会报错，无法修改常量结构体实例的任何属性，必须为 var

// MARK: - 属性观察器
class StepCounter {
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) { //可省略，会自动提供 newValue 参数，新值为常量参数
            print("About to set totalSteps to \(newTotalSteps)")
        }
        didSet { // 自动生成 oldValue 常量参数
            print("Added \(totalSteps - oldValue) steps")
        }
    }
}
let stepCounter = StepCounter()
stepCounter.totalSteps = 200
// About to set totalSteps to 200
// Added 200 steps
stepCounter.totalSteps = 360
// About to set totalSteps to 360
// Added 160 steps

// MARK: - 类型属性
// @note 存储型属性必须设置默认值
// 使用 static 关键字来定义类型属性
// 在为类定义计算型类型属性时，可以改用 class 关键字定义类型属性，来支持子类对 父类的实现 进行重写、
struct SomeStructure {
    static var storedTypeProperty = "Some value"
    static var computedTypeProperty: Int {
        return 1
    }
}

enum SomeEnumeration {
    static var storedTypeProperty = "Some value"
    static var computedTypeProperty: Int {
        return 6
    }
}

class SomeClass {
    static var storedTypeProperty = "Some value"
    static var computedTypeProperty: Int {
        return 27
    }
    // 改用 class 进行定义
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
}

// MARK: - 获取和设置类型属性的值
// 通过点语法来进行获取和设置，不过调用者是类型本身，而非类型实例
print(SomeStructure.storedTypeProperty)
// 打印 "Some value."
SomeStructure.storedTypeProperty = "Another value."
print(SomeStructure.storedTypeProperty)
// 打印 "Another value.”
print(SomeEnumeration.computedTypeProperty)
// 打印 "6"
print(SomeClass.computedTypeProperty)
// 打印 "27"


//: [Next](@next)
