//: [Previous](@previous)

import Foundation
import UIKit

//=====
// 函数
//=====

//参数标签默认是参数名称
func greet(person: String, day: String) -> String {
    return "hello \(person), today is \(day)"
}
greet(person: "Joey", day: "Monday")

//忽略参数标签
func greet2(_ person: String, day: String) -> String {
    return "hello \(person), today is \(day)"
}
greet2("Joey", day: "Tuesday")

//指定参数标签
func greet3(person: String, from hometown: String) -> String {
    return "hello \(person) from \(hometown)"
}
greet3(person: "Joey", from: "Guangzhou")

//默认参数值
func someFunction(paramterWithoutDefault: Int, paramterWithDefault: Int = 12) {
    //如果调用函数的时候不传入第二个参数值，第二个参数的值就是12
}
someFunction(paramterWithoutDefault: 3, paramterWithDefault: 4) //第一个参数值3，第二个参数值4
someFunction(paramterWithoutDefault: 3) //第一个参数值3


// 返回元组
func calculateStatistics(scores: [Int]) -> (min: Int, max: Int, sum: Int) {
    var min = scores[0]
    var max = scores[0]
    var sum = 0
    
    for score in scores {
        if score > max {
            max = score
        } else if score < min {
            min = score
        }
        sum += score
    }
    return (min, max, sum)
}

let tunple = calculateStatistics(scores: [1, 2, 3, 4, 5])
print(tunple.0, tunple.max, tunple.sum)


//带有可变个数的参数 这些参数在函数内表现为数组的形式 @note 一个函数最多只有拥有一个可变参数
func sumOf(numbers: Int...) -> Int {
    var sum = 0
    for number in numbers {
        sum += number
    }
    return sum
}

print(sumOf(numbers: 1, 2, 3, 4, 5))

//函数嵌套
func returnFifteen() -> Int {
    var y = 10
    func add() {
        y += 5
    }
    add()
    return y
}
returnFifteen()

//函数作为返回值
func makeIncrementer() -> ((Int) -> Int) {
    func addOne(number: Int) -> Int {
        return 1 + number
    }
    return addOne
}
var incrementFunc = makeIncrementer() //返回的是一个函数
incrementFunc(7)

//函数作为参数
func hasAnyMatches(list: [Int], condition: (Int) -> Bool) -> Bool {
    for item in list {
        if condition(item) {
            return true
        }
    }
    return false
}
func lessThanTen(number: Int) -> Bool {
    return number < 10
}
let result = hasAnyMatches(list: [20, 19, 1, 11], condition: lessThanTen)
print("the final result is \(result)")

// inout 输入输出参数 参数的值在函数内被修改，然后函数结束后，参数值改变。 @note 参数必须为变量 因为常量跟字面量不可更改
func swapTwoInt(_ a: inout Int, _ b: inout Int) {
    let temporary = a
    a = b
    b = temporary
}
var number1 = 10
var number2 = 20
swap(&number1, &number2) //必须加 & 说明这个值可以被参数修改
print(number1, number2)

//使用函数类型
//这个函数类型为 (Int, Int) -> Int
func addTwoInts (a: Int, b: Int) -> (Int) {
    return a + b
}
//定义一个变量 赋值为函数
var mathMethod: (Int, Int) -> Int = addTwoInts
mathMethod(10, 10)










//: [Next](@next)
