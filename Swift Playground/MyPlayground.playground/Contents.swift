//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

/** <1> 字符串插值 */
print("This is my first Swift String \(str)")

/** <2> Swift 中不需要专门制定整数类型的长度，Swift中提供了一个特殊的整数类型Int 根据当前系统自动判断其长度：32Bit -> Int32 64Bit -> Int64 */
print(UInt.max)

/** <3> 类型安全 类型推断 */
//var a = 3
//a = 3.3 报错 -> 不能改变变量类型

let aInt = 3 // Int类型
let aDouble = 3.1415 // Double类型 Swift 中总是会选择 Double 而不是 Float

/** <4> 数值型字面量 */
let decimalInteger = 17
let binaryInteger = 0b10001 // 二进制的17
let octalInteger = 0o21 // 八进制的17
let hexadecimalInteger = 0x11 // 十六进制的17

let a = 1.25e2 // 1.25*10^2
let b = 1.25e-2 // 1.25*10^-2

//let cannotbenegative: UInt8 = -1
//let toobig: UInt8 = UInt8.max + 1

/** <5> 整数转换 */
var twothousand: UInt16 = 2_000
let one: UInt8 = 1
let twothousandAndone = twothousand + UInt16(one) //将one转换为UInt16类型
// SomeType(anInitialValue) 是调用 Swift 构造器并传入一个初始值的默认方法

/** <6> 类型别名 type aliases
 typealias <#type name#> = <#type expression#>
 相当于 Objective-C 中的 typedef <#type name#> <#type expression#>
 OC: typedef long dispatch_once_t  声明一个类型别名dispatch_once_t 为长整形 long
 Swift: typealias dispatch_once_t = long
 */
typealias MyInt = UInt16
let myInt: MyInt = MyInt.min

/** <7> 元组 */
// 1. 声明
let http404error = (404, "Not Found") // 声明了一个 (Int, String) 类型的元组
let value = UIImage.init(named: "image.jpeg")
let imageInfo = ("name", value) // 声明了一个 (String, UIImage) 类型的元组

// 2. 内容分解
let (statusCode, statusMessage) = http404error
print("http status code is \(statusCode)")
//      _ 忽略值
let (_, onlyImage) = imageInfo
print("this is a image \(String(describing: onlyImage))")
//      通过下标来访问元组中的某个元素
print("http status message is \(http404error.1)")
//      给单个元素命名
let imageInfo2 = (imageName: "name", imageValue: value)
//      通过元素名来访问元素
print("this image name is \(imageInfo2.imageName)")

/** <8> 可选类型 */
let possibleNumber = "123"
let convertedNumber = Int(possibleNumber) // String -> Int 
let HelloWorld = "Hello, World!"
// StrConvertToInt 被推断为 Int? 类型（或者是 optional Int类型， 即可选类型）
// StrConvertToInt 的值要么是 Int 类型 要么是 nil 不能为其他值：Bool String
let StrConvertToInt = Int(HelloWorld) // String -> Int
//StrConvertToInt = "string"

/** <9> nil */
var notNilString = "String"
//notNilString = nil  //Crash: 非可选类型不能设置为 nil 否则crash
var couldBeNilString: String? = "String"
couldBeNilString = nil  //不会报错

/** <10> if 语句和强制解析 */
if convertedNumber != nil {
    print("convertedNumber contains some integer value.")
}
// 强制解析：表明确定该可选有值，请使用它！
if convertedNumber != nil {
    print("convertedNumber has an integer value of \(convertedNumber!).")
}

/** <11> 可选绑定 
 在判断一个常、变量是否有值的同时 将其值赋值给另一个常、变量
 Sample Code:
 if let constantName = someOptionl {
    statement
 }
*/
if let actualNumber = Int(possibleNumber) {
    print("\'\(possibleNumber)\' has an integer value of \(actualNumber)") //actualNumber已被初始化 无需使用 ! 进行强制解析
} else {
    print("\'\(possibleNumber)\' could not convert to an integer!")
}

/** 多个可选绑定或者多个布尔条件处于一个if语句中，只要有一个值为nil 或者一个布尔条件为false，则整个条件判断为false */
// 1. 多个可选绑定 用“逗号”隔开
if let firstNumber = Int("4"), let secondNumber = Int("20"), firstNumber < secondNumber && secondNumber < 100 {
    print("\(firstNumber) < \(secondNumber) < 100")
}
// 2. 多层嵌套
if let firstNumber = Int("4") {
    if let secondNumber = Int("20") {
        if firstNumber < secondNumber && secondNumber < 100 {
            print("\(firstNumber) < \(secondNumber) < 100")
        }
    }
}

/** <12> 隐式解析可选类型 */
let possibleString: String? = "An optional string"
let forcedString: String = possibleString! // 需要感叹号来取值

var assumedString: String! = "An implicitly unwrapped optional string."
let implicitlString: String = assumedString // 不需要感叹号来取值

/** <13> 错误处理 */
// 一个函数可以通过在声明中添加 throws 关键词来抛出错误
func canThrowAnError() throws {
    // 这个函数有可能抛出错误
}

// 一个 do 语句创建了一个新的包含作用域，使得错误能被传播到一个或者多个 catch 从句
do {
    try canThrowAnError()
    // 没有抛出错误
} catch {
    // 抛出错误
}

//-------------
// Sample Code
//-------------
func makeASandwich() throws {
    // make a sandwich...
}

func eatASandwich() {
    // eat a sandwich...
}

do {
    try makeASandwich()
    // 没有错误
    eatASandwich()
} //catch SandwichError.outOfCleanDishes {  //没有干净的盘子错误
//
//} catch SandwichError.missingIngredients(let ingredients) { //原料丢失错误
//    buyGroceries(ingredients)
//}

/** 断言 使用断言进行调试 */
let age = -3
//assert(age >= 0, "A person's age cannot be less than zero") //条件为false时，断言触发，调试信息显示
//assert(age >= 0) //不需要调试信息










