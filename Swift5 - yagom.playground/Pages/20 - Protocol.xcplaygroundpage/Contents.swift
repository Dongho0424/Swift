import Foundation

protocol Receiveable {
    func received(data: Any, from: Sendable)
}

protocol Sendable{
    var from: Sendable { get }
    var to: Receiveable? { get }
    
    func send(data: Any)
    
    static func isSendableInstance(_ instance: Any) -> Bool
}

class Message: Receiveable, Sendable {
    var data: Any?
    
    var from: Sendable {
        return self
    }
    var to: Receiveable?
    
    func send(data: Any) {
        guard let receiver: Receiveable = self.to else {
            print("Message. no receiver")
            return
        }
        
        receiver.received(data: data, from: self)
    }
    
    func received(data: Any, from: Sendable) {
        self.data = data
        print("message is received from \(from).")
    }
    
    class func isSendableInstance(_ instance: Any) -> Bool {
        if let sendableInstance: Sendable = instance as? Sendable {
            return sendableInstance.to != nil
        }
        return false
    }
}

class PublicAlert: Sendable {
    var data: Any?
    
    var from: Sendable {
        return self
    }
    var to: Receiveable?
    
    func send(data: Any) {
        guard let receiver: Receiveable = self.to else {
            print("Message. no receiver")
            return
        }
        
        receiver.received(data: data, from: self)
    }
    class func isSendableInstance(_ instance: Any) -> Bool {
        if let sendableInstance: Sendable = instance as? Sendable {
            return sendableInstance.to != nil
        }
        return false
    }
}

let myMsg: Message = Message()
let yourMsg: Message = Message()
myMsg.send(data: "myMsg Data")

myMsg.to = yourMsg
myMsg.send(data: "myMsg Data")

let publicAlert: PublicAlert = PublicAlert()
publicAlert.to = myMsg
publicAlert.send(data: "yeoksam corona: 19 ")

print(PublicAlert.isSendableInstance(myMsg))

// 20.3.3
protocol Resetable{
    mutating func reset()
}

class Person_0: Resetable {
    var name: String?
    var age: Int?
    
    func reset() {
        self.name = nil
        self.age = nil
    }
}

struct Point: Resetable {
    var x: Int
    var y: Int
    
    mutating func reset() {
        self.x = 0
        self.y = 0
    }
}

enum Direction: Resetable {
    case east, west, south, north, unknown
    
    mutating func reset() {
        self = .unknown
    }
}

// 20.3.4
protocol Named_0 {
    var name: String { get }
    
    init(name: String)
}

struct Pet: Named_0 {
    var name: String
    
    init(name: String){
        self.name = name
    }
}

class Person2: Named_0 {
    var name: String
    
    required init(name: String) {
        self.name = name
    }
}

class School {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

class MiddleSchool: School, Named_0 {
    required override init(name: String){
        super.init(name: name)
    }
}
// failable initializer

protocol Named_1 {
    var name: String { get }
    
    init?(name: String)
}

struct Person3: Named_1 {
    var name: String
    
    init?(name: String) {
        self.name = name
    }
}

class Animal: Named_1 {
    var name: String
    
    required init(name: String) {
        self.name = name
    }
}

// 20.4
protocol Readable {
    func read()
}

protocol Writeable {
    func write()
}

protocol ReadSpeakable: Readable {
    func speak()
}

protocol ReadWriteSpeakable: Readable, Writeable {
    func speak()
}

class SomeClass: ReadWriteSpeakable {
    func speak() {
        print(1)
    }
    
    func read() {
        print(1)
    }
    
    func write() {
        print(1)
    }
}

protocol ClassOnlyProtocol: class, Readable, Writeable {}

class SomeClass2: ClassOnlyProtocol {
    func read() {
        print("read")
    }
    
    func write() {
        print("write")
    }
}

// 20.5 protocol 조합 & protocol 준수 확인
protocol Numeric1 {}

protocol Named{
    var name: String {get}
}

protocol Aged: Numeric1 {
    var age: Int {get}
}

struct Person: Named, Aged {
    var name: String
    var age: Int
}

class Car: Named{
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

class Truck: Car, Aged {
    var age: Int
    
    init(name: String, age: Int){
        self.age = age
        super.init(name: name)
    }
}

func checkNameAge(to: Named & Aged) {
    print("name:", to.name)
    print("age:", to.age)
}

let d: Person = Person(name: "dongho", age: 22)
checkNameAge(to: d)

let myCar: Car = Car(name: "Porsche Carrera 911")
//checkNameAge(to: myCar)

//var cannotMix: Car & Truck & Named

var someVariable: Car & Aged

someVariable = Truck(name: "potter", age: 2)

//someVariable = myCar

print(d is Named)
print(d is Aged)

print(myCar is Aged)

if let castedInstance: Named = d as? Named {
    print("\(castedInstance) is Named")
}

// 20.6 protocol optional
@objc protocol Moveable{
    func walk()
    @objc optional func fly()
}

class Tiger: NSObject, Moveable {
    func walk() {
        print("Tiger Walks")
    }
}

class Bird: NSObject, Moveable {
    func walk() {
        print("Bird walks")
    }
    func fly() {
        print("Bird flys")
    }
}

let tiger: Tiger = Tiger()
let bird: Bird = Bird()

tiger.walk()
//tiger.fly?()

var moveableInstance: Moveable = Tiger()
moveableInstance.walk()
moveableInstance.fly?()

moveableInstance = Bird()
moveableInstance.walk()
moveableInstance.fly?()
