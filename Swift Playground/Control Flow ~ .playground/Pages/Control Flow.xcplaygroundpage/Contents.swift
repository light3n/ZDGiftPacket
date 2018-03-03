import UIKit
import CoreImage

/** 1. for-in 循环语句 */

// 半开区间运算符
let minutes = 60
for tickMark in 0..<minutes {
    // 每1秒钟呈现一个刻度线(60次)
}
// stride(from:to:by:) 函数跳过不需要的标记  to -> 半开区间
let minuteInterval = 5
for tickMark in stride(from: 0, to: minutes, by: minuteInterval) {
    // 每5秒钟呈现一个刻度线(0, 5, 10, 15 ... 45, 50, 55) 
    print("tick = \(tickMark)")
}
// stride(from:through:by:) 函数跳过不需要的标记  through -> 闭区间
let hours = 12
let hourInterval = 3
for hourMark in stride(from: 3, through: hours, by: hourInterval) {
    print("hour = \(hourMark)")
}

// 复合匹配
let someCharacter: Character = "z"
switch someCharacter {
case "a", "z":
    print("I got ya!")
default:
    print("I can't find it")
}

// 区间
let testNumber = 54
switch testNumber {
case 0:
    print("0")
case 0..<50:
    print("0-50")
case 50..<100:
    print("50-100")
default:
    print("many")
}

// 元组
let somePoint = (1, 1)
switch somePoint {
case (0, 0):
    print("It is at the origin")
case (_, 0):
    print("It is at the y-axis")
case (0, _):
    print("It is at the x-axis")
case (-2...2, -2...2):
    print("It is inside the box")
default:
    print("It is outside the box")
}

// 值绑定
let anthorPoint = (5, 0)
switch anthorPoint {
case let (x, 0):
    print("point.x = \(x) is at the y-axis")
case let (0, y):
    print("point.y = \(y) is at the x-axis")
case let (x, y):
    print("point.x = \(x), point.y = \(y)")
}

// where
let yetAnthorPoint = (2, 4)
switch yetAnthorPoint {
case let (x, y) where x == y:
    print("x = y")
case let (x, y) where x == -y:
    print("x = -y")
case let (x, y):
    print("point is some arbitrary point")
}

// fallthrough
let integerToDescribe = 5
var stringToAppend = "this number is"
switch integerToDescribe {
case 2, 3, 5, 7, 9:
    stringToAppend += " \(integerToDescribe) and"
    fallthrough
default:
    stringToAppend += "no more"
}
print(stringToAppend)

// 标签
happyTime: for i in 1...5 {
    print(i)
    if i == 3 {
        print("happyTime end when number is 3")
        break happyTime
    }
}

// guard

func test() {
    let personInfo = ["name" : "Joey", "age" : "25"]
    guard personInfo["name"] != nil else {
        print("no name")
        return
    }
    print("this is not a empty string")
}

test()

func greet(person: [String: String]) {
    guard let name = person["name"] else {
        return
    }
    print("Hello \(name)")
    guard let location = person["location"] else {
        print("I hope the weather is nice near you.")
        return
    }
    print("I hope the weather is nice in \(location).")
}

greet(person: ["name": "Joey"])

let vegetable = "red pepper"
switch vegetable {
case "celery":
    print("Add some raisins and make ants on a log.")
case "cucumber", "watercress":
    print("That would make a good tea sandwich.")
case let x where x.hasSuffix("pepper"):
    print("Is it a spicy \(x)?")
default:
    print("Everything tastes good in soup.")
}

let interestingNumbers = [
    "Prime": [2, 3, 5, 7, 11, 13],
    "Fibonacci": [1, 1, 2, 3, 5, 8],
    "Square": [1, 4, 9, 16, 25],
]
var largest = 0
var largestNumberKind: String?
for (kind, numbers) in interestingNumbers {
    for number in numbers {
        if number > largest {
            largest = number
            largestNumberKind = kind
        }
    }
}
print(largest, largestNumberKind!)












