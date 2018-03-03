//: Playground - noun: a place where people can play

import UIKit

/// Error Handling

enum VendingMachineError: Error {
    case invalidSelection                    //选择无效
    case insufficientFunds(coinsNeeded: Int) //金额不足
    case outOfStock                          //缺货
}

struct Item {
    var price: Int
    var count: Int
}

class VendingMachine {
    //库存
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11)
    ]
    //余额
    var coinDeposited = 0
    
    func despenseSnack(snack: String) {
        print("Dispensing \(snack)")
    }
    
    func vend(itemName name: String) throws {
        guard let item = inventory[name] else {
            throw VendingMachineError.invalidSelection
        }
        
        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }
        
        guard item.price <= coinDeposited else {
            throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinDeposited)
        }
        
        coinDeposited -= item.price
        
        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem
        
        print("Dispensing \(name)")
    }
}

///
let favoriteSnacks = [
    "Alice": "Chips",
    "Bob": "Licorice",
    "Eve": "Pretzels"
]

func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    //因为 vendingMachine.vend() 方法会抛出错误，所以在前面添加 try 关键字
    try vendingMachine.vend(itemName: snackName)
}

/// 构造器
// throwing 构造器也能像 throwing 函数一样传递错误
struct PurchaseSnack {
    let name: String
    init(name: String, vendingMachine: VendingMachine) throws {
        try vendingMachine.vend(itemName: name)
        self.name = name;
    }
}

/// 用 Do-Catch 处理错误
/*
 do {
    try expression
    statements
 } catch pattern 1 {
    statements
 } catch pattern 2 where condition {
    sataements
 }
 */

// catch 后面接入匹配模式，表示可以接受怎么样的错误
// 如果没有指定可以匹配的模式，那么这条句子可以匹配任何错误，并且把错误绑定到一个名为 error 的局部常量
/*
 do {
     try expression
     statements
 } catch error {
     statements
 }
*/

var vendingMachine = VendingMachine()
vendingMachine.coinDeposited = 8
do {
    try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
} catch VendingMachineError.invalidSelection {
    print("Invalid Selection.")
} catch VendingMachineError.outOfStock {
    print("Out of Stock")
} catch VendingMachineError.insufficientFunds(let coinsNeeded) {
    print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
}

/// 将错误转换成可选值
// 可以使用 try? 通过将错误转换成可选值来处理错误
// 如果在评估 try? 表达式时一个错误被抛出，那么表达式的返回值就是 nil

/* example: 如果抛出错误 x,y = nil，否则 x,y = 返回值
 func someThrowingFunction() throws -> Int {
     // statements
 }

 let x = try? someThrowingFunction()
 
 let y: Int?
 do {
    y = try someThrowingFunction()
 } catch {
    y = nil
 }
 */

/*
func fetchData() -> Data? {
    if let data = try fetchDataFromDisk() { return data }
    if let data = try fetchDataFromServer() { return data }
    return nil
}
 */

/// 禁用错误传递
// 如果明确知道某个函数在运行时是不会抛出错误的，可以用 try! 关键字来禁用错误传递
// let photo = try! loadImage(atPath: "./Resources/John Appleseed.jpg")

/// 指定清理工作
// 可以使用 defer 语句在即将离开当前代码块时执行一系列语句
// 无论是以何种方式离开当前代码：错误抛出/return/break
// 用处：确保文件描述符得以关闭，手动分配的内存得以释放
/*
func processFile(fileName: String) throws {
    if exists(fileName) {
        let file = open(fileName)
        defer {
            close(fileName)
        }
        while let line = try file.readLine() {
            // processing file
        }
        // close(fileName) 会在这里被调用，即作用域的最后
    }
}
 */



