//: [Previous](@previous)

import Foundation

//函数表达式 
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
func backward(_ a: String, _ b: String) -> Bool {
    return a > b
}
var reversedNames = names.sorted(by: backward)
print(reversedNames)

// MARK: - 闭包表达式语法
//{ (parameters) -> returnType in
//    statements
//}
reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in //@note in 关键字表示闭包的参数与返回值定义已经结束 闭包函数体即将开始
    return s1 > s2
})

//根据上下文推断类型
reversedNames = names.sorted(by: { s1, s2 in return s1 > s2 })

//单行表达式闭包隐式返回 可以通过隐藏return来隐式返回单行表达式的结果
reversedNames = names.sorted(by: { s1, s2 in s1 > s2 })

//参数名称缩写 如果使用参数名称缩写，就可以省略参数列表，in 关键字也可以省略，此时闭包完全由函数体组成
reversedNames = names.sorted(by: { $0 > $1 } )

//运算符方法
reversedNames = names.sorted(by: >)


//尾随闭包：将一个闭包表达式作为函数最后一个参数时，可以使用尾随闭包增加可读性，尾随闭包写在函数括号之后
func someFunctionThatTakeAClosure(closure: () -> Void) {
    //函数体部分
}
//不使用尾随闭包进行函数调用
someFunctionThatTakeAClosure(closure: {
    //闭包主体部分
})
//使用尾随闭包
someFunctionThatTakeAClosure() {
    //闭包主体部分
}

reversedNames = names.sorted() { $0 > $1 }
reversedNames = names.sorted { $0 > $1 }

//使用尾随闭包调用Array.map()
let digitNames = [
    0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
    5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
]
let numbers = [16, 58, 510]

let Strings = numbers.map { (number) -> String in
    var number = number
    var output = ""
    repeat {
        output = digitNames[number % 10]! + output
        number /= 10
    } while number > 0
    return output
}
print(Strings)


// MARK: - 值捕获
// 闭包可以在其被定义的上下文中捕获常量或者变量，并且就算常量变量的原作用域已不存在，闭包仍然可以在函数体内引用这些值
func makeIncrementer(forIncrement amout: Int) -> () -> Int {
    var runningTotal = 0
    func increment() -> Int {
        runningTotal += amout
        return runningTotal
    }
    return increment
}
//捕获引用保证了 runningTotal 和 amout 在调用完makeIncrementer函数后不会消失
let incrementByTen = makeIncrementer(forIncrement: 10)
incrementByTen() // 10
incrementByTen() // 20 值捕获
incrementByTen() // 30
//创建另一个函数 它会有自己的引用 指向一个全新、独立的runningTotal变量 
//@tips 一个函数相当于一个房间 创建函数引用=打开一个房间门 不同函数（房间）内有属于自己的数值
let incrementBySeven = makeIncrementer(forIncrement: 7)
incrementBySeven() // 7
incrementBySeven() // 14 值捕获
incrementBySeven() // 21
//
incrementByTen() //40 与seven 互不相干
//循环引用：类实例持有block——block引用类实例的其他属性 

//闭包是引用类型：把闭包赋值给常量或者变量 是把闭包的引用设置成了常量、变量 闭包本身不影响

// MARK: - 逃逸闭包
var completionHandles: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandle: @escaping () -> Void) {
    completionHandles.append(completionHandle)
}

func someFunctionWithNonescapingClosure(closure: () -> Void) { //非逃逸闭包
    closure()
}

class SomeClass {
    var x = 10
    func doSometing() {
        someFunctionWithEscapingClosure {
            self.x = 100 //标记为@escaping的闭包，必须在闭包中显示引用self
        }
        someFunctionWithNonescapingClosure {
            x = 200
        }
    }
}

let instance = SomeClass()
instance.doSometing() // 200
print(instance.x)

completionHandles.first?() // 100
print(instance.x)

// MARK: - 自动闭包
var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
func serve(customer customerProvider: () -> String) {
    print("now serve \(customerProvider())")
}

// 显式闭包
let customerProvider = { customersInLine.remove(at: 0) }
print(customersInLine.count) // 定义在 customerProvider 中的表达式并未执行
serve(customer: customerProvider)
print(customersInLine.count)

// 自动闭包：参数定义前加上 @autoclosure 关键字，省略花括号，会自动返回 包装在其中的 表达式的值
func serveFuncWithAutoclosure(customer customerProvider: @autoclosure () -> String) {
    print("now serve \(customerProvider())")
}
serveFuncWithAutoclosure(customer: customersInLine.remove(at: 0))





//: [Next](@next)
