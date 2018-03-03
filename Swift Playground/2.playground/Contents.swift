//: Playground - noun: a place where people can play

import UIKit

//-------------
// 运算符
//-------------

/** <1> 空合运算符 */
let a: Int? = 1
let b = 2
let c = a ?? b //空合运算符 ?? 等同于 “a != nil ? a! : b” -> 如果a有值则返回a自身 否则返回b （@warning a必须为可选类型）

let defaultColorName = "red"
var userDefinedColorName: String?
var colorNameToUse = userDefinedColorName ?? defaultColorName //userDefinedColorName 为 nil

/** <2> 区间运算符 */
// 1. 闭区间运算符 a...b 从a到b（包括a、b） (@warning a必须小于b)
for index in 1...5 {
    print("\(index) * 5 = \(index * 5)")
}
// 2. 半开区间运算符 a..<b 从a到b（包括a，但不包括b） (@warning a必须小于b)
let names = ["Amy", "Joey", "Mike", "Lily"]
for index in 0..<names.count {
    print("第\(index + 1)个人的名字叫做\(names[index])")
}


//-------------
// 字符串
//-------------


/** <3> 字符串可变性 */
var variableString = "Horse"
variableString = variableString + " and carriage"
variableString += " and carriage" //类似数学运算

let aStringArray: [String] //声明一个元素值只能为String的数组
let catCharacters: [Character] = ["C", "a", "t", "!", "🐱"]
let catString = String(catCharacters) //Character -> String

var appendString = "hello"
appendString.append(" world!")
print("appendString has \(appendString.characters.count) characters")
// 下标获取字符串中的Character
let greeting = "Guten Tag!"
greeting[greeting.startIndex]
greeting[greeting.index(before: greeting.endIndex)]
greeting[greeting.index(after: greeting.startIndex)]
let index = greeting.index(greeting.startIndex, offsetBy: 7)
greeting[index]
// 索引越界
//greeting[greeting.endIndex]
//greeting.index(after: greeting.endIndex)

/** <4> 字符串插入 */
var welcome = "hello"
// 拼接一个字符
welcome.insert("!", at: welcome.endIndex)
// 拼接一个字符串
welcome.insert(contentsOf: " there!".characters, at: welcome.index(before: welcome.endIndex))
print(welcome)
// 删除range内的字符串
let range = welcome.index(welcome.endIndex, offsetBy: -7) ..< welcome.endIndex
welcome.removeSubrange(range)
print(welcome)

/** <5> 字符串的Unicode表示形式 */
let dogString = "Dog!!🐶"
for codeUnit in dogString.utf8 {
    print("\(codeUnit)", terminator:" ")
}


//-------------
// 集合类型
//-------------

/** 数组 Array */
var someInts = [Int]() // 创建了一个空的数组 元素类型为 Int
//someInts.append("String") // 报错 因为 someInts 数组初始化时指定了元素类型
someInts = [] // someInts 现在是一个空数组 
//someInts.append("String") // 但是因为上下文中有指定过元素类型 所以就算置空了 元素类型也不会变

var threeDoubles = Array(repeatElement(0.0, count: 3)) // 创建一个带有默认值的数组 [0.0, 0.0, 0.0]
threeDoubles.append(contentsOf: [1.0, 2.0])
print(threeDoubles)
//threeDoubles.removeAll(keepingCapacity: true)
print(threeDoubles.count)
let antherThreeDoubles = Array(repeatElement(2.5, count: 3))
var sixDoubles = threeDoubles + antherThreeDoubles

/// 用数组字面量构造数组
var shoppingList: [String] = ["Eggs", "Milk"]
var shortShoppingList = ["Eggs", "Milk"]
shoppingList.append("pork")
shoppingList += ["water"]
// 通过下标修改值
shoppingList[0] = "potato"
shoppingList[1...2] = ["watermelom"] // 改变一系列的值 即使新数据跟原有数据的数量不一致 也能生效
print(shoppingList)
// 删除
let lastElement = shoppingList.removeLast() // removeLast() 方法会返回最后一个被删除的元素
print(lastElement)
// 遍历 -> enumerated()方法会返回一个由数据项索引值和数据值组成的元组 (index, value)
for (index, value) in shoppingList.enumerated() {
    print("Item \(index): \(value)")
}

/** 集合 Set */
var letters = Set<Character>() // Set 没有等价的简化形式，例如数组可以简化为 [Element]
var favoriteGenres: Set<String> = ["Rock", "Hip Hop", "Classical"] // Swift 中 Set 类型不能从数组字面量中单独推断出来，所以 Set 必须显式声明
var animals: Set = ["Cat", "Dog", "Mouse"] // 如果用数组字面量构造一个 Set 并且字面量内的所有元素类型都一致，就可以省略 Set 的元素声明
// sorted() 方法可以有序遍历 Set
for item in animals.sorted() {
    print("\(item)", terminator:" ")
}
// 操作
let setA: Set = [1, 2, 3, 4, 5]
let setB: Set = [4, 5, 6, 7, 8]
// @note 以下方法都会返回一个操作后的 Set Like: let newSet = setA.union(setB)
// 使用intersection(_:)方法根据两个集合中都包含的值创建的一个新的集合。
setA.intersection(setB).sorted()
// 使用union(_:)方法根据两个集合的值创建一个新的集合。
setA.union(setB).sorted()
// 使用symmetricDifference(_:)方法根据在一个集合中但不在两个集合中的值创建一个新的集合。
setA.symmetricDifference(setB).sorted()
// 使用subtracting(_:)方法根据不在该集合中的值创建一个新的集合。
setA.subtracting(setB).sorted()
/// 集合成员关系和相等
let set1: Set = [1, 2, 3]
let set2: Set = [1, 2]
let set3: Set = [4, 5, 6]
// 1. 是否为父集
set1.isSuperset(of: set2)
// 2. 是否没有相同的元素
set1.isDisjoint(with: set3)

/** 字典 Dictionary */
var namesOfIntegers = [Int : String]() // 简化形式 [:]
namesOfIntegers[16] = "sixteen"
namesOfIntegers = [:]
// 字典字面量创建字典
var airports: [String : String] = ["YYZ" : "Toronto Person", "DUB" : "Dublin"]
// var airports = ["YYZ" : "Toronto Person", "DUB" : "Dublin"] // 根据类型推断进行简化
airports["LHR"] = "London" // 添加了一个键值对 相当于OC中的[NSMutableDictionary setObject:object toKey:key]
airports["LHR"] = "Beijing" // 修改值
// 更新值 updateValue(_:forKey:) -> oldValue 
// @note 返回的 oldValue 是一个可选类型（如：String? ），因为请求的键有可能没有对应的值存在（即：nil），则 oldValue 为nil
if let oldValue = airports.updateValue("Guangzhou", forKey: "LHR") {
    print("the old value is \(oldValue)")
}
// 下标语法访问的值也是可选类型
let value = airports["LHR"]
// 删除键值对会返回被删除的值 同样 值为可选类型
let valueToDelete = airports.removeValue(forKey: "LHR")
/// 遍历 每个字典的数据项都以元组类型返回（跟 Array 一样）
for (airportCode, airportName) in airports {
    print("\(airportCode) : \(airportName)")
}
// 单独遍历键、值
for airportCode in airports.keys {
    print("airportCode: \(airportCode)")
}
for airportName in airports.values {
    print("airportCode: \(airportName)")
}
/// 将键、值转换成数组 @note 因为 Swift 中字典类型是无序集合类型，如果要特定键值对的顺序，可以调用 keys、values 的 sorted() 方法
let airportCodes = [String](airports.keys.sorted())
let airportNames = [String](airports.values.sorted())







