//: [Previous](@previous)


// MARK: - KVC Collection Operators
import Foundation

class Product {
    var name: String!
    var price: Double!
    var launchedOn: Date!
    
    public static func createProduct(name: String?, price: Double?, launchedOn: Date?) -> Product {
        let product = Product()
        product.name = name
        product.price = price
        product.launchedOn = launchedOn
        return product
    }
}

let product1 = Product.createProduct(name: "iPhone4", price: 100.0, launchedOn: Date())
let product2 = Product.createProduct(name: "iPhone5", price: 200.0, launchedOn: Date())
let product3 = Product.createProduct(name: "iPhone6", price: 300.0, launchedOn: Date())
let product4 = Product.createProduct(name: "iPhone7", price: 400.0, launchedOn: Date())
let products = [product1, product2, product3, product4]



//: [Next](@next)
