//: [Previous](@previous)

import Foundation

/// 定义一个类层次作为例子

class MediaItem {
    var name: String
    init(name: String) {
        self.name = name
    }
}

class Movie : MediaItem {
    var director: String
    init(name: String, director: String) {
        self.director = director
        super.init(name: name)
    }
}

class Song : MediaItem {
    var artist: String
    init(name: String, artist: String) {
        self.artist = artist
        super.init(name: name)
    }
}

let library = [
    Movie(name: "Casablanca", director: "Michael Curtiz"),
    Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
    Movie(name: "Citizen Kane", director: "Orson Welles"),
    Song(name: "The One And Only", artist: "Chesney Hawkes"),
    Song(name: "Never Gonna Give You Up", artist: "Rick Astley")
]
// Swift 的类型检测器能够推断出 Movie 和 Song 有共同的父类 MediaItem
// 所以数组 library 的类型被推断为 [MediaItem]

/// 检查类型
// 用类型检查符 is 来检查实例是否属于特定子类型，如果是，类型检测操作符返回 true，否则返回 false
var movieCount = 0
var songCount = 0
for item in library {
    if item is Movie {
        movieCount += 1
    } else if item is Song {
        songCount += 1
    }
}
print("Media library contains \(movieCount) movies and \(songCount) songs")
// 打印 Media library contains 2 movies and 3 songs

/// 向下转型
// 某个类型的一个常量或者变量在幕后实际上属于某个子类。当确定是这种情况时，你可以用类型转换符将它向下转换成它的子类型
// as? 类型转换符 类似可选值 转换失败会返回 nil，从而得知是否转换失败
// as! 类型转换符 强制转换，转换失败会导致运行时错误
for item in library {
    if let movie = item as? Movie {
        print("Movie: '\(movie.name)', dir. \(movie.director)")
    } else if let song = item as? Song {
        print("Song: '\(song.name)', by \(song.artist)")
    }
}

/// Swift 为不确定类型提供了两种特殊的类型别名：
// Any 可以表示任何类型，包括函数类型
// AnyObject 可以表示任何类类型的实例

var things = [Any]()
things.append(0.0)
things.append("abc")
things.append(Movie(name: "Ghostbusters", director: "Ivan Reitman"))
things.append( { (name: String) -> String in "Hello \(name)"} )

// 如果要用 Any 承载可选值，你可以使用 as 来显示转换为 Any
let optionalNumber: Int? = 3
//things.append(optionalNumber) //警告
things.append(optionalNumber as Any) //没有警告







//: [Next](@next)
