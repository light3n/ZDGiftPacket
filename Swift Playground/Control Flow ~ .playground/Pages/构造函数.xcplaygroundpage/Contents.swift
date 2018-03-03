//: [Previous](@previous)

import Foundation


// MARK: - 构造函数
class Father {
    var age = 0
    init(age: Int) {
        self.age = age
    }
}

class Son: Father {
    var height = 0.0
    init(age: Int, height: Double) {
        super.init(age: age)
        self.height = height
    }
}

let son = Son.init(age: 20, height: 160)
print("son: \(son.age) years old, tall: \(son.height)")

// MARK: - 必要构造器
class SomeClass {
    required init() {
        
    }
}
// 子类重写父类的必要构造器时，必须在前面也添加 required
class SomeSubClass: SomeClass {
    required init() {
        
    }
}

// MARK: - 通过闭包或函数设置属性的默认值
class SomeClass2 {
    let someProperty: String = {
        // 在这个闭包中给 someProperty 创建一个默认值
        // someValue 必须和 someProperty 的类型相同，这里是 String
        return "a string"
    }()
}
// 每当某个属性所在类型的新实例被创建时，对应的闭包或函数就会被调用
// 而它们的返回值会当做默认值赋值给这个属性
let someClass = SomeClass2()
print("someClass2.someProperty: \(someClass.someProperty)")



//: [Next](@next)
