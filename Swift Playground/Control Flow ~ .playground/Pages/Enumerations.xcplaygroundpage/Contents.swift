//: [Previous](@previous)

import Foundation

// MARK: - 枚举

// 声明
enum Name {
    case Zhang
    case Huang
    case Peng
    case Liu
}
// MARK: - 原始值
enum FirstName: String {
    case Zhang = "Zhang"
    case Huang = "Huang"
    case Peng = "Peng"
    case Liu = "Liu"
}
// 原始值的隐式赋值
enum Planet: Int {
    // 当用整数作为原始值时，隐式赋值的值一次递增 1
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}
enum Direction: String {
    // 当用字符串作为原始值时，每个枚举成员的隐式原始值为该枚举成员的名称
    case left, right, up, down
}
// 使用枚举成员的 rawValue 属性可以访问枚举成员的原始值
let direction = Direction.left.rawValue
print("Direction is \(direction)")


// MARK: - 取值
var name = Name.Zhang
name = .Huang // 一旦变量被声明为枚举类型 Name，就可以用一个简短的点语法为其设置新的 Name 类型的值

// switch 语句必须涵盖所有枚举类型
switch name {
    case .Zhang:
        print("His name is Zhang!")
    default:
        print("His name is not Zhang!")
}

// MARK: - 关联值
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}

var productBarcode = Barcode.upc(8, 85909, 51226, 3)
productBarcode = .qrCode("ABCDEFGHIJKLMNOP")

// 关联值可以被提取出来作为 switch 语句的一部分
switch productBarcode {
case .upc(let numberSystem, let manufacturer, let product, let check):
//case let .upc(numberSystem, manufacturer, product, check): // 简短写法：在成员名称前标注 let/var
    print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
case .qrCode(let productCode):
//case let .qrCode(productCode):
    print("QR code: \(productCode).")
}

// MARK: - 使用原始值初始化枚举实例
// 如果定义枚举类型的时候使用了原始值，那么将会自动获得一个初始化方法，这个方法
// 接收一个 rawValue 参数，参数类型为原始值类型，返回值为枚举成员 或 nil
let possiblePlanet = Planet(rawValue: 7) // possiblePlanet 的类型为 Planet?，值为 Planet.uranus
let matchingNameLiu = FirstName(rawValue: "Liu") // 创建了一个原始值为 Liu 的 FirstName 类型的枚举实例

// @note 不是所有的值都能找到对应的枚举实例，所以原始值构造器总是返回一个可选的枚举成员
let possibleToFind = 11
if let possiblePlanet = Planet(rawValue: possibleToFind) {
    switch possiblePlanet {
    case .earth:
        print("Found a planet which has most harmless!")
    default:
        print("Not a safe place for humans!")
    }
} else {
    print("There isn't a planet at position \(possibleToFind)")
}

// MARK: - 递归枚举
// ① 在枚举成员前添加 indirect 表示该成员可以递归
enum ArithmeticExpression {
    case number(Int)
    indirect case addition(ArithmeticExpression, ArithmeticExpression)
    indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
}
// ② 也可以在枚举类型前面添加 indirect 表示该枚举类型所有成员都可以递归
indirect enum ArithmeticExpression1 {
    case number(Int)
    case addition(ArithmeticExpression, ArithmeticExpression)
    case multiplication(ArithmeticExpression, ArithmeticExpression)
}

// 1. 创建表达式
let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2)) // @tips 有点类似嵌套函数？

// 2. 操作表达式进行计算
func evaluate(_ expression: ArithmeticExpression) -> Int {
    switch expression {
    case let .number(value):
        return value
    case let .addition(left, right):
        return evaluate(left) + evaluate(right)
    case let .multiplication(left, right):
        return evaluate(left) * evaluate(right)
    }
}

print(evaluate(product))


//: [Next](@next)
