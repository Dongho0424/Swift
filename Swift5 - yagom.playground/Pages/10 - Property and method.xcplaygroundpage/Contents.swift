import Foundation
import Swift

var won: Int = 2000 {
    willSet{
        print("\(won)에서 \(newValue)로 바뀔 예정입니다.")
    }
    didSet {
        print("\(oldValue)에서 \(won)으로 바뀌었습니다.")
    }
}

won = 3000
var dollar: Double {
    get {
        return Double(won) / 1000.0
    }
    set {
        won = Int(newValue * 1000.0)
        print("변경 중")
    }
}

dollar = 5.5

// Key Path
class Person {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

struct Stuff {
    var name: String
    var owner: Person
}

let dongho: Person = Person(name: "dongho")
let macbook = Stuff(name: "MacBook Pro", owner: dongho)

let stuffNameKeyPath = \Stuff.name
let ownerkeyPath: WritableKeyPath<Stuff, Person> = \Stuff.owner
let ownerNameKeyPath = ownerkeyPath.appending(path: \.name)

struct Employee {
    let name: String
    let nickname: String?
    let age: Int
    
    var isAdult: Bool{
        return age > 20
    }
}

let d = Employee(name: "d", nickname: nil, age: 21)
let g = Employee(name: "g", nickname: "pig", age: 22)
let m = Employee(name: "m", nickname: "head", age: 25)
let coin = Employee(name: "coin", nickname: "alt", age: 15)

let family: [Employee] = [d, g, m, coin]

let names = family.map(\.name); print(names)
let nicknames = family.compactMap(\.nickname); print(nicknames)
let ages = family.filter{$0.isAdult}.map(\.name); print(ages)

/// call-as-function method
struct Puppy {
    var name: String = "멍멍이"
    
    func callAsFunction() {
        print("멍멍")
    }
    
    func callAsFunction(color: String) -> String {
        return color + " 응가"
    }
}

let doggy = Puppy()
doggy()

print(doggy(color: "sky blue"))

// type method and type property

class AClass {
    
    var n = 2
    
    static var a = 5
    
    var getN: Int {
        return n
    }
    
    static func staticFunc(){
        print("AClass: staticFunc")
    }
    
    class func classFunc(){
        print("AClass: classFunc")
    }
}

class BClass: AClass {
//    override static func staticFunc(){
//
//    }
    
//    override static var a = 10 // cannot override stored property
    
    override var getN: Int {
        return self.n + 1
    }
    
    override class func classFunc() {
        print("BClass: classFunc")
        self.a = 10
        BClass.a = 520
        AClass.a = 100
    }
}

