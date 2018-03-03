//: [Previous](@previous)

import Foundation

// MARK: - 扩展
// 扩展：就是为一个已有的类、结构体、枚举或者协议类型添加新功能
//      这包括在没有权限获取原始源代码的情况下扩展类型的能力（即：逆向建模）

// MARK: - 计算型属性
// 扩展可以为已有类型添加 计算型实例属性 和 计算型类型属性
extension Double {
    var m: Double { return self }
    var km: Double { return self * 1_000 }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}

let oneInch = 25.4.mm
print("One inch is \(oneInch) meters")
// 打印 “One inch is 0.0254 meters”
let threeFeet = 3.ft
print("Three feet is \(threeFeet) meters")
// 打印 “Three feet is 0.914399970739201 meters”

// MARK: - 构造器
// 扩展可以为已有类型添加新的 构造器
// 可以添加新的便利构造器，但是不能添加 指定构造器、析构器
// 指定构造器、析构器必须由原始类实现来提供

struct Size {
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
}
// 因为 Rect 没有提供制定的构造器，所以它会获得一个 逐一成员构造器
let memberwiseRect = Rect(origin: Point(x: 2.0, y: 2.0), size: Size(width: 5.0, height: 5.0))
// 又因为 Rect 的成员属性都提供了默认值，所以它会获得一个 默认构造器
let defaultRect = Rect()

// extension提供额外构造器
extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - size.width / 2
        let originY = center.y - size.height / 2
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}

let centerRect = Rect(center: Point(x: 4.0, y: 4.0),
                      size: Size(width: 3.0, height: 3.0))
// centerRect 的原点是 (2.5, 2.5)，大小是 (3.0, 3.0)


// MARK: - 方法
// 扩展可以为已有类型添加新的 方法
extension Int {
    func repetitions(task: () -> Void) {
        for _ in 0 ..< self {
            task()
        }
    }
}

3.repetitions {
    print("Hello!")
}

// @note 结构体和枚举类型中修改 self 或其属性的方法必须将该实例方法标注为 mutating
// 正如来自原始实现的可变方法一样
extension Int {
    mutating func square() {
        self = self * self
    }
}

var someInt = 3
someInt.square() // 9


// MARK: - 嵌套类型
// 扩展可以为已有类型添加新的 嵌套类型
extension Int {
    enum Kind {
        case Negative, Zero, Positive
    }
    var kind: Kind {
        switch self {
        case 0:
            return .Zero
        case let x where x < 0:
            return .Negative
        default:
            return .Positive
        }
    }
}

func printIntegerKinds(_ numbers: [Int]) {
    for number in numbers {
        switch number.kind {
        case .Negative:
            print("- ", terminator: "")
        case .Zero:
            print("0 ", terminator: "")
        default:
            print("+ ", terminator: "")
        }
    }
}

printIntegerKinds([3, 19, -27, 0, -6, 0, 7])


//: [Next](@next)
