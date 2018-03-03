//: [Previous](@previous)

import Foundation

// MARK: - 继承

// 基类：不继承于其他类的类
class Vehicle {
    var currentSpeed = 0.0
    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    }
    func makeNoise() {
        // 什么都不做，，因为车辆不一定有噪音（交由子类定制）
    }
}
let someVehicle = Vehicle()
print("Vehicle: \(someVehicle.description)")

// 子类生成
class Bicycle: Vehicle {
    var hasBasket = false
}

let bicycle = Bicycle()
bicycle.hasBasket = true

bicycle.currentSpeed = 15.0
print("Bicycle: \(bicycle.description)")
// 打印 "Bicycle: traveling at 15.0 miles per hour"

// 子类可以继续被其他类继承
class Tandem: Bicycle {
    var currentNumberOfPassengers = 0
}
let tandem = Tandem()
tandem.currentNumberOfPassengers = 2
tandem.hasBasket = true
tandem.currentSpeed = 22.0
print("Tandem: \(tandem.description)")
// 打印："Tandem: traveling at 22.0 miles per hour"

// MARK: - 重写
class Train: Vehicle {
    override func makeNoise() {
         print("Choo Choo")
    }
}
let train = Train()
train.makeNoise()

// 属性的重写
// 只读属性可以重写为读写属性
// 读写属性不可以重写为只读属性
class Car: Vehicle {
    var gear = 1
    // 属性重写，必须写出属性名称跟类型，这样才能使编译器去检查你重写的属性是与 超类中同名同类型的属性 相匹配
    override var description: String {
        return super.description + " in gear \(gear)"
    }
}

let car = Car()
car.currentSpeed = 25.0
car.gear = 3
print("Car: \(car.description)")
// 打印 "Car: traveling at 25.0 miles per hour in gear 3"

// 重写属性观察器
class AutomaticCar: Car {
    override var currentSpeed: Double {
        didSet {
            gear = Int(currentSpeed / 10.0) + 1
        }
    }
}
let automatic = AutomaticCar()
automatic.currentSpeed = 35.0
print("AutomaticCar: \(automatic.description)")
// 打印 "AutomaticCar: traveling at 35.0 miles per hour in gear 4"

// MARK: - 防止重写
// @note 通过把方法、属性、下标标记为 final 来防止其被重写
// i.e. : final func / final var / final subscript 
// 也可以在 class 前面添加 final 来表示这个类是不允许被继承的 (final class)



//: [Next](@next)
