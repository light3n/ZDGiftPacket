//: [Previous](@previous)

import Foundation

// MARK: - 泛型函数

// 尖括号 <> 告诉 Swift 字符 T 是函数的占位类型名
// Swift 不会去查找名为 T 的实际类型
// 要求是 a b 两个值有相同的类型
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temp = a
    a = b
    b = temp
}

var someInt = 3
var anotherInt = 107
swapTwoValues(&someInt, &anotherInt)
// someInt 现在 107, and anotherInt 现在 3


// MARK: - 类型参数
// 如上面的 <T>，大多数情况下，类型参数具有一个描述性名字，
// 如：Dictionary<Key, Value> Array<Element>
// 如果没有有意义的关系时，用单个字母表示 <T> <U>


// MARK: - 泛型参数
// 手动实现的一个栈
struct IntStack {
    var items = [Int]()
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
}

// 泛型版本
// <Element>为待提供的类型定义了一个占位名
struct Stack<Element> {
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
}

// 创建并初始化一个实例：在尖括号中写明类型
var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")
stackOfStrings.push("cuatro")

let fromTheTop = stackOfStrings.pop()
// fromTheTop 的值为 "cuatro"，现在栈中还有 3 个字符串

// 扩展协议类型
extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

if let topItem = stackOfStrings.topItem {
    print("The top item on the stack is \(topItem).")
}

// MARK: - 类型约束语法
// 定义类型约束：在泛型类型后面接上类型名、约束名，并用冒号分隔开（类似普通常量变量的声明 var a: String）
/*
func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U) {
 
}
 */

// MARK: - 类型约束事件
func findIndex(ofString valueToFind: String, in array: [String]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

let strings = ["cat", "dog", "llama", "parakeet", "terrapin"]
if let foundIndex = findIndex(ofString: "llama", in: strings) {
    print("The index of llama is \(foundIndex)")
}
// 打印 “The index of llama is 2”

// 泛型写法
func findIndex1<T: Equatable>(of valueToFind: T, in array: [T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

let doubleIndex = findIndex1(of: 9.3, in: [3.14159, 0.1, 0.25])
// doubleIndex 类型为 Int?，其值为 nil，因为 9.3 不在数组中
let stringIndex = findIndex1(of: "Andrea", in: ["Mike", "Malcolm", "Andrea"])
// stringIndex 类型为 Int?，其值为 2


// MARK: - 关联类型
// 关联类型为协议中的某个类型提供了占位名（别名），其代表的实际类型在协议被采纳时才会被指定
protocol Container {
    associatedtype ItemType
    mutating func append(_ item: ItemType)
    var count: Int { get }
    subscript (i: Int) -> ItemType { get }
}


struct InStack1: Container {
    // 原始实现部分
    var items = [Int]()
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
    
    // Container 协议实现部分
    // 通过起别名的方式 将抽象的关联类型 ItemType 转换为具体的 Int 类型
    // 因为 InStack1 符合 Container 的所有要求，所以可以不用声明 ItemType 为 Int
    // typealias ItemType = Int
    mutating func append(_ item: Int) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Int {
        return items[i]
    }
}

struct Stack1<Element>: Container {
    // 原始实现部分
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    
    // Container 协议实现部分
    mutating func append(_ item: Element) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript (i: Int) -> Element {
        return items[i]
    }
    
}

// MARK: -
extension Array: Container {}

// MARK: - 泛型 where 语句
// 为关联类型定义约束：在参数列表中通过 where 子句为关联类型定义约束

// 检查两个 Container 实例是否包含相同顺序的相同元素
// 被检查的两个 Container 实例可以是不同类型的容器，但必须拥有相同类型的元素
// 这个要求通过一个类型约束 和 where 子句来实现
func allItemsMatch<C1: Container, C2: Container>
    (_ someContainer: C1, _ anotherContainer: C2) -> Bool
    where C1.ItemType == C2.ItemType, C1.ItemType: Equatable {
        // 检查两个实例是否具有相等的数量
        if someContainer.count != anotherContainer.count {
            return false
        }
        for i in 0..<someContainer.count {
            if someContainer[i] != anotherContainer[i] {
                return false
            }
        }
        return true
}
var stackOfStrings1 = Stack1<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")

var arrayOfStrings = ["uno", "dos", "tres"]

if allItemsMatch(stackOfStrings1, arrayOfStrings) {
    print("All items match.")
} else {
    print("Not all items match.")
}
// 打印 “All items match.”


// MARK: - 具有泛型 where 语句的扩展
// 使用泛型 where 子句作为扩展的一部分 
// 扩展了泛型 Stack 结构体，添加一个 isTop(_:) 方法
extension Stack1 where Element: Equatable {
    func isTop(_ item: Element) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}

if stackOfStrings1.isTop("tres") {
    print("Top element is tres.")
} else {
    print("Top element is something else.")
}
// 打印 "Top element is tres."

// 如果不用泛型 where 语句，会有一个问题：
// 在 isTop(_:) 里面使用了 == 运算符，但是 Stack1 的定义没有要求它的元素是符合 Equatable 协议的
// 所以在使用 == 运算符的时候会导致编译错误
// 使用泛型 where 语句可以为扩展添加条件，因此只有当栈中的元素符合 Equatable 协议时，扩展才会添加 isTop(_:) 方法

struct NotEquatable { }
var notEquatableStack = Stack1<NotEquatable> ()
var notEquatableValue = NotEquatable()
notEquatableStack.push(notEquatableValue)
//notEquatableStack.isTop(notEquatableValue) // 报错


// 可以用 where 子句去扩展一个协议
extension Container where ItemType: Equatable {
    func startWith(_ item: ItemType) -> Bool {
        return count >= 1 && self[0] == item
    }
}

if [9, 9, 9].startWith(42) {
    print("Starts with 42.")
} else {
    print("Starts with something else.")
}
// 打印 "Starts with something else."

// 泛型 where 子句去要求 Item 为特定类型
extension Container where ItemType == Double {
    func average() -> Double {
        var sum = 0.0
        for i in 0..<count {
            sum += self[i]
        }
        return sum / Double(count)
    }
}
print([1260.0, 1200.0, 98.6, 37.0].average())
//print(["a", "b", "c"].average()) //报错
// 打印 "648.9"


// MARK: - 具有泛型 where 子句的关联类型
protocol anotherContainer {
    associatedtype Item
    mutating func push(_ item: Item)
    var count: Int { get }
    subscript (i: Int) -> Item { get }
    
    // 迭代器（Iterator）的泛型where子句要求：无论迭代器是什么类型，迭代器中的元素类型，
    // 必须和容器内元素的类型相同
//    associatedtype Iterator: IteratorProtocol where Iterator.Element == Item // ??
//    func makeIterator() -> Iterator
}


//protocol ComparableContainer: Container where Item: Comparable { }


// MARK: - 泛型下标
//extension Container {
//    subscript<Indices: Sequence>(indices: Indices) -> [ItemType] where Indices.Iterator.Element == Int {
//        var result = [ItemType]()
//        for index in indices {
//            result.append(self[index])
//        }
//        return result
//    }
//}




//: [Next](@next)
