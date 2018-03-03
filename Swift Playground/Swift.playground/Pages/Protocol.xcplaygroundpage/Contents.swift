//: [Previous](@previous)

import Foundation

// MARK: - Protocol

// MARK: Protocol Synax

protocol FirstProtocol {
    // ...
}

/*
class SomeClass: SomeSuperClass, FirstProtocol, AnotherProtocol {

}
*/


// MARK: - 属性要求
// 协议可以要求遵守协议的类型提供特定的实例属性和类型属性
// 协议只指定属性的 名称 和 类型 以及 读写属性
// 如果协议要求属性是可读可写的，那么属性不可以是 常量 或 只读的计算型属性

// @note 协议总是用 var 来声明属性
// @note 在类型声明后面加上 { get set } 来表示读写属性
protocol SomeProtocol {
    var mustBeSettable: Int { get set }
    var doesNotNeedToBeSettable: Int { get }
}

// @note 协议声明类型属性时，用 static 作为类型前缀
// @note 当类类型遵守协议时，可用 class 作为类型前缀
protocol AnotherProtocol {
    static var someTypeProtocol: Int { get set }
}

// 这个协议表示：任何遵循 FullyNamed 协议的类型，
// 都必须有一个可读的 String 类型的 实例属性 fullName
protocol FullyNamed {
    var fullName: String { get }
}

struct Person: FullyNamed {
    var fullName: String
}
let john = Person(fullName: "John Appleseed")
// john.fullName 为 "John Appleseed"

class Starship: FullyNamed {
    var prefix: String?
    var name: String
    
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    
    var fullName: String {
        return (prefix != nil ? prefix! + " " : "" + name)
    }
}

var ncc1701 = Starship(name: "Enterprise", prefix: "USS")
// ncc1701.fullName 是 "USS Enterprise"


// MARK: - 方法要求
// 协议可以要求遵守协议的类型提供特定的实例方法和类型方法，不需要大括号 和 方法体
// @note 不支持给协议中的方法参数提供默认值

// @note 协议声明类型方法时，用 static 作为前缀
// @note 当类类型遵守协议时，可用 class 作为前缀

//protocol SomeProtocol {
//    static func someTypeFunc()
//}

// RandomNumberGenerator 协议并不关心每个随机数是如何生成的
// 它只要求必须提供一个随机数生成器
protocol RandomNumberGenerator {
    func random() -> Double
}

class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    func random() -> Double {
        lastRandom = ((lastRandom * a + c).truncatingRemainder(dividingBy:m))
        return lastRandom / m
    }
}
let generator = LinearCongruentialGenerator()
print("Here's a random number: \(generator.random())")
// 打印 “Here's a random number: 0.37464991998171”
print("And another one: \(generator.random())")
// 打印 “And another one: 0.729023776863283”


// MARK: - Mutating 方法要求
// 协议中实例方法可以使用 mutating 关键字，
// 来表示该实例方法可以改变 遵守该协议的类型 的实例

// @note 实现协议中的 mutating 方法时，如果是类类型，则可以不用写 mutating
//       如果是值类型（结构体，枚举），则必须写 mutating
protocol Togglable {
    mutating func toggle()
}

enum OnOffSwitch: Togglable {
    case On, Off
    mutating func toggle() {
        switch self {
        case .On:
            self = .Off
        case .Off:
            self = .On
        }
    }
}

var lightSwitch = OnOffSwitch.Off
lightSwitch.toggle()
// lightSwitch 现在的值为 .On


// MARK: - 构造器要求
// 协议可以要求遵守协议的类型实现指定的构造器
protocol SomeProtocol1 {
    init(someParameter: Int)
}

// 构造器要求在类中的实现
// 必须用 required 关键字
// 使用 required 关键字可以确保所有子类也必须提供此构造器实现，从而也能符合协议
class SomeClass: SomeProtocol1 {
    required init(someParameter: Int) {
        // ...
    }
}
// 用 final 关键字修饰的类（如： final class SomeClass），
// 就不需要在协议构造器的实现中使用 required 关键字，因为 final 类不能有子类

// 如果一个子类重写了父类的指定构造器，并且该构造器满足了某个协议的要求，
// 那么该构造器的实现需要同时标注 required 和 override 修饰符
protocol SomeProtocol2 {
    init()
}

class SomeSuperClass {
    init() {
        
    }
}

class SomeSubClass: SomeSuperClass, SomeProtocol2 {
    // 因为遵循协议，所以需要加上 required
    // 因为继承自父类，所以需要加上 override
    required override init() {
        // ...
    }
}


// MARK: - 协议作为类型
// 可以作为函数、方法或构造器中的参数类型、返回值类型
// 可以作为常量、变量或属性的类型
// 可以作为数组、字典或其他容器中的元素类型

// 协议作为常量类型
class Dice {
    let sides: Int
    let generator: RandomNumberGenerator
    init(sides: Int, generator: RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
}

var d6 = Dice(sides: 6, generator: LinearCongruentialGenerator())
for _ in 1...5 {
    print("Random dice roll is \(d6.roll())")
}
// Random dice roll is 3
// Random dice roll is 5
// Random dice roll is 4
// Random dice roll is 5
// Random dice roll is 4


// MARK: - 委托代理

protocol DiceGame {
    var dice: Dice { get }
    func play()
}

protocol DiceGameDelegate {
    func gameDidStart(_ game: DiceGame)
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
    func gameDidEnd(_ game: DiceGame)
}

// begin
class SnakesAndLadders: DiceGame {
    let finalSquare = 25
    let dice = Dice(sides: 6, generator: LinearCongruentialGenerator())
    var square = 0
    var board: [Int]
    init() {
//        board = [Int](count: finalSquare + 1, repeatedValue: 0)
        board = [Int](repeating: 0, count: finalSquare + 1)
        board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
        board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
    }
    var delegate: DiceGameDelegate?
    func play() {
        square = 0
        delegate?.gameDidStart(self)
        gameLoop: while square != finalSquare {
            let diceRoll = dice.roll()
            delegate?.game(self, didStartNewTurnWithDiceRoll: diceRoll)
            switch square + diceRoll {
            case finalSquare:
                break gameLoop
            case let newSquare where newSquare > finalSquare:
                continue gameLoop
            default:
                square += diceRoll
                square += board[square]
            }
        }
        delegate?.gameDidEnd(self)
    }
}

class DiceGameTracker: DiceGameDelegate {
    var numberOfTurns = 0
    func gameDidStart(_ game: DiceGame) {
        numberOfTurns = 0
        if game is SnakesAndLadders {
            print("Started a new game of Snakes and Ladders")
        }
        print("The game is using a \(game.dice.sides)-sided dice")
    }
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int) {
        numberOfTurns += 1
        print("Rolled a \(diceRoll)")
    }
    func gameDidEnd(_ game: DiceGame) {
        print("The game lasted for \(numberOfTurns) turns")
    }
}

// end

// MARK: - 通过扩展添加协议一致性
// 即时无法修改源代码，依然可以通过扩展使已有类型遵循并符合协议
protocol TextRepresentable {
    var textualDescription: String { get }
}

extension Dice: TextRepresentable {
    var textualDescription: String {
        return "A \(sides)-sided dice"
    }
}
// 现在所有 Dice 类型的实例都可以看做 TextRepresentable 类型
let d12 = Dice(sides: 12, generator: LinearCongruentialGenerator())
print(d12.textualDescription)
// 打印 “A 12-sided dice”


// MARK: - 通过扩展遵循协议
// 当一个类型已经符合了协议中的所有要求，却还没有声明遵循该协议时，
// 可以通过空扩展体的扩展来遵循协议
struct Hamster {
    var name: String
    var textualDescription: String {
        return "A hamster named \(name)"
    }
}

extension Hamster: TextRepresentable {}

// MARK: - 协议类型的集合
let things: [TextRepresentable] = [d12]
for thing in things {
    print(thing.textualDescription)
    // 类型转换
    if let dice = thing as? Dice {
        print(dice.sides)
    }
    // 类型转换
    if thing is Dice {
        print("thing is a Dice type")
    }
}


// MARK: - 协议的继承（类似 类的继承）
protocol InheritingProtocol: SomeProtocol, AnotherProtocol {
    // 这里是协议的定义部分
}
protocol PrettyTextRepresentable: TextRepresentable {
    var prettyTextualDescription: String { get }
}


// MARK: - 类类型专属协议
// 可以在协议的继承列表中，通过添加 class 关键字来限制协议只能被类类型遵循
// 而结构体、枚举不能遵循该协议
// class 关键字必须第一个出现在协议的继承列表中
protocol SomeClassOnlyProtocol: class, TextRepresentable {
    
}

// class
class TestClass: SomeClassOnlyProtocol {
    var textualDescription: String {
        return "test"
    }
}
// struct || enum 报错
// error: non-class type 'TextStruct' cannot conform to class protocol
//struct TextStruct: SomeClassOnlyProtocol {
//    
//}


// MARK: - 协议合成
// 符号 &
protocol Named {
    var name: String { get }
}
protocol Aged {
    var age: Int { get }
}

struct Person1: Named, Aged {
    var name: String
    var age: Int
}

func wishHappyBirthday(to celebrator: Named & Aged) {
    print("Happy birthday, \(celebrator.name), you're \(celebrator.age)!")
}

let birthdayPerson = Person1(name: "Joey", age: 21)
wishHappyBirthday(to: birthdayPerson)


// MARK: - 检查协议一致性（与检查类型一致）
// is 检查类型是否遵循了协议 返回 true / false
// as? 返回可选值，实例符合某个协议时，返回实例为协议类型的可选值，否则返回 nil
// as! 强制转换



// MARK: - 可选的协议要求
// 协议可以定义可选要求，遵循协议的类型可以选择是否实现这些要求
// 用 optional 作为前缀来定义可选要求
// 可选要求用在 需要与 Objective-C 打交道的代码中
// 协议和要求都必须带上 @objc 属性
// 标记 @objc 属性的协议只能被 继承自 Objective-C 的类 或者 @objc 类遵循，不能被结构体、枚举遵循

// 使用协议的可选要求时（e.g. 属性、方法），它们的类型会自动变成可选的 Int -> Int?

// 协议中的可选要求可以通过 可选链式调用 来使用，因为遵循协议的类型可能没有实现该可选要求
// e.g. SomeOptionalMethod?(someArgument)
@objc protocol CounterDataSource {
    @objc optional func incrementForCount(count: Int) -> Int
    @objc optional var fixedIncrement: Int { get }
}

class Counter {
    var count = 0
    var dataSource: CounterDataSource?
    func increment() {
        if let amount = dataSource?.incrementForCount?(count: count) {
            count += amount
        } else if let amount = dataSource?.fixedIncrement {
            count += amount
        }
    }
}


// MARK: - 协议扩展
// 协议可以通过扩展来为遵循协议的类型提供 属性、方法、下标 的实现
// 通过这种方式，可以通过协议本身来实现这些功能
// 而无需在每个遵循协议的类型中重复同样的实现，也无需使用全局函数
extension RandomNumberGenerator {
    func RandomBool() -> Bool {
        return random() > 0.5
    }
}

let generator1 = LinearCongruentialGenerator()
print(generator1.random())
print(generator1.RandomBool()) // 协议本身就提供了这个实现，所以可以直接调用


// MARK: - 默认实现
// 协议可以通过扩展来为协议的属性、方法、下标提供 默认的实现
// 如果遵循协议的类型为这些要求提供了自己的实现，那么自定义的实现会覆盖掉扩展中提供的默认实现

// 通过协议扩展为协议提供的默认实现 和 可选的协议要求 不同，虽然这两种情况下，遵守协议的类型都无需提供要求
// 但是扩展提供的默认实现可以直接调用，而无需使用可选链式调用
extension PrettyTextRepresentable {
    var prettyTextualDescription: String {
        return textualDescription
    }
}

// MARK: - 为协议扩展添加限制条件
// 在扩展协议的时候，可以指定一些限制条件，
// 只有遵循协议的类型满足这些限制条件时，才能获得扩展提供的默认实现
// 限制条件写在协议名之后，使用 where 子句来描述

// 扩展 Collection 协议，但只适用于 集合中的元素遵循了 TextRepresentable 协议的情况：
extension Collection where Iterator.Element: TextRepresentable {
    var textualDescription: String {
        let itemsAsText = self.map { $0.textualDescription  }
        return "[" + itemsAsText.joined(separator: ",") + "]"
    }
}
// Hamster 遵守 TextRepresentable 协议
let murrayTheHamster = Hamster(name: "Murray")
let morganTheHamster = Hamster(name: "Morgan")
let mauriceTheHamster = Hamster(name: "Maurice")
let hamsters = [murrayTheHamster, morganTheHamster, mauriceTheHamster]
// 因为 hamsters 数组的元素是 Hamster 类型，遵守了 TextRepresentable 协议，
// 所以可以使用 textualDescription 的默认实现
print(hamsters.textualDescription)

// @note 如果多个协议扩展都为同一个协议要求提供了默认实现，而遵守协议的类型又同时满足了这些协议扩展的限制条件，
//       那么就会采用 限制条件最多 的那个协议扩展的实现




//: [Next](@next)
