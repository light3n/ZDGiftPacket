//: [Previous](@previous)

import Foundation

// MARK: - 声明
class SomeClass {
    // property and function...
    var name: String!
    var height: Float!
    var weight: Float!
}

struct SomeStruct {
    // property and function...
    var width = 0
    var height = 0
}

// MARK: - 属性访问
let person = SomeClass()
person.name = "Joey"
print(person.name)

// 结构体自动生成的 成员逐一构造器，用于初始化新结构体实例中成员的属性
let quad = SomeStruct(width: 100, height: 80)
print(quad.width)

// MARK: - 结构体和枚举是值类型 
// 值类型被赋予给一个变量、常量或者被传递给一个函数的时候，其值会被拷贝。
var anotherQuad = quad // 值拷贝 antherQuad 和 quad 是完全独立的两个常量
anotherQuad.width = 200
print("anotherQuad = \(anotherQuad)")
print("quad = \(quad)")

// 枚举
enum CompassPoint {
    case North, South, East, West
}
var currentDirection = CompassPoint.West
var rememberedDirection = currentDirection // 值拷贝 完全独立的两个值
currentDirection = .East // 新值
if rememberedDirection == .West {
    print("rememberedDirection is still west!")
}

// MARK: - 类是引用类型 & 恒等运算符
// @note “等价于”表示两个类类型的常量或者变量引用同一个类实例
//       “等于”表示两个实例的值“相同”或“相等”
let anotherPerson = person
if person === anotherPerson {
    print("person and anotherPerson is the same SomeClass instance.")
}




//: [Next](@next)
