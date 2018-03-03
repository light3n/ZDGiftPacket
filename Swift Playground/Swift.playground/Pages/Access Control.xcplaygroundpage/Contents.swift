//: [Previous](@previous)

import Foundation

// MARK: - 访问控制
// 默认访问级别为：internal 内部访问

/*
 open开放访问 / public公开访问：可以访问同一模块内的任何实体，在模块外也能通过导入该模块来访问源文件内的所有实体。（框架内接口可以被任何人使用）
 internal 内部访问：可以访问同一模块内的任意实体，但是不能从模块外访问该模块源文件内的实体。（某个接口只能在应用程序或模块内使用）
 fileprivate 文件私有访问：限制实体只能被所定义的文件内部访问。（当需要把这些细节被整个文件使用的时候，使用 fileprivate 可以隐藏特定功能的实现细节）
 private 私有访问：限制实体只能被所定义的作用域内使用。
 */


// MARK: - 自定义类型
// 为自定义类型指定访问级别：在定义类型的同时进行指定即可
// 类型访问级别 会影响到 类型成员（方法、函数、构造器、下标）的默认访问级别

// 类型指定为文件私有/私有访问级别，其成员也是文件私有/私有访问级别
// class: fileprivate/private -> property: fileprivate/private

// 类型指定为公开/内部访问级别，其成员则是内部访问级别
// class: public/internal     -> property: internal

// 如果需要指定某个类型成员为 公开访问级别，则需显示指定
// 这样做的好处是：可以明确指定哪些接口是需要公开的，哪些是内部使用的，避免不小心将内部使用的接口公开。

public class SomePublicClass {                  // 显式公开类
    public var somePublicProperty = 0            // 显式公开类成员
    var someInternalProperty = 0                 // 隐式内部类成员
    fileprivate func someFilePrivateMethod() {}  // 显式文件私有类成员
    private func somePrivateMethod() {}          // 显式私有类成员
}

class SomeInternalClass {                       // 隐式内部类
    var someInternalProperty = 0                 // 隐式内部类成员
    fileprivate func someFilePrivateMethod() {}  // 显式文件私有类成员
    private func somePrivateMethod() {}          // 显式私有类成员
}

fileprivate class SomeFilePrivateClass {        // 显式文件私有类
    func someFilePrivateMethod() {}              // 隐式文件私有类成员
    private func somePrivateMethod() {}          // 显式私有类成员
}

private class SomePrivateClass {                // 显式私有类
    func somePrivateMethod() {}                  // 隐式私有类成员
}

// MARK: - 元组类型
// 元组的访问级别将由元组中访问级别最严格的类型决定
// e.g. tuple(internal, private) 则 tuple 的访问级别为 private

// MARK: - 函数类型
// 函数的访问级别根据访问级别最严格的参数类型或返回类型的访问级别来决定。
// 如果这种访问级别不符合函数定义所在环境的默认访问级别，则需明确指定该函数的访问级别
private func someFunction() -> (SomeInternalClass, SomePrivateClass) {
    // 此处是函数实现部分
    return (SomeInternalClass(), SomePrivateClass())
}

// MARK: - 枚举类型
// 枚举成员的访问级别和该枚举类型相同，你不能为枚举成员单独指定不同的访问级别。
public enum CompassPoint {
    case North
    case South
    case East
    case West
}

// MARK: - 子类
// 子类的访问级别不能比父类的访问级别高
// 可以通过重写 为继承来的类成员 提供更高的访问级别
public class A {
    private func someMethod() {
    
    }
}

internal class B: A {
//    override internal func someMethod() {
//        
//    }
}


// MARK: - Getter & Setter
// 常量、变量、属性、下标的 Getters 和 Setters 的访问级别和它们所属类型的访问级别相同。
// Setter 的访问级别可以 低于 对应的 Getter 访问级别，这样就可以控制属性、变量或下标的读写权限
// 在 var / subscript 关键字前，通过 fileprivate(set)、private(set)、internal(set) 为它们的写入权限指定更低的访问级别。

struct TrackedString {
    // Setter 的访问级别是 Private，表示属性只有在当前源文件中是可读写的，而在当前源文件所属的模块中是只读的
    private(set) var numberOfEdits = 0
    var value: String = "" {
        didSet {
            numberOfEdits += 1
        }
    }
}

var stringToEdit = TrackedString()
stringToEdit.value = "This string will be tracked."
stringToEdit.value += " This edit will increment numberOfEdits."
stringToEdit.value += " So will this one."
print("The number of edits is \(stringToEdit.numberOfEdits)")
// 打印 “The number of edits is 3”


// 指定类型访问级别为 public
public struct TrackedString1 {
    // 显式指定属性的 Getter 访问级别为 public， 而 Setter 访问级别为 private
    public private(set) var numberOfEdits = 0
    // 显式指定属性的访问级别为 public
    public var value: String = "" {
        didSet {
            numberOfEdits += 1
        }
    }
    public init() {}
}



//: [Next](@next)
