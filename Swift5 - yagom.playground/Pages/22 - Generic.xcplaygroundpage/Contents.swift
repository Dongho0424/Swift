import Foundation

prefix operator **

prefix func ** <T: BinaryInteger> (value: T) -> T {
    return value * value
}

let five: UInt = 5
print(**five)

func swap<T>(_ a: inout T, _ b: inout T) {
    let temp = a
    a = b
    b = temp
}

var a = 10
var b = 25
swap(&a, &b) // func에는 generic 의 특정 타입을 적지 않는다.
print(a, b)

struct Stack_0<Element> {
    var items = [Element]()
    mutating func push(_ item: Element){
        self.items.append(item)
    }
    
    mutating func pop() -> Element{
        return self.items.removeLast()
    }
}

// generic struct 확장
extension Stack_0 {
    
}

var stringStack: Stack_0<String> = Stack_0<String>()

func makeDict<Key: Hashable, Value>(key: Key, value: Value) -> Dictionary<Key, Value> {
    let dict: Dictionary<Key, Value> = [key: value]
    return dict
}

// associated type in protocol
protocol Container {
    associatedtype Element
    var count: Int { get }
    mutating func append(_ item: Element)
    subscript(e: Int) -> Element { get }
}

class Arrray: Container {
    var items: Array<Int> = [Int]()
    
    var count: Int {
        get{
            return self.items.count
        }
    }
    
    func append(_ item: Int) {
        items.append(item)
    }
    
    subscript(e: Int) -> Int {
        return items[e]
    }
}

struct Stack<Element>: Container {
    var items = [Element]()
    
    mutating func push(_ item: Element){
        self.items.append(item)
    }
    
    mutating func pop() -> Element{
        return self.items.removeLast()
    }
    
    var count: Int {
        return self.items.count
    }
    
    mutating func append(_ item: Element) {
        items.append(item)
    }
    
    subscript(e: Int) -> Element {
        return items[e]
    }
    
}

extension Stack {
    subscript<Indices: Sequence>(indices: Indices) -> [Element]
        where Indices.Iterator.Element == Int {
        
        var result = [Element]()
        for index in indices {
            result.append(self[index])
        }
        return result
    }
}

var integerStack: Stack<Int> = Stack<Int>()
integerStack.append(0)
integerStack.append(1)
integerStack.append(2)
integerStack.append(3)
integerStack.append(4)

print(integerStack[1...4])

//Sequence
