import Foundation

// Protocol Default Implementations
protocol Receiveable {
    var data: Any? { get set }
    mutating func received(data: Any, from: Sendable)
}
extension Receiveable {
    mutating func received(data: Any, from: Sendable){
        self.data = data
        print("message is received from \(from).")
    }
}

protocol Sendable{
    var from: Sendable { get }
    var to: Receiveable? { get }
    
    func send(data: Any)
    
    static func isSendableInstance(_ instance: Any) -> Bool
}
extension Sendable{
    var from: Sendable {
        return self
    }
    func send(data: Any) {
        guard var receiver: Receiveable = self.to else {
            print("Message. no receiver")
            return
        }
        
        receiver.received(data: data, from: self)
    }
    
    static func isSendableInstance(_ instance: Any) -> Bool {
        if let sendableInstance: Sendable = instance as? Sendable {
            return sendableInstance.to != nil
        }
        return false
    }
}

class Message: Receiveable, Sendable {
    // stored property cannot be declared in protocol and its extension
    // so, declaring here
    var data: Any?
    var to: Receiveable?
}

class Mail: Receiveable, Sendable {
    var data: Any?
    var to: Receiveable?
    
    // re-declaration
    func send(data: Any) {
        print("send method. Redeclared in Mail.")
        
        guard var receiver: Receiveable = self.to else {
            print("Message. no receiver")
            return
        }
        
        receiver.received(data: data, from: self)
    }
}

class PublicAlert: Sendable {
    var to: Receiveable?
}

let myMsg: Message = Message()
let yourMsg: Message = Message()
myMsg.send(data: "myMsg Data")

myMsg.to = yourMsg
myMsg.send(data: "myMsg Data")

let publicAlert: PublicAlert = PublicAlert()
publicAlert.to = myMsg
publicAlert.send(data: "yeoksam corona: 19 ")

print(myMsg.data!)

print(PublicAlert.isSendableInstance(myMsg))

// another ex
///////////
protocol SelfPrintable {
    func printSelf()
}
extension SelfPrintable where Self: Container {
    func printSelf(){
        print("printSelf, protocol SelfPrintable extension")
        print(items)
    }
}


class foo {
    var asd = [1, 3]
    // computed property
    var items: [Int] {
        get {
            return [1, 2]
        }
        set {
            self.asd = newValue
        }
    }
}
class doo {
    // stored property
    var items = [1, 2]
}

protocol Container: SelfPrintable {
    associatedtype Element
    
    var items: [Element] { get set }
    var count: Int { get }
    
    mutating func append(item: Element)
    subscript(i: Int) -> Element { get }
}
extension Container {
    var count: Int {
        return self.items.count
    }
    
    mutating func append(item: Element){
        self.items.append(item)
    }
    
    subscript(i: Int) -> Element {
        return self.items[i]
    }
}

protocol Popable: Container {
    mutating func pop() -> Element?
    mutating func push(_ item: Element)
}
extension Popable {
    mutating func pop() -> Element? {
        return self.items.removeLast()
    }
    mutating func push(_ item: Element) {
        self.items.append(item)
    }
}

protocol Insertable: Container {
    mutating func delete() -> Element?
    mutating func insert(_ item: Element)
}
extension Insertable {
    mutating func delete() -> Element? {
        return self.items.removeFirst()
    }
    mutating func insert(_ item: Element) {
        self.items.append(item)
    }
    
}

struct Stack<Element>: Popable {
    var items: [Element] = [Element]()
    mutating func pop() -> Element? {
        print("hi")
        return self.items.removeLast()
    }
}

struct Queue<Element>: Insertable {
    var items: [Element] = [Element]()
}

var intStack: Stack<Int> = Stack<Int>()
var stringStack: Stack<String> = Stack<String>()

intStack.push(0)
intStack.push(1)
intStack.printSelf()
intStack.pop()
intStack.printSelf()

    // custom map func in Stack
extension Stack {
    func map<T>(_ transform: (Element) -> T) -> Stack<T> {
        var result: Stack<T> = Stack<T>()
        for item in self.items {
            result.items.append(transform(item))
        }
        return result
    }
}

intStack.map{(e: Int) -> String in return "\(e)"}
intStack.printSelf()
let intStringStack = intStack.map{"\($0)"}
intStringStack.printSelf()

    // custom filter func in Stack
extension Stack {
    func filter(_ tranform: (Element) -> Bool) -> Self {
        var result: Self = Self()
        for item in items {
            if tranform(item) {
                result.items.append(item)
            }
        }
        return result
    }
}

intStack.push(1);intStack.push(10);intStack.push(2);
intStack.printSelf()
let filteredStack: Stack<Int> = intStack.filter{ $0 < 10 }
filteredStack.printSelf()

    // custom reduce func in Stack
extension Stack {
    func reduce<T>(_ initialResult: T, nextPartialResult: (T, Element) -> T) -> T{
        var result: T = initialResult
        for item in self.items {
            result = nextPartialResult(result, item)
        }
        return result
    }
    
    func reduce<Result>(into initialResult: Result, _  updateAccumulatingResult: (inout Result, Element) -> Void) -> Result {
        var result: Result = initialResult
        for item in self.items {
            updateAccumulatingResult(&result, item)
        }
        return result
    }
}

var reducedNum = intStack.reduce(0){$0 + $1}
print(reducedNum)

var reducedNum2 = intStack.reduce(into: 0){result, element in result += element}
print(reducedNum2)

let temp = [1, 2]
temp.reduce(into: 0, { (result: inout Int, element: Int) in
    result = result + element
})

let realTemp = temp.flatMap{ (e: Int) -> [Int] in
    return [e]
}; print("realTemp:", realTemp)

    // flatMap Test
//  func flatMap<SegmentOfResult>(_ transform: (Self.Element) throws -> SegmentOfResult) rethrows -> [SegmentOfResult.Element] where SegmentOfResult : Sequence
let temp2 = [[1, 2, 3], [12, 23], [23, 45]]
let flatted = temp2.flatMap{ "\($0)" }
let flatted1 = temp2.flatMap { (e: [Int]) -> [Character] in
    var result = [Character]()
    for char in "\(e)" {
        result.append(char)
    }
    return result
}
let flatted2 = temp2.flatMap{ (e: [Int]) -> [Int] in
    return e
}; print("flatted2:",flatted2)

let temp3 = [[[1,2], [3,4]], [[10],[20], [30, 40]]]
let flattedddd = temp3.flatMap{$0.flatMap{$0}}; print(flattedddd)

extension Stack {
    func flatMap<SegmentOfResult>(_ transform: (Element) -> SegmentOfResult) -> [SegmentOfResult.Element] where SegmentOfResult: Sequence {
        var result = [SegmentOfResult.Element]()
        for item in self.items {
            result.append(contentsOf: transform(item))
        }
        return result
    }
}

var nestedStack = Stack<[Int]>()
nestedStack.push([1, 2, 3])
nestedStack.push([10, 20, 5])
nestedStack.push([5])
nestedStack.printSelf()

let myFlatted = nestedStack.flatMap{$0}
print(myFlatted)

var donghoArr = [1, 2, 3]
donghoArr.append(contentsOf: [4, 5]); print(donghoArr)
