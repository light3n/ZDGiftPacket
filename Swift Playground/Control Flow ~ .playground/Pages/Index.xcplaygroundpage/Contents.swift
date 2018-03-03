//: [Previous](@previous)

import Foundation

// MARK: - 下标
// @note 类似于 Array[index] / Dictionary[key]

// MARK: - 下标语法
struct TimesTable {
    let multiplier: Int
//    subscript(index: Int) -> Int {
//        get {
//            return multiplier * index
//        }
//        set {
//            
//        }
//    }
    // 只读属性可省略 get 关键字和花括号{}，与属性一样
    subscript(index: Int) -> Int {
        return multiplier * index
    }
}
let threeTimesTable = TimesTable(multiplier: 3)
print("six times three is \(threeTimesTable[6])")
// 打印 "six times three is 18"

// MARK: - 下标选项
// 一个类或结构体可以根据自身需要提供多个下标实现，使用下标时将通过入参的数量和类型进行区分
// 自动匹配合适的下标，这就是下标的重载
struct Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        self.grid = Array(repeating: 0.0, count: rows * columns)
    }
    func indexIsValidForRow(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValidForRow(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValidForRow(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}
// 创建了一个 2*2 的矩阵
var matrix = Matrix(rows: 2, columns: 2)
// 为矩阵赋值
matrix[0, 1] = 1.5
matrix[1, 0] = 3.2
//let someValue = matrix[3, 3] // 触发断言，下标超出矩阵范围

//: [Next](@next)
